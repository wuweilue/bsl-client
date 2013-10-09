//
//  LoginViewController.m
//  pilot
//
//  Created by chen shaomou on 8/23/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewCell.h"
#import "LandingViewController.h"
#import "User.h"
#import "PilotAppDelegate.h"
#import "DeviceInfoQuery.h"
#import "VersionInfoQuery.h"
#import "NetworkStatusUtil.h"
#import "GEAlertViewDelegate.h"
#import "MBProgressController.h"
#import "PushNotificationQuery.h"
#import "UINavigationBar+Extention.h"
#import "PilotTabBarViewController.h"
#import "PilotSplitViewController.h"
#import "DES.h"

#define DeviceRegisterKey @"DeviceRegisterKey"
#define RememberGalleryLoginUserAndPasswordKey @"RememberGalleryLoginUserAndPasswordKey"

#define LoginContentViewOrigenRect  CGRectMake(0,0,320,460)

#define LoginContentViewMoveUpRect   CGRectMake(0,-112,320,460)

#define Checked         1
#define UnChecked       0

@interface PilotLoginViewController ()

@end

@implementation PilotLoginViewController
@synthesize loginBGImageView;
@synthesize activityIndicatorView;
@synthesize maskView;
@synthesize messageLabel;
@synthesize loginTable;
@synthesize rememberBtn;
@synthesize userQuery = _userQuery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    loginTable.backgroundColor = [UIColor clearColor];
    [loginTable setBackgroundView:nil];
    [loginTable setBackgroundView:[[[UIView alloc] init] autorelease]];
 
    
//    NSString *msg = @"正在检测版本更新...";
//    [[MBProgressController getCurrentController] setMessage:msg];
//    [MBProgressController startQueryProcess];
    
    //检测版本是否有更新
    VersionInfoQuery *versionQuery = [[VersionInfoQuery alloc] init];
    NSString *versionCode = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    [versionQuery checkVersionWithVersionCode:versionCode completionBlock:^(NSMutableDictionary *dic) {
        if (dic) {
//            [MBProgressController dismiss];
            NSString *status = [dic objectForKey:@"status"];
            NSString *description = [dic objectForKey:@"description"];
            if([check_newest isEqualToString:status]){
                messageLabel.text = @"当前版本是最新版本";
            }else  if([check_available isEqualToString:status] || [check_unAvailable isEqualToString:status]){
                [self showVersionUpdateAlertWithStatus:status description:description];
            }else if ([query_failed_flag isEqualToString:status]) {
                messageLabel.text = @"检测版本更新失败";
            }
        }
        DeviceInfoQuery *query = [[[DeviceInfoQuery alloc] init] autorelease];
        DeviceInfo *info = [[[DeviceInfo alloc] init] autorelease];        
        [query checkDeviceRegister:info completion:^(NSObject *responseObj) {
            if ([responseObj isKindOfClass:[DeviceInfo class]]) {
                DeviceInfo *deviceInfo = (DeviceInfo *)responseObj;
                if (deviceInfo && [@"Y" isEqualToString:[deviceInfo regitflag]]) {
                    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"PilotIsRegistered"];
                }else{

                }
            }
        } failed:^(NSObject *responseObj) {
            NSLog(@"----%@",responseObj);
        }];
        
    } failedBlock:^(NSMutableDictionary *dic) {
//        [MBProgressController dismiss];
//        messageLabel.text = @"检测版本更新失败";
    }];
    [versionQuery release];
}

- (void)viewDidUnload
{
    [self setLoginBGImageView:nil];
    [self setActivityIndicatorView:nil];
    [self setMaskView:nil];
    [self setMessageLabel:nil];
    [self setUserQuery:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar_BackG.png"] forBarMetrics:UIBarMetricsDefault];
        
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (device_Type == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            self.loginBGImageView.image=[UIImage imageNamed:@"Background_1024X768.png"];
        }else{
            self.loginBGImageView.image=[UIImage imageNamed:@"Background_768X1024.png"];
        }
    }
    
    [loginTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (device_Type == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
            self.loginBGImageView.image=[UIImage imageNamed:@"Background_1024X768.png"];
        }else{
            self.loginBGImageView.image=[UIImage imageNamed:@"Background_768X1024.png"];
        }
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)shouldAutorotate {
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    if (device_Type == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)dealloc {
    [loginBGImageView release];
    [activityIndicatorView release];
    [maskView release];
    [messageLabel release];
    [rememberBtn release];
    [_userQuery release];
    [super dealloc];
}

- (void)savePassword:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (button.tag == Checked) {
            [rememberBtn setImage:[UIImage imageNamed:@"Button_UnCheckMark_Pad.png"] forState:UIControlStateNormal];
            rememberBtn.tag = UnChecked;
        }else{
            [rememberBtn setImage:[UIImage imageNamed:@"Button_CheckedMark_Pad.png"] forState:UIControlStateNormal];
            rememberBtn.tag = Checked;
        }
    }else{
        if (button.tag == Checked) {
            [rememberBtn setImage:[UIImage imageNamed:@"Button_UnCheckMark.png"] forState:UIControlStateNormal];
            rememberBtn.tag = UnChecked;
        }else{
            [rememberBtn setImage:[UIImage imageNamed:@"Button_CheckedMark.png"] forState:UIControlStateNormal];
            rememberBtn.tag = Checked;
        }
    }
}

