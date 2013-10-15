//
//  Login_IphoneViewController.m
//  cube-ios
//
//  Created by 东 on 8/2/13.
//
//

#import "Login_IphoneViewController.h"

#import "CubeWebViewController.h"
#import "NSFileManager+Extra.h"



@interface Login_IphoneViewController ()

@end

@implementation Login_IphoneViewController
-(id)init{
    self=[super init];
    if(self){
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
    }
    
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];

    UIImage* img=nil;
    if(iPhone5)
        img=[UIImage imageNamed:@"Default-568h.png"];
    else
        img = [UIImage imageNamed:@"Default.png"];
    UIImageView* bgImageView =  [[UIImageView alloc]initWithImage:img];
    CGRect rect=bgImageView.bounds;
    rect.origin.y-=20.0f;
    bgImageView.frame=rect;

    [self.view addSubview:bgImageView];


    aCubeWebViewController  = [[CubeWebViewController alloc] init];
    //aCubeWebViewController.title=module.name;
    //加载本地的登录界面页
    //设置启动页面
    aCubeWebViewController.title=@"登录";
    aCubeWebViewController.wwwFolderName = @"www";
    aCubeWebViewController.startPage =   [[[NSFileManager wwwRuntimeDirectory] URLByAppendingPathComponent:@"phone/login.html"] absoluteString];
    
    aCubeWebViewController.view.frame = self.view.bounds;
    aCubeWebViewController.view.hidden=YES;
    NSLog(@"start load WebView date = %@",[NSDate date]);
    [aCubeWebViewController loadWebPageWithUrl: [[[NSFileManager wwwRuntimeDirectory] URLByAppendingPathComponent:@"phone/login.html"] absoluteString] didFinishBlock: ^(){
        aCubeWebViewController.view.hidden=NO;
        aCubeWebViewController.closeButton.hidden = YES;
        [aCubeWebViewController viewWillAppear:NO];
        [self.view addSubview:aCubeWebViewController.view];
        [aCubeWebViewController viewDidAppear:NO];
        aCubeWebViewController.webView.scrollView.bounces=NO;
        NSLog(@"finish load WebView date = %@",[NSDate date]);
    }didErrorBlock:^(){
        aCubeWebViewController.closeButton.hidden = YES;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆模块加载失败。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


@end
