//
//  FPDocContentViewController.m
//  pilot
//
//  Created by lei chunfeng on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPDocContentViewController.h"
#import "ArticleInfo.h"
#import "User.h"
#import "MBProgressController.h"
#import "FPAnnexListViewController.h"

@interface FPDocContentViewController ()

@end

@implementation FPDocContentViewController

@synthesize docContentWebView = _docContentWebView;
@synthesize contentTxt = _contentTxt;
@synthesize dataSourceArray = _dataSourceArray;
@synthesize annexURLArray = _annexURLArray;

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
    
    if ([_dataSourceArray count] > 0) {
        UIImage *image = [UIImage imageNamed:@"RightButtonItem"];
        UIButton *annexButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)] autorelease];
        [annexButton setBackgroundImage:image forState:UIControlStateNormal];
        [annexButton setTitle:@"查看附件" forState:UIControlStateNormal];
        [annexButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [annexButton.titleLabel setShadowColor:[UIColor grayColor]];
        [annexButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        [annexButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [annexButton addTarget:self action:@selector(showAnnexList) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *annexButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:annexButton] autorelease];
        self.navigationItem.rightBarButtonItem = annexButtonItem;
    }
    
    [_docContentWebView loadHTMLString:_contentTxt baseURL:nil];
    
}

- (void)viewDidUnload
{
    [self setDataSourceArray:nil];
    [self setAnnexURLArray:nil];
    [self setDocContentWebView:nil];
    [self setContentTxt:nil];
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

// 支持iOS6旋转
-(NSUInteger)supportedInterfaceOrientations
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotate {
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc {
    [_dataSourceArray release];
    [_annexURLArray release];
    [_docContentWebView release];
    [_contentTxt release];
    [super dealloc];
}

#pragma mark - Actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAnnexList {
    FPAnnexListViewController *annexListViewController = [[[FPAnnexListViewController alloc] initWithNibName:@"FPAnnexListViewController" bundle:nil] autorelease];
    annexListViewController.dataSourceArray = _dataSourceArray;
    annexListViewController.annexURLArray = _annexURLArray;
    [self.navigationController pushViewController:annexListViewController animated:YES];
}

@end