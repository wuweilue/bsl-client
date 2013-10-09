//
//  FPTaskTeamMemberViewController.m
//  pilot
//
//  Created by Sencho Kong on 12-11-6.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPTaskTeamMemberViewController.h"
#import "FPCoordinatingController.h"
#import "MBProgressController.h"
#import "BaseQuery.h"
#import "Member.h"
#import "FileQuery.h"
#import "FPPicDownloader.h"
#import "Member.h"

@interface FPTaskTeamMemberViewController (){
    
   
}



@end

@implementation FPTaskTeamMemberViewController
@synthesize listOfMembers;
@synthesize fltTask;
@synthesize imageDownloadsInProgress;


-(void)dealloc{
  
    [listOfMembers release];
    [fltTask release];
    [imageDownloadsInProgress release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    
    self.title=@"机组成员";
    
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    leftButtonItem.tag=kbuttonTagBack;
    self.navigationItem.leftBarButtonItem=leftButtonItem;
    [leftButtonItem release];
    
}

NSInteger order(Member* member1, Member* member2, void *context)
{
    NSArray* orderArray=[NSArray arrayWithObjects:@"CAP",@"F/O",@"HA",@"FAT",@"AT",@"SG", nil];
    
    int v1 = [orderArray indexOfObject:member1.position ];
    int v2 = [orderArray indexOfObject:member2.position ];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}


-(void)requestChangeView:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    int count=self.listOfMembers.count;
    if (count == 0)
	{
        //默认显示10行；
        return 10;
    }

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count =self.listOfMembers.count;
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    if (count == 0 && indexPath.row==0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
		cell.detailTextLabel.text = @"加载中…";
		
		return cell;
    }
    
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
    
    if (count>0) {
        
        Member* member=[self.listOfMembers objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines=0;
        cell.textLabel.font=[UIFont systemFontOfSize:17];
        cell.textLabel.text=[NSString stringWithFormat:@"工号：%@ \n姓名：%@\n职务：%@\n基地：%@\n出生日期：%@\n飞行准备：%@",member.empId, member.chnName,member.position,member.base,member.birthDtT,member.readyFlag];
        
       
     
        
        if (!member.image){
           
            cell.imageView.image = [UIImage imageNamed:@"Icon_member_56X56"];
            
            //当table是停止拖动和不静止时，检查头像图片是否存在本地，如果不存在就下载，存存就显示
            if (tableView.dragging == NO && tableView.decelerating == NO)
            {
                
                NSString *localPath = [NSString stringWithFormat:@"%@/%@",[self getDownloadDirectoryWithCategory:HEAD_PIC],[member.empId stringByAppendingPathExtension:@"jpg"]];
                if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]){
                    
                    
                    UIImage* cacheImage=[UIImage imageWithContentsOfFile:localPath];
                    
                    if (cacheImage) {
                        member.image=cacheImage;
                        cell.imageView.image=cacheImage;
                        return cell;
                    }else{
                        [self startImageDownload:member forIndexPath:indexPath];
                    }
                   
                    
                    
                  
                }else{
                     [self startImageDownload:member forIndexPath:indexPath];
                   
                }
               
            }
        
        }
        else {
            cell.imageView.image = member.image;
        }
        
    }
    
 
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

-(NSString *)getDownloadDirectoryWithCategory:(NSString *)category{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *downloadURL = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"tempFile/%@",category] isDirectory:YES];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:[downloadURL path] isDirectory:&isDir]) {
        NSLog(@"目录%@不存在！",[downloadURL path]);
        NSError *err;
        if(![fileManager createDirectoryAtPath:[downloadURL path] withIntermediateDirectories:YES attributes:nil error:&err])
        {
            NSLog(@"%@",err);
        }
    }
    return [downloadURL path];
}


#pragma mark -
#pragma mark Table cell image support

- (void)startImageDownload:(Member*)member forIndexPath:(NSIndexPath *)indexPath
{
    
     FPPicDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[FPPicDownloader alloc] init];
        imageDownloader.member = member;
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate=self;       
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];        
        [imageDownloader startDownloadNew];
        [imageDownloader release];
    }
    
  

}


- (void)loadImagesForOnscreenRows
{
    if ([self.listOfMembers count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Member *member = [self.listOfMembers objectAtIndex:indexPath.row];
            
            if (!member.image) 
            {
                [self startImageDownload:member forIndexPath:indexPath];
            }
        }
    }
}


- (void)imageDidLoad:(NSIndexPath *)indexPath;
{
    FPPicDownloader* imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: imageDownloader.indexPathInTableView];
        if (imageDownloader.member.image) {
            cell.imageView.image = imageDownloader.member.image; 
        }
       
        
    }
    
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    }else{
        if (interfaceOrientation==UIInterfaceOrientationPortrait) {
            return YES;
        }
        return NO;
    }
}


@end
