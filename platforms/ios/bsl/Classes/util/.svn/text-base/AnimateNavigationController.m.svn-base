//
//  AnimateNavigationController.m
//  CSMBP
//
//  Created by Justin Yip on 3/9/12.
//  Copyright (c) 2012 Forever OpenSource Software Inc. All rights reserved.
//

#import "AnimateNavigationController.h"
#import <QuartzCore/CAAnimation.h>

@interface AnimateNavigationController ()

@end

@implementation AnimateNavigationController

- (void)pushViewController:(UIViewController *)viewController 
                 animation:(void (^)(UIViewController *))block
{
//    dumpViews(self.view, @"aa", @"");
    UIView *tsView = [self.view.subviews objectAtIndex:0];
    
    CGRect rect = viewController.view.frame;
    rect.origin.x -= CGRectGetWidth(rect);
    viewController.view.frame = rect;
    
    [tsView addSubview:viewController.view];
    
    UIViewController *old = self.topViewController;
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = old.view.frame;
        frame.origin.x += 160;
        old.view.frame = frame;
        
        CGRect rect = viewController.view.frame;
        rect.origin.x = 0;
        viewController.view.frame = rect;
        
    } completion:^(BOOL finished) {
        [viewController.view removeFromSuperview];
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.viewControllers];
        [newArray addObject:viewController];
        self.viewControllers = newArray;
        [newArray release];
    }];
    
    
}

@end

@implementation UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.7f;
    transition.type = kCATransitionFromTop;
	[self.view.layer addAnimation:transition forKey:nil];
    
	[self pushViewController:viewController animated:NO];
}

- (void)fadePopViewController
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
	[self popViewControllerAnimated:NO];
}

@end
