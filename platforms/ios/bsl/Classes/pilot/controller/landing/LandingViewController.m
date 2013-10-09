//
//  LandingViewController.m
//  pilot
//
//  Created by wuzheng on 8/27/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "LandingViewController.h"


#import "FlightScheduleViewController.h"
#import "FeedBack.h"
#import "FlightTaskViewController.h"
#import "PDFDocumentsViewController.h"
#import "GEAlertViewDelegate.h"
#import "MBProgressController.h"
#import "NetworkStatusUtil.h"
#import "User.h"
#import "FPCoordinatingController.h"
#import "User.h"
#import "FPTaskListViewController.h"
#import "FlightPlanViewController.h"
#import "FilghtCaleMenuViewController.h"
#import "EbookListViewController.h"
#import "TowFilesViewController.h"

@implementation LandingViewController
@synthesize bgImageView;
@synthesize groupView;
@synthesize landscapeView;
@synthesize portraitView;
@synthesize taskQuery = _taskQuery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主页";
    
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        for (NSInteger i = 1; i <= [[self.groupView subviews] count]; ++i) {
            UIButton *button1 = (UIButton*)[self.groupView viewWithTag:i];
            UIButton *button2  = (UIButton*)[self.landscapeView viewWithTag:i];
            button1.frame = button2.frame;
            [button1 setImage:[button2 imageForState:UIControlStateNormal] forState:UIControlStateNormal];
        }
        
    }else{
        for (NSInteger i = 1; i <= [[self.groupView subviews] count]; ++i) {
            UIButton *button1 = (UIButton*)[self.groupView viewWithTag:i];
            UIButton *button2 = (UIButton*)[self.portraitView viewWithTag:i];
            button1.frame = button2.frame;
            [button1 setImage:[button2 imageForState:UIControlStateNormal] forState:UIControlStateNormal];
        }
        
    }
}

- (void)viewDidUnload
{
    [self setBgImageView:nil];
    [self setGroupView:nil];
    [self setLandscapeView:nil];
    [self setPortraitView:nil];
    [self setTaskQuery:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (device_Type == UIUserInterfaceIdiomPad) {
        [self reSetContentViewForIPadWithInterfaceOrientation:self.interfaceOrientation];
    }
    
}

- (void)dealloc {
    [bgImageView release];
    [groupView release];
    [landscapeView release];
    [portraitView release];
    [_taskQuery release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        [self reSetContentViewForIPadWithInterfaceOrientation:interfaceOrientation];
        return YES;
    }else{
        if (interfaceOrientation==UIInterfaceOrientationPortrait) {
            return YES;
        }
        return NO;
    }
}

- (BOOL)shouldAutorotate {
    if (device_Type == UIUserInterfaceIdiomPhone) {
        return NO;
    } else {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    if (device_Type == UIUserInterfaceIdiomPad) {
        [self reSetContentViewForIPadWithInterfaceOrientation:self.interfaceOrientation];
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (device_Type == UIUserInterfaceIdiomPad) {
        [self reSetContentViewForIPadWithInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        
    }
}

#pragma mark -
#pragma mark button click -
//帮助中心
- (IBAction)didClickHelpCenter:(id)sender{
            
}

//运行信息
- (IBAction)didClickFlightSchedule:(id)sender{
    FlightScheduleViewController *flightScheduleViewController = [[FlightScheduleViewController alloc] initWithNib];
    flightScheduleViewController.delegate = self;
    flightScheduleViewController.backMethod = @selector(backToHome);
    [self.navigationController pushViewController:flightScheduleViewController animated:YES];
    [flightScheduleViewController release];
}

//意见反馈
- (IBAction)didClickFeeding:(id)sender{
   
}

//舱单－预计配载
- (IBAction)didClickManifest:(id)sender{
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController setSafeConnet];
    [MBProgressController startQueryProcess];
    
    self.taskQuery = [[[FlightTaskQuery alloc] init] autorelease];
    
    //查询当天飞行任务
    [_taskQuery queryFlightTaskFromSDESWithWorkNo:[User currentUser].workNo taskDays:0 completionBlock:^(NSArray *responseArray) {
        [MBProgressController dismiss];
        if (responseArray == nil || [responseArray count] == 0) {
            
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            [geAlert showAlertViewWithTitle:@"提示" message:@"暂无预计配载相关数据" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
        }else{            
            FlightTaskViewController *flightTaskViewController = [[FlightTaskViewController alloc] initWithNib];
            flightTaskViewController.flightTaskArray = responseArray;
            flightTaskViewController.navigationController.title = @"预计配载";
            [self.navigationController pushViewController:flightTaskViewController animated:YES];
            [flightTaskViewController release];
        }
        NSLog(@"---success---");
    } failedBlock:^(NSData *responseData) {
        [MBProgressController dismiss];
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        [geAlert showAlertViewWithTitle:@"提示" message:@"查询预计配载信息失败" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    }];
}

//电子书
- (IBAction)didClickEbook:(id)sender{
    
    EbookListViewController* aEbookListViewController=[[EbookListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:aEbookListViewController animated:YES];
    [aEbookListViewController release];

}

- (IBAction)didClickSettingCenter:(id)sender {
  
}

//飞行准备
-(IBAction)didClickFligthPreparation:(id)sender{
    if ([[User currentUser].pilotFlag isEqualToString:@"Y"]) {    
        FPTaskListViewController* aFPTaskListViewController =[[[FPTaskListViewController alloc]init]autorelease];
        aFPTaskListViewController.title=@"飞行任务";
       [FPCoordinatingController shareInstance].taskViewController = aFPTaskListViewController;

        [self.navigationController pushViewController:[FPCoordinatingController shareInstance].taskViewController animated:YES];
    }
        else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有飞行准备的权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
        [alert show];
        [alert release];
    }
}

//飞行计划
- (IBAction)didClickFlightTask:(id)sender{
    FlightTaskQuery *taskQuery = [[FlightTaskQuery alloc] init];
        //查询当天飞行任务
    [taskQuery queryFlightTaskFromSDESWithWorkNo:[User currentUser].workNo taskDays:0 completionBlock:^(NSArray *responseArray) {
        [MBProgressController dismiss];
        if (responseArray == nil || [responseArray count] == 0) {
            
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            [geAlert showAlertViewWithTitle:@"提示" message:@"暂无飞行计划相关数据" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
        }else{
            FlightPlanViewController *flightPlanViewController = [[FlightPlanViewController alloc] init];
            flightPlanViewController.flightTaskArray = responseArray;
            [self.navigationController pushViewController:flightPlanViewController animated:YES];
            [flightPlanViewController release];
        }
        NSLog(@"---success---");
    } failedBlock:^(NSData *responseData) {
        [MBProgressController dismiss];
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        [geAlert showAlertViewWithTitle:@"提示" message:@"查询飞行计划相关数据失败" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    }];
    [taskQuery release];
    
}

//退出并清空cookies
- (void)didExit:(id)sender{
    [self cleanCookies];
    [self.navigationController popViewControllerAnimated:YES];
}

//清理cookies
-(void)cleanCookies{
    NSLog(@"开始执行cookie清理操作");
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in [cookieStorage cookies]) {
        [cookieStorage deleteCookie:each];
    }
}

// 隐藏tabBarController的tabBar
- (void)hideTabBar:(UITabBarController *)tabBarController setHidden:(BOOL)hidden {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:0];
    for (UIView *view in tabBarController.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, 1024, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 975, view.frame.size.width, view.frame.size.height)];
            }
        } else {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 1024)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 975)];
            }
        }
    }
    [UIView commitAnimations];
}

- (void)reSetContentViewForIPadWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        self.bgImageView.image = [UIImage imageNamed:@"Background_1024X768.png"];
        for (NSInteger i = 1; i <= [[self.groupView subviews] count]; ++i) {
            UIButton *button1 = (UIButton*)[self.groupView viewWithTag:i];
            UIButton *button2  = (UIButton*)[self.landscapeView viewWithTag:i];
            button1.frame = button2.frame;
            [button1 setImage:[button2 imageForState:UIControlStateNormal] forState:UIControlStateNormal];
        }
        
    }else{
        self.bgImageView.image = [UIImage imageNamed:@"Background_768X1024.png"];
        for (NSInteger i = 1; i <= [[self.groupView subviews] count]; ++i) {
            UIButton *button1 = (UIButton*)[self.groupView viewWithTag:i];
            UIButton *button2 = (UIButton*)[self.portraitView viewWithTag:i];
            button1.frame = button2.frame;
            [button1 setImage:[button2 imageForState:UIControlStateNormal] forState:UIControlStateNormal];
        }        
    }
}

//飞行计算器
-(IBAction)didClickFlightCalc:(id)sender{
    FilghtCaleMenuViewController *aMenuViewController=[[FilghtCaleMenuViewController alloc] init];
    [self.navigationController pushViewController:aMenuViewController animated:YES];
    [aMenuViewController release];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//起飞限重表
- (IBAction)didClickTowFiles:(id)sender {
    TowFilesViewController *towFilesViewController = [[TowFilesViewController alloc] init];
    [self.navigationController pushViewController:towFilesViewController animated:YES];
    [towFilesViewController release];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end