//
//  PilotAppDelegate.m
//  pilot
//
//  Created by chen shaomou on 8/20/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "PilotAppDelegate.h"
#import "RepositoryManager.h"
#import "NSData+Hex.h"
#import "PushNotificationQuery.h"
#import "RNCachingURLProtocol.h"

@implementation PilotAppDelegate
@synthesize window = _window;
@synthesize rootViewController = _rootViewController;
@synthesize loginViewController;
@synthesize showGuidance = _showGuidance;

- (void)dealloc
{
    [_window release];
    if (loginViewController) {
        [loginViewController release];
    }
   
    [_showGuidance release];
    [super dealloc];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //注册一个自定义协议，缓存
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    loginViewController = [[PilotLoginViewController alloc] initWithNib];
    rootViewController = [[PilotNavigationViewController alloc] initWithRootViewController:loginViewController];
    [self.window makeKeyAndVisible];
    
    // 新功能推荐
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"Pilot_Version"];
    // 第一次进入新版本时显示新功能推荐界面，否则直接进入登录界面
    if (oldVersion == nil || ![oldVersion isEqualToString:version]) {
        ShowGuidance *aShowGuidance = [[ShowGuidance alloc] init];
        [aShowGuidance setGuidanceContent:@"NewFunctionPush"];
        self.showGuidance = aShowGuidance;
        aShowGuidance.delegate = self;
        [aShowGuidance release];
        
        [self.window addSubview:_showGuidance.view];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    } else {
        self.window.rootViewController = rootViewController;
    }
    
//   self.window.rootViewController = loginViewController;
//    [_window insertSubview:loginViewController.view atIndex:0];
    
   //[loginViewController release];
    
    [self registerForRemoteNotification];
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    NSLog(@"当前的iconBadge:%d", application.applicationIconBadgeNumber);
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

//加入apns推送功能
- (void)registerForRemoteNotification{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *token = [deviceToken stringWithHexBytes];
    NSLog(@"获取到的推送token:%@", token);
    PushNotificationQuery *pushNotificationQuery = [PushNotificationQuery sharedPushNotificationQuery];
    pushNotificationQuery.push_token = token;
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];  
    NSLog(@"获取推送token失败:%@", error_str);  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[RepositoryManager shareRepositoryManager] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[RepositoryManager shareRepositoryManager] saveContext];
}

//版本更新
-(void)upDateSoftware{
    NSURL *url = [NSURL URLWithString:UPDATESOFTWARE];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - ShowGuidanceDelegate

-(void)scrollViewDidFinished {
    self.window.rootViewController = rootViewController;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    //记录新功能推荐版本号
    NSString *Pilot_VERSION = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults] setValue:Pilot_VERSION forKey:@"Pilot_Version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