- (IBAction)didClickLoginButton:(id)sender {
    if ([passwordTextField_.text isEqualToString:@""] || [usernameTextField_.text isEqualToString:@""]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
        [alert show];
        return;
    }
    
    NSString *msg = @"正在登录...";
    [[MBProgressController getCurrentController] setMessage:msg];
    [MBProgressController setSafeConnet];
    [MBProgressController startQueryProcess];
    
    self.userQuery = [[[UserQuery alloc] init] autorelease];
        
    [_userQuery newLoginWithWorkNo:usernameTextField_.text password:passwordTextField_.text completionBlock:^(NSString* resultString) {
        [MBProgressController dismiss];
        
        if (rememberBtn.tag == Checked) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RememberGalleryLoginUserAndPasswordKey];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RememberGalleryLoginUserAndPasswordKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //登录成功后开始绑定推送通知
        PushNotificationQuery *pushNotificationQuery = [PushNotificationQuery sharedPushNotificationQuery];
        [pushNotificationQuery bindPushServiceWithCompletionBlock:^(NSString *responseStr) {
            if (responseStr && [responseStr isEqualToString:query_success_flag]) {
                pushNotificationQuery.allowPush = YES;
            }
        } failedBlock:^(NSString *responseStr) {
            pushNotificationQuery.allowPush = NO;
        }];
        
        //为运行信息webView初始cookies
        [self initWebViewCookies];
        
        LandingViewController *landingViewController = [[LandingViewController alloc] initWithNib];
        [self.navigationController pushViewController:landingViewController animated:YES];
        [landingViewController release];
        
    } failedBlock:^(NSString* resultString) {
        [MBProgressController dismiss];
        
        if([resultString isEqualToString:NETWORK_EXCEPTION]){
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络或服务器连接异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
            [alert show];
            return;
        }else if([resultString isEqualToString:LOGIN_FAILED]){
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
            [alert show];
            return;
        }else if([resultString isEqualToString:LOGIN_OA]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您是系统高级用户" message:@"请注意:\n1、2012年8月起，系统高级用户登\n\40\40\40\40\40\40录客舱移动调整为使用OA统一验\n\40\40\40\40\40\40证，原来登录密码失效\n2、获取系统新的授权:请点击“获取\n\40\40\40\40\40\40授权”按钮，然后重新用OA验证\n\40\40\40\40\40\40信息登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"获取授权", nil];
            alert.tag = login_oa_tag;
            alert.delegate = self;
            
            for(UIView *subview in alert.subviews)
            {
                if([[subview class] isSubclassOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel*)subview;
                    label.textAlignment = UITextAlignmentLeft;
                }
            }
            
            [alert show];
            [alert release];
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:resultString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
            [alert show];
            return;
        }
        
    }];
}

- (IBAction)speedTest:(id)sender {
       
}

