//
//  AnimateNavigationController.h
//  CSMBP
//  可以自定义动画的导航控制器，但保留与官方SDK相同的使用体验
//
//  Created by Justin Yip on 3/9/12.
//  Copyright (c) 2012 Forever OpenSource Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimateNavigationController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController 
                 animation:(void (^)(UIViewController *))block;

@end

@interface UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController;
- (void)fadePopViewController;

@end