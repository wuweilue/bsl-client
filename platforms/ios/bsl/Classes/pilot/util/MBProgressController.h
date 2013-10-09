//
//  MBProgressController.h
//  CSMBP
//
//  Created by 晶多 陈 on 12-3-12.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIProgressDelegate.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
@protocol MBProgressControllerDelegate<NSObject>
-(void)cancelTheRequest;
@end

@interface MBProgressController : NSObject<ASIProgressDelegate,MBProgressHUDDelegate,ASIProgressDelegate>
{
    MBProgressHUD *HUD;
    NSString *message;
    id<MBProgressControllerDelegate> delegate;
    UIButton *staticClick;
    BOOL safeConnet;
}
@property(nonatomic,retain) MBProgressHUD *HUD;
@property(nonatomic,retain) UIButton *staticClick;
@property(nonatomic,retain) NSString *message;
@property (assign) id<MBProgressControllerDelegate> delegate;
@property (assign) BOOL safeConnet;
+(void)startQueryProcess;
+(MBProgressController*)getCurrentController;
+(void)setMessage:(NSString*)aMessage;
+(void)setMode:(MBProgressHUDMode)aMode;
-(void)initProcessWithMessage:(NSString*)aMessage;
+(void)changeState:(MBProgressHUDMode)aMode withMessage:(NSString*)aMessage;
+(void)dismiss;
+(void)correctComplete;
+(void)failedCompelete;
+(void)cancel:(id)sender;
+(void)setSafeConnet;
@end
