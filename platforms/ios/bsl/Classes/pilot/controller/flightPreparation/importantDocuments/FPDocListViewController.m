//
//  DocListViewController.m
//  pilot
//
//  Created by lei chunfeng on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPDocListViewController.h"
#import "ArticleInfoQuery.h"
#import "User.h"
#import "GEAlertViewDelegate.h"
#import "ArticleInfo.h"
#import "NSDictionary+ObjectExtensions.h"
#import "FPDocContentViewController.h"
#import "EBArticleLogInfo.h"
#import "FPHealthDeclarationViewController.h"
#import "MBProgressController.h"
#import "FPCoordinatingController.h"
#import "FileQuery.h"

@interface FPDocListViewController ()

@end

@implementation FPDocListViewController

@synthesize docListTableView = _docListTableView;
@synthesize dataSourceArray = _dataSourceArray;
@synthesize readDocumentArray = _readDocumentArray;
@synthesize ebArticleLogInfoArray = _ebArticleLogInfoArray;
@synthesize buttonForNextStep = _buttonForNextStep;

- (void)dealloc {
    [_docListTableView release];
    [_dataSourceArray release];
    [_readDocumentArray release];
    [_ebArticleLogInfoArray release];
    [_buttonForNextStep release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"重要文件";
    
    // 初始化日志数组
    self.ebArticleLogInfoArray = [[[NSMutableArray alloc] init] autorelease];
    
    // 初始化已读的重要文件数组
    self.readDocumentArray = [[[NSMutableArray alloc] init] autorelease];
        
    UIImage *buttonForBackImage = [UIImage imageNamed:@"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@"  航行通告" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.tag = kbuttonTagBack;
    [backButton addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
    
    UIImage *nextImage = [UIImage imageNamed:@"RightButtonItem"];
    self.buttonForNextStep = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30) ]autorelease];
    [_buttonForNextStep setBackgroundImage:nextImage forState:UIControlStateNormal];
    [_buttonForNextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [_buttonForNextStep.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [_buttonForNextStep.titleLabel setShadowColor:[UIColor grayColor]];
    [_buttonForNextStep.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [_buttonForNextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonForNextStep addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextStepItem = [[UIBarButtonItem alloc] initWithCustomView:_buttonForNextStep];
    self.navigationItem.rightBarButtonItem = nextStepItem;
    [nextStepItem release];
    
    // 设置背景图片
    UIImageView *imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        } else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    }
    
    _docListTableView.backgroundView = imageView;
    [imageView release];
    
    // 查询重要文件
    [self queryArticleInfo];

}

- (void)viewDidUnload
{
    [self setDocListTableView:nil];
    [self setDataSourceArray:nil];
    [self setReadDocumentArray:nil];
    [self setEbArticleLogInfoArray:nil];
    [self setButtonForNextStep:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // 查看完一个重要文件返回时进行刷新
    [_docListTableView reloadData];
}

#pragma mark - Methods

// 查询当前用户有没有要查看的重要文件
- (void)queryArticleInfo {
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess];
    
    ArticleInfoQuery *articleInfoQuery = [[[ArticleInfoQuery alloc] init] autorelease];
    
    NSString *baseCode = [User currentUser].baseCode;
    
    NSDate *date = [NSDate date];
    NSTimeInterval totalTimeDouble = [date timeIntervalSinceDate:TaskDelegate.lastTime];
    NSString *totalTime = [NSString stringWithFormat:@"%.2f", totalTimeDouble];
    TaskDelegate.lastTime = date;
    
    [articleInfoQuery queryArticleInfoWithWorkNo:TaskDelegate.empId baseCode:baseCode fltNo:TaskDelegate.flightNo fltDate:TaskDelegate.flightTime depPort:TaskDelegate.depAirport totalTime:totalTime completionBlock:^(NSArray * responseArray) {
        
        [MBProgressController dismiss];
        
        if (responseArray == nil || [responseArray count] == 0) {
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            [geAlert showAlertViewWithTitle:@"提示" message:@"您没有需要查看的重要文件！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
        } else {
            self.dataSourceArray = (NSMutableArray *)responseArray;
            [self judgeIfHaveArticleReadBefore];
            [_docListTableView reloadData];
        }
        
    } failedBlock:^(NSData *responseData) {
        
        // 查询失败，不能进入下一步
        [_buttonForNextStep setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [MBProgressController dismiss];
        
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        [geAlert showAlertViewWithTitle:@"查询失败" message:@"请返回航行通告后重新进入！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    }];
    
}

// 将查询出来的重要文件与SQLite中的日志进行比较，看是否存在以前查看过但未提交日志的重要文件
- (void)judgeIfHaveArticleReadBefore {
    
    NSMutableArray *tempArray = [_dataSourceArray copy];
    for (id object in tempArray) {
        NSString *staffNo = TaskDelegate.empId;
        NSString *filename = [NSString stringWithFormat:@"%@", [object seqID]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"staffNo == %@ AND filename == %@", staffNo, filename];
        EBArticleLogInfo *resultObject = [EBArticleLogInfo getByPredicate:predicate];
        if (resultObject) {
            // 将SQLite中未提交的日志添加到待提交的日志数组中
            [_ebArticleLogInfoArray addObject:resultObject];
            
            // 此重要文件以前查看过，添加到已读的重要文件列表中，从未读的重要文件数组中移除
            [_readDocumentArray addObject:object];
            [_dataSourceArray removeObject:object];
        }
    }
    [tempArray release];
    
}

#pragma mark - Actions

-(void)requestChangeView:(id)sender{
    [[FPCoordinatingController shareInstance] requestViewChangeBy:sender];
}

// 控制界面跳转
- (void)nextStep:(id)sender {
    
    GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
    
    // 查看完所有的重要文件后才能进入下一步
    if ([_dataSourceArray count] != 0) {
        [geAlert showAlertViewWithTitle:@"提示" message:@"您还有重要文件没有查看，请查看完所有重要文件后再点击下一步！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    } else {
        FPHealthDeclarationViewController *fpHealthDeclarationViewController = [[[FPHealthDeclarationViewController alloc] initWithNibName:@"FPHealthDeclarationViewController" bundle:nil] autorelease];
        
        // 调试
        [_ebArticleLogInfoArray removeAllObjects];
        
        if ([_ebArticleLogInfoArray count] == 0) {
            EBArticleLogInfo *ebArticleLogInfo = [EBArticleLogInfo insert];
            [_ebArticleLogInfoArray addObject:ebArticleLogInfo];
        }
        
        fpHealthDeclarationViewController.ebArticleLogInfoArray = _ebArticleLogInfoArray;
        [self.navigationController pushViewController:fpHealthDeclarationViewController animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if ([_dataSourceArray count] != 0) {
            return [NSString stringWithFormat:@"未读：共%d个", [_dataSourceArray count]];
        } else {
            if ([_readDocumentArray count] != 0) {
                return @"";
            } else {
                return [NSString stringWithFormat:@"未读：共%d个", [_dataSourceArray count]];
            }
        }
    } else {
        if ([_readDocumentArray count] != 0) {
            return [NSString stringWithFormat:@"已读：共%d个", [_readDocumentArray count]];
        } else {
            return @"";
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_dataSourceArray count];
    } else {
        return [_readDocumentArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *identifier = @"DocListCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
	}
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap; // 设置换行模式
    
    // 配置cell
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *documentArray;
    if (indexPath.section == 0) {
        documentArray = _dataSourceArray;
    } else {
        documentArray = _readDocumentArray;
    }
    
    cell.textLabel.text = [[documentArray objectAtIndex:[indexPath row]] title];
    
    cell.detailTextLabel.text = [[documentArray objectAtIndex:[indexPath row]] issuerDate];
    
//    NSLog(@"%f", cell.textLabel.frame.size.width);
//    NSLog(@"%f", cell.frame.size.height);
	return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIFont *font = [UIFont boldSystemFontOfSize:18.0];
    
    NSArray *documentArray;
    if (indexPath.section == 0) {
        documentArray = _dataSourceArray;
    } else {
        documentArray = _readDocumentArray;
    }
    
    CGSize size = CGSizeZero;
    if (device_Type == UIUserInterfaceIdiomPhone) {
        size = [[[documentArray objectAtIndex:[indexPath row]] title] sizeWithFont:font constrainedToSize:CGSizeMake(271, 1000) lineBreakMode:UILineBreakModeWordWrap];
    } else {
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            size = [[[documentArray objectAtIndex:[indexPath row]] title] sizeWithFont:font constrainedToSize:CGSizeMake(631, 1000) lineBreakMode:UILineBreakModeWordWrap];
        } else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            size = [[[documentArray objectAtIndex:[indexPath row]] title] sizeWithFont:font constrainedToSize:CGSizeMake(865, 1000) lineBreakMode:UILineBreakModeWordWrap];
        }
    }
    
    return size.height + 22.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *documentArray;
    if (indexPath.section == 0) {
        documentArray = _dataSourceArray;
    } else {
        documentArray = _readDocumentArray;
    }
    
    ArticleInfo *articleInfo = [documentArray objectAtIndex:[indexPath row]];
    
    FileQuery *fileQuery = [[FileQuery alloc] init];
    
    [[MBProgressController getCurrentController] setMessage:@"正在加载..."];
    [MBProgressController startQueryProcess];
    
    NSString *fileName = [[articleInfo seqID] stringByAppendingPathExtension:@"txt"];
    
    [fileQuery downloadFileWithRemotePath:FILE_REMOTEPATH AndFileName:fileName AndFileType:NOTICE_CONTENT inTimeFlag:@"N" completion:^(NSString *filePath) {
        [MBProgressController dismiss];
        
        if (indexPath.section == 0) {
            // 每查看一个重要文件对应生成一条日志，在SQLite中也保存一份日志，用于与查询出来的重要文件进行比较
            EBArticleLogInfo *ebArticleLogInfo = [EBArticleLogInfo insert];
            ebArticleLogInfo.staffNo = TaskDelegate.empId;
            ebArticleLogInfo.filename = [NSString stringWithFormat:@"%@", [articleInfo seqID]];
            ebArticleLogInfo.operType = @"R";
            NSDateFormatter *dateFormator = [[[NSDateFormatter alloc] init] autorelease];
            dateFormator.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *date = [dateFormator stringFromDate:[NSDate date]];
            ebArticleLogInfo.operDate = date;
            [EBArticleLogInfo save];
            
            // 将日志添加到日志数组
            [_ebArticleLogInfoArray addObject:ebArticleLogInfo];
            
            // 添加到已读的重要文件数组中，从未读的重要文件数组中移除
            [_readDocumentArray addObject:articleInfo];
            [_dataSourceArray removeObject:articleInfo];
        }
        
        if (filePath == nil) {
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            [geAlert showAlertViewWithTitle:@"提示" message:@"文件不存在！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:^() {
                [_docListTableView reloadData];
            } cancelBlock:nil];
        } else {
            NSError *error = nil;
            
            NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            if (content == nil) {
                NSStringEncoding gbEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                content = [NSString stringWithContentsOfFile:filePath encoding:gbEncoding error:&error];
            }
            
            FPDocContentViewController *fpDocContentViewController = [[[FPDocContentViewController alloc] initWithNibName:@"FPDocContentViewController" bundle:nil] autorelease];
            fpDocContentViewController.contentTxt = content;
            id data = [articleInfo annexNameList];
            if (data != nil && ![data isKindOfClass:[NSArray class]]) {
                fpDocContentViewController.dataSourceArray = [NSArray arrayWithObject:data];
            } else {
                fpDocContentViewController.dataSourceArray = [articleInfo annexNameList];
            }
            fpDocContentViewController.annexURLArray = [articleInfo annexURLList];
            fpDocContentViewController.title = articleInfo.title;
            
            [self.navigationController pushViewController:fpDocContentViewController animated:YES];
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

@end
