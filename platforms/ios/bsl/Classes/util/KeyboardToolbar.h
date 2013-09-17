//
//  KeyboardObserver.h
//  CSMBP
//
//  Created by Justin Yip on 11-12-4.
//  Copyright (c) 2011年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardToolbar : NSObject {
    CGRect _originalFrame;
    NSMutableArray *_stack;
}

- (void)pushBindingViewController:(UIViewController*)aVC;
- (void)popBindingViewController;
@property (nonatomic,copy)void (^clickDone)();
+(id)sharedInstance;
- (UIView*)theRootView;
- (void)enableObserver;
- (void)disableObserver;
@property (nonatomic,retain) UIView* lastResponseView;
@end
