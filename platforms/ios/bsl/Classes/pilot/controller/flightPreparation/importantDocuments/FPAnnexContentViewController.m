//
//  FPAnnexContentViewController.m
//  pilot
//
//  Created by lei chunfeng on 12-11-6.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPAnnexContentViewController.h"
#import "GEAlertViewDelegate.h"
#import "FPCoordinatingController.h"

@interface FPAnnexContentViewController ()

@end

@implementation FPAnnexContentViewController
@synthesize annexContentWebView = _annexContentWebView;
@synthesize annexURL = _annexURL;
@synthesize mbProgressHUD = _mbProgressHUD;
@synthesize body = _body;
@synthesize annexString = _annexString;

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
    
    _annexContentWebView.scalesPageToFit = YES;
    if ([_annexString hasSuffix:@"txt"] || [_annexString hasSuffix:@"xls"] || [_annexString hasSuffix:@"xlsx"]) {
        _annexContentWebView.scalesPageToFit = NO;
    }
    
    // 如果是txt文件，则直接加载内容
    if (_body) {
        [_annexContentWebView loadHTMLString:_body baseURL:nil];
    } else {
        [_annexContentWebView loadRequest:[NSURLRequest requestWithURL:_annexURL]];
    }
            
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    leftButtonItem.tag = kbuttonTagBack;
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
}

-(void)requestChangeView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setAnnexContentWebView:nil];
    [self setAnnexURL:nil];
    [self setMbProgressHUD:nil];
    [self setBody:nil];
    [self setAnnexString:nil];
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

- (void)dealloc {
    [_annexContentWebView release];
    [_annexURL release];
    [_body release];
    [_annexString release];
    [super dealloc];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (!_mbProgressHUD) {
        _mbProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    _mbProgressHUD.dimBackground = YES;
    [self.view addSubview:_mbProgressHUD];
    
    _mbProgressHUD.labelText = @"正在打开...";
    _mbProgressHUD.minSize = CGSizeMake(135.f, 90.0f);
    [_mbProgressHUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_mbProgressHUD hide:YES];
    [_mbProgressHUD removeFromSuperview];
    [_mbProgressHUD release];
	_mbProgressHUD = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_mbProgressHUD hide:YES];
    [_mbProgressHUD removeFromSuperview];
    [_mbProgressHUD release];
	_mbProgressHUD = nil;
    
    GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
    [geAlert showAlertViewWithTitle:@"提示" message:@"打开失败，请稍后重试！" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
}

@end
