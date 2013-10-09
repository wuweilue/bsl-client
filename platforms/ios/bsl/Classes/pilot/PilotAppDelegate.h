//
//  PilotAppDelegate.h
//  pilot
//
//  Created by chen shaomou on 8/20/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PilotLoginViewController.h"
#import "ShowGuidance.h"
#import "PilotNavigationViewController.h"

@interface PilotAppDelegate : NSObject <UIApplicationDelegate,UINavigationControllerDelegate, ShowGuidanceDelegate>{
    UIWindow *_window;
    PilotNavigationViewController *rootViewController;
    PilotLoginViewController *loginViewController;
    
}

@property (retain, nonatomic) UIWindow *window;
@property (nonatomic, assign) PilotNavigationViewController *rootViewController;
@property (retain, nonatomic) PilotLoginViewController *loginViewController;

@property (strong, nonatomic) ShowGuidance *showGuidance;

-(void)upDateSoftware;

- (void)registerForRemoteNotification;

@end
