//
//  FPFlightReportViewController.m
//  pilot
//
//  Created by Sencho Kong on 13-1-8.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "FPFlightReportViewController.h"
#import "FPAirlineAnnounceCell.h"
#import "FPCoordinatingController.h"

@interface FPFlightReportViewController (){
    
   CGFloat  tableWidth;
}

@property(nonatomic,retain)NSMutableDictionary* tableViewHeightCache;   //行高缓存；
@end

@implementation FPFlightReportViewController
@synthesize reportData;
@synthesize tableViewHeightCache;


-(void)dealloc{
    [reportData release];
    [tableViewHeightCache release];
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

    self.title=@"机场报表";
    
    
    
    UIImageView* imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        } else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    }else{
        imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    self.tableView.backgroundView = imageView;
    [imageView release];

    
    
    
    
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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.reportData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AnnounceCell = @"AnnounceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AnnounceCell];
    
    if (cell == nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AnnounceCell] autorelease];
        cell.textLabel.numberOfLines=0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
   
    
   
    cell.textLabel.text=[self.reportData objectAtIndex:indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    CGSize size = [[self.reportData objectAtIndex:indexPath.row ] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableWidth,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    if (size.height>44) {
        
        return size.height;
    }
    
   return 44;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (device_Type == UIUserInterfaceIdiomPad) {
        
        if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
            tableWidth=980;
        }else{
            tableWidth=730;
        }
        
        return YES;
    }else{
        if (interfaceOrientation==UIInterfaceOrientationPortrait) {
            tableWidth=280;
            return YES;
        }
        return NO;
    }
}

-(BOOL)shouldAutorotate{
    
    if (device_Type == UIUserInterfaceIdiomPhone){
        return NO;
    }else{
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations{
    
    if (device_Type == UIUserInterfaceIdiomPad) {
        tableWidth=980;
        
        return   UIInterfaceOrientationMaskAll;
        
        
    }else{
        
        tableWidth=280;
        
        return UIInterfaceOrientationMaskPortrait  ;
        
        
    }
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