- (IBAction)helpCenter:(id)sender {
   
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

#pragma mark -
#pragma mark UITableview dataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    LoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        if (device_Type == UIUserInterfaceIdiomPad) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LoginViewCell_Pad" owner:nil options:nil] objectAtIndex:0];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LoginViewCell_Phone" owner:nil options:nil] objectAtIndex:0];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    User *user;
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:RememberGalleryLoginUserAndPasswordKey];
    if(indexPath.row == 0){
        [cell configure:@"员工号" value:@"输入员工号" secure:NO];
        cell.rememberBtn.hidden = YES;
        usernameTextField_ = cell.valueTextField;
        usernameTextField_.delegate=self;
        usernameTextField_.keyboardType =UIKeyboardTypeEmailAddress;
        [usernameTextField_ setInputAccessoryView:nil] ;
        
        if (flag) {
            user = [User currentUser];
            if (user) {
                usernameTextField_.text = [user workNo];
            }
        }
        
    }
    if(indexPath.row == 1){
        [cell configure:@"密码" value:@"输入密码" secure:YES];
        passwordTextField_ = cell.valueTextField;
        passwordTextField_.delegate=self;
        cell.rememberBtn.hidden = YES;
        if (flag) {
            user = [User currentUser];
            if (user) {
                passwordTextField_.text = user.password;
            }
        }
        
    }if (indexPath.row == 2) {
        [cell configure:@"记住密码" value:@"" secure:NO];
        cell.valueTextField.hidden = YES;
        rememberBtn = cell.rememberBtn;
        BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:RememberGalleryLoginUserAndPasswordKey];
        if (device_Type == UIUserInterfaceIdiomPad) {
            if (flag) {
                [cell.rememberBtn setImage:[UIImage imageNamed:@"Button_CheckedMark_Pad.png"] forState:UIControlStateNormal];
                cell.rememberBtn.tag = Checked;
            }else{
                [cell.rememberBtn setImage:[UIImage imageNamed:@"Button_UnCheckMark_Pad.png"] forState:UIControlStateNormal];
                cell.rememberBtn.tag = UnChecked;
            }
        }else{
            if (flag) {
                [cell.rememberBtn setImage:[UIImage imageNamed:@"Button_CheckedMark.png"] forState:UIControlStateNormal];
                cell.rememberBtn.tag = Checked;
            }else{
                [cell.rememberBtn setImage:[UIImage imageNamed:@"Button_UnCheckMark.png"] forState:UIControlStateNormal];
                cell.rememberBtn.tag = UnChecked;
            }
        }
        [cell.rememberBtn addTarget:self action:@selector(savePassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

//根据版本状态提示信息
- (void)showVersionUpdateAlertWithStatus:(NSString *)status description:(NSString *)description{
    GEAlertViewDelegate *alertDelegate = [GEAlertViewDelegate defaultDelegate];
    if ([status isEqualToString:check_available]) {
        NSMutableString* msg =[NSMutableString stringWithString:@"您的版本需要更新，是否更新新版本? 下载新版本和更新过程需要5分钟以上时间，请耐心等候！\n"];
        [msg appendString:description];
        [alertDelegate showAlertViewWithTitle:@"提示" message:msg confirmButtonTitle:@"是" cancelButtonTitle:@"否" confirmBlock:^{
#warning appDelegate 要修改
           // [appDelegate upDateSoftware];
        } cancelBlock:^{
            
        }];
    }else if([status isEqualToString:check_unAvailable]){
        NSMutableString* msg =[NSMutableString stringWithString:@"您的版本过低，必须更新版本！下载新版本和更新过程需要5分钟以上时间，请耐心等候！\n"];
        [msg appendString:description];
        [alertDelegate showAlertViewWithTitle:@"提示" message:msg confirmButtonTitle:@"是" cancelButtonTitle:nil confirmBlock:^{
  #warning appDelegate 要修改
          //  [appDelegate upDateSoftware];
        } cancelBlock:^{
            
        }];
    }	
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (device_Type != UIUserInterfaceIdiomPad) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        self.view.frame = LoginContentViewMoveUpRect;
        [UIView commitAnimations];
    }
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (device_Type != UIUserInterfaceIdiomPad) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3f];
//        self.view.frame = LoginContentViewOrigenRect;
//        [UIView commitAnimations];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (device_Type != UIUserInterfaceIdiomPad) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        self.view.frame = LoginContentViewOrigenRect;
        [UIView commitAnimations];
    }
    return YES;
}

//根据当前用户初始化cookies
-(void)initWebViewCookies{
    //加密用户名密码
    NSString *user = [[User currentUser] workNo];
    NSString *pass = [[User currentUser] password];
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



//清理cookies
-(void)cleanCookies{
    NSLog(@"开始执行cookie清理操作");
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in [cookieStorage cookies]) {
        [cookieStorage deleteCookie:each];
    }
}

//处理加密串中可能出现的特殊字符
-(NSString *)encodeToPrecentEscapeString:(NSString *)input{
    NSString *output = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)input, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return [output autorelease];
}

@end
