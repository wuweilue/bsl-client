//
//  FlightScheduleViewController.m
//  pilot
//
//  Created by wuzheng on 8/28/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "FlightScheduleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "NetworkConfig.h"
#import "NetworkStatusUtil.h"
#import "RNCachingURLProtocol.h"
#import "DES.h"

@implementation FlightScheduleViewController
@synthesize activityIndicatorView;
@synthesize myWebView;
@synthesize delegate;
@synthesize backMethod;

-(id)init{
    self=[super init];
    if (self) {
        
        NSString *className = NSStringFromClass([self class]);
        NSString *nibName;
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            nibName= [NSString stringWithFormat:@"%@_Pad",className];
        }else{
            nibName= [NSString stringWithFormat:@"%@_Phone",className];
        }
        
        return [self initWithNibName:nibName bundle:nil];
        
        
    }
    return self;
}

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
    self.title = @"运行信息";
    
    
    
    //飞行移动添加 add by Sencho Kong
    [self initWebViewCookies];
    //end add
    
    
    self.msgView.layer.cornerRadius = 8;//设置那个圆角的有多圆
    self.msgView.layer.borderWidth = 1;//设置边框的宽度
    self.msgView.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    self.msgView.layer.masksToBounds = YES;
    self.msgView.hidden = YES;
    
    offline = NO;
    
    UIImage *image = [UIImage imageNamed:@"BarButtonItem_Refresh"];
    UIButton *refreshButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 30)] autorelease];
    [refreshButton setBackgroundImage:image forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshURL:) forControlEvents:UIControlEventTouchUpInside];
    
    refreshButton_ = [[[UIBarButtonItem alloc] initWithCustomView:refreshButton] autorelease];
    self.navigationItem.rightBarButtonItem = refreshButton_;
    
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 主页" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonForBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = buttonForBack;
    [buttonForBack release];
    
    myWebView.scalesPageToFit =YES;
    myWebView.delegate =self;
}


//add by Sencho Kong

//根据当前用户初始化cookies,飞行移动运行信息模块webView要通过cookie里的用户名和密码检证，成功能再返回web页面
-(void)initWebViewCookies {
    //加密用户名密码
    
     NSString* user=[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUsername"];
     NSString* pass=[[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSString *encryptedWorkNo = [[[NSString alloc] initWithData:[DES doEncryptWithString:user key:ENCRYPT_KEY] encoding:NSUTF8StringEncoding]autorelease];
    encryptedWorkNo = [self encodeToPrecentEscapeString:encryptedWorkNo];
    NSString *encryptedPassword = [[[NSString alloc] initWithData:[DES doEncryptWithString:pass key:ENCRYPT_KEY] encoding:NSUTF8StringEncoding]autorelease];
    encryptedPassword = [self encodeToPrecentEscapeString:encryptedPassword];
    //生成当前访问的domian，先过滤掉协议头http://
    NSString *url  = [BASEURL substringToIndex:([BASEURL length] - 6)];
    NSString * domain = [url substringFromIndex:7];
    if ([domain rangeOfString:@":"].location == NSNotFound) {
        //domain是icrew.csair.com
    } else {
        //domain是IP,过滤掉端口号
        domain = [domain substringToIndex:[domain rangeOfString:@":"].location];
    }
    //生成HTTPCookie对象
    NSHTTPCookie *cookieUser = [[NSHTTPCookie alloc] initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"user",NSHTTPCookieName,encryptedWorkNo,NSHTTPCookieValue,domain,NSHTTPCookieDomain,@"/",NSHTTPCookiePath, nil]];
    NSHTTPCookie *cookiePass = [[NSHTTPCookie alloc] initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"pass",NSHTTPCookieName,encryptedPassword,NSHTTPCookieValue,domain,NSHTTPCookieDomain,@"/",NSHTTPCookiePath, nil]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //清理并保存
    //    [cookieStorage deleteCookie:cookieUser];
    //    [cookieStorage deleteCookie:cookiePass];
    [cookieStorage setCookie:cookieUser];
    [cookieStorage setCookie:cookiePass];
    NSLog(@"添加了cookies:%@%@",cookieUser,cookiePass);
    [cookieUser release];
    [cookiePass release];
}

//处理加密串中可能出现的特殊字符
-(NSString *)encodeToPrecentEscapeString:(NSString *)input{
    NSString *output = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)input, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return [output autorelease];
}

//end add




- (void)viewDidUnload
{
    [self setMyWebView:nil];
    [self setActivityIndicatorView:nil];
    [self setMsgView:nil];
    [self setTimeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self loadWebPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    }else{
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    }
}

- (void)dealloc {
    [myWebView release];
    [activityIndicatorView release];
    [_msgView release];
    [_timeLabel release];
    [super dealloc];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshURL:(id)sender{
    if ([[NetworkStatusUtil sharedNetworkStatusUtil] checkNetworkStatusReachable]) {
        [refreshButton_ setEnabled:NO];
        [myWebView reload];
    }else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查网络！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }
}

- (void)loadWebPage{
    
    NSString* workNo=[[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?empId=%@&appType=%@",FLIGHT_SCHEDULE,workNo,appType];
    NSURL *url =[NSURL URLWithString:urlStr];
    
    if ([[NetworkStatusUtil sharedNetworkStatusUtil] checkNetworkStatusReachable]) {
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [myWebView loadRequest:request];
    }else {
        if ([RNCachingURLProtocol checkCacheExistWithURL:url]) {
            //缓存存在，则显示提示动画
            self.msgView.hidden = NO;
            self.timeLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"FlightScheduleTime"];
            offline = YES;            
            
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [myWebView loadRequest:request];
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用且暂无缓存，请检查网络！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [alert show];
        }
    }

}

- (void)backToHome:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark ==== UIWebView delegate ====
#pragma mark -
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView setHidden:NO];
    [activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [refreshButton_ setEnabled:YES];
    [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidden:YES];
    
    //非离线才刷新缓存时间
    if (!offline) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *time = [formatter stringFromDate:[NSDate date]];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",time];
        [formatter release];
        
        //记录查询时间，以便离线时缓存时间显示
        [[NSUserDefaults standardUserDefaults] setValue:time forKey:@"FlightScheduleTime"];
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    if (error.code == NSURLErrorCancelled){
        return;
    }else{
        [refreshButton_ setEnabled:YES];
        [activityIndicatorView stopAnimating];
        [activityIndicatorView setHidden:YES];

        NSDictionary *userInfo = [error userInfo];
        NSString *message = [userInfo objectForKey:@"cacheError"];
        if (message == nil) {
            message = @"连接服务器失败";
        }
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"提示" message:message  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alterview show];
        [alterview release];
    }
}
@end
