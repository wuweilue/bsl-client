//
//  WaitDialog.m
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "WaitDialog.h"

static WaitDialog *sharedWaitdialog = nil;

@implementation WaitDialog

+ (WaitDialog *)sharedWaitDialog{
    @synchronized([WaitDialog class]){
        if (sharedWaitdialog == nil) {
            sharedWaitdialog = [[WaitDialog alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 1024.0)];
            sharedWaitdialog.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            return sharedWaitdialog;
        }
    }
    return sharedWaitdialog;
}

+ (id)alloc{
    @synchronized([WaitDialog class]){
        sharedWaitdialog = [super alloc];
        return sharedWaitdialog;
    }
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)startLoading{
#warning appDelegate 要修改
    //[appDelegate.window addSubview:sharedWaitdialog];
    //[appDelegate.window bringSubviewToFront:sharedWaitdialog];
}

- (void)stopLoading{
    [sharedWaitdialog removeFromSuperview];
    sharedWaitdialog = nil;
}

@end
