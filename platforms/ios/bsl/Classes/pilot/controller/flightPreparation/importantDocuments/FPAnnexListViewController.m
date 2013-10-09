//
//  FPAnnexListViewController.m
//  pilot
//
//  Created by leichunfeng on 13-6-13.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "FPAnnexListViewController.h"
#import "FPAnnexContentViewController.h"
#import "FileQuery.h"
#import "GEAlertViewDelegate.h"
#import "User.h"

@interface FPAnnexListViewController ()

@end

@implementation FPAnnexListViewController

@synthesize dataSourceArray;
@synthesize annexURLArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"附件列表";
    
    UIImage *buttonForBackImage = [UIImage imageNamed:@"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
}

- (void)viewDidUnload {
    [self setDataSourceArray:nil];
    [self setAnnexURLArray:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [dataSourceArray release];
    [annexURLArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [NSString stringWithFormat:@"附件：共%d个", [dataSourceArray count]];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"AnnexListCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
	}
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap; // 设置换行模式
    
    cell.textLabel.text = [dataSourceArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont boldSystemFontOfSize:17.0];
    
    CGSize size = CGSizeZero;
    if (device_Type == UIUserInterfaceIdiomPhone) {
        size = [[dataSourceArray objectAtIndex:[indexPath row]] sizeWithFont:font constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
    } else {
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            size = [[dataSourceArray objectAtIndex:[indexPath row]] sizeWithFont:font constrainedToSize:CGSizeMake(728, 1000) lineBreakMode:UILineBreakModeWordWrap];
        } else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            size = [[dataSourceArray objectAtIndex:[indexPath row]] sizeWithFont:font constrainedToSize:CGSizeMake(984, 1000) lineBreakMode:UILineBreakModeWordWrap];
        }
    }
    
    return size.height + 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FPAnnexContentViewController *fpAnnexContentViewController = [[[FPAnnexContentViewController alloc] initWithNibName:@"FPAnnexContentViewController" bundle:nil] autorelease];
    
    NSString *annexString = [dataSourceArray objectAtIndex:[indexPath row]];
    FileQuery *fileQuery = [[FileQuery alloc] init];
    
    NSString *fileType = [NSString stringWithFormat:@"NOTICE_ANNEX_%@", [User currentUser].baseCode];
    
    NSString *remotePath = [NSString stringWithFormat:@"/upload/%@/news",[[User currentUser].baseCode lowercaseString]];
    [[MBProgressController getCurrentController] setMessage:@"正在加载..."];
    [MBProgressController startQueryProcess];
    [fileQuery downloadFileWithRemotePath:remotePath AndFileName:annexString AndFileType:fileType inTimeFlag:@"N" completion:^(NSString *filePath) {
        [MBProgressController dismiss];
        
        if (filePath == nil) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"文件不存在！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [alert show];
        } else {
            NSStringEncoding *usedEncoding = nil;
            // 带编码头的如UTF-8等，这里会识别出来
            NSString *body = [NSString stringWithContentsOfFile:filePath usedEncoding:usedEncoding error:nil];
            // 识别不到，就按GBK编码再解码一次，这里不能先按GB18030解码，否则将出现整个文档无换行的BUG
            if (!body) {
                usedEncoding = (NSStringEncoding *)0x80000632;
                body = [NSString stringWithContentsOfFile:filePath usedEncoding:usedEncoding error:nil];
            }
            // 还是识别不到，就按GB18030编码再解码一次
            if (!body) {
                usedEncoding = (NSStringEncoding *)0x80000631;
                body = [NSString stringWithContentsOfFile:filePath usedEncoding:usedEncoding error:nil];
            }
            
            NSURL *url = [NSURL fileURLWithPath:filePath];
            fpAnnexContentViewController.annexURL = url;
            fpAnnexContentViewController.body = body;
            fpAnnexContentViewController.annexString = annexString;
            fpAnnexContentViewController.title = annexString;
            [self.navigationController pushViewController:fpAnnexContentViewController animated:YES];
        }
    } failed:^(NSString *filePath) {
        
        [MBProgressController dismiss];
        
        if ([filePath isEqualToString:@"CANCEL"]) {
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            [geAlert showAlertViewWithTitle:@"提示" message:@"您已取消加载！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
        } else {
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            [geAlert showAlertViewWithTitle:@"提示" message:@"加载失败，请稍后重试！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
        }
        
    }];
    [fileQuery release];
}

#pragma mark - Actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end