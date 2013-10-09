//
//  WaitDialog.h
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitDialog : UIView

+ (WaitDialog *)sharedWaitDialog;

- (void)startLoading;

- (void)stopLoading;

@end
