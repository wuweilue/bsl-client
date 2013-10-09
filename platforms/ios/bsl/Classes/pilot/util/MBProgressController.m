//
//  MBProgressController.m
//  CSMBP
//
//  Created by 晶多 陈 on 12-3-12.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import "MBProgressController.h"

#define kCancelBtn_X 255
#define kCancelBtn_Y 171

@implementation MBProgressController
@synthesize HUD;
@synthesize safeConnet;
@synthesize delegate;
@synthesize message;
@synthesize staticClick;
static MBProgressController *currentMBProgressView;
+(MBProgressController*)getCurrentController
{
    if (nil == currentMBProgressView) {
		currentMBProgressView = [[MBProgressController alloc] init];
        currentMBProgressView.message=[[[NSString alloc]initWithString:@""]autorelease];
        currentMBProgressView.safeConnet=NO;
	}
    return currentMBProgressView;
}

+(void)setMessage:(NSString*)aMessage
{
    if (!currentMBProgressView) {
        [MBProgressController getCurrentController];
    }
    currentMBProgressView.message=aMessage;
    [MBProgressController changeState:currentMBProgressView.HUD.mode withMessage:aMessage];
}

+(void)setMode:(MBProgressHUDMode)aMode
{
    if (!currentMBProgressView) {
        [MBProgressController getCurrentController];
    }
    [MBProgressController changeState:aMode withMessage:nil];
}

+(void)setSafeConnet
{
    if (!currentMBProgressView) {
        [MBProgressController getCurrentController];
    }
    currentMBProgressView.safeConnet=YES;
}

-(void)initProcessWithMessage:(NSString*)aMessage
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    self.HUD = [[[MBProgressHUD alloc] initWithView:window] autorelease];
    UIButton *click=[[UIButton alloc] initWithFrame:CGRectMake(95, 275, 130, 30)];
    [click setTitle:@"点击此处取消连接" forState:UIControlStateNormal];
    [click addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [click.titleLabel setFont:[UIFont fontWithName:@"helvetica" size:12]];
    [click setBackgroundColor:[UIColor clearColor]];
    
    [self.HUD addSubview:click];
    [click release];
    [window addSubview:self.HUD];
    self.HUD.alpha=0.8;
    self.HUD.delegate = self;
    self.HUD.labelText = aMessage; 
    self.HUD.mode=MBProgressHUDModeIndeterminate;
    currentMBProgressView=self;
}

+ (void)startQueryProcess
{
    if (!currentMBProgressView) {
        [MBProgressController getCurrentController];
    }
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    currentMBProgressView.HUD = [[[MBProgressHUD alloc] initWithView:window] autorelease];
    
    UIButton *click=[UIButton buttonWithType:UIButtonTypeCustom];
    CALayer *layer=[click layer];  
    //是否设置边框以及是否可见  
    [layer setMasksToBounds:YES];  
    //设置边框圆角的弧度  
    [layer setCornerRadius:6.0];  
   
    [click setBackgroundImage: [UIImage imageNamed:@"btn_login_cancel.png"] forState:UIControlStateNormal];
    
    CGPoint centerOfHUD = currentMBProgressView.HUD.center;
    if (device_Type == UIUserInterfaceIdiomPad) {
        [click setFrame:CGRectMake(0, 0, 30, 30)];
        if (UIInterfaceOrientationIsLandscape(currentInterfaceOrientation)) {
            [click setCenter:CGPointMake(centerOfHUD.y+106+512, centerOfHUD.x-50+384)];
        } else {
            [click setCenter:CGPointMake(490+384, 462+512)];
        }
    } else {
       click.frame = CGRectMake(kCancelBtn_X+157, kCancelBtn_Y+243, 30, 30);
    }
    
    [click setBackgroundColor:[UIColor clearColor]];
    
    [click addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [click.titleLabel setFont:[UIFont fontWithName:@"helvetica" size:16]];
    
    [currentMBProgressView.HUD addSubview:click];
    
    click.enabled=currentMBProgressView.safeConnet;
    click.hidden=!currentMBProgressView.safeConnet;
  
    [window addSubview:currentMBProgressView.HUD];
    currentMBProgressView.HUD.alpha=0.8;
    currentMBProgressView.HUD.delegate = currentMBProgressView;
    currentMBProgressView.HUD.dimBackground = YES;
    if (currentMBProgressView.HUD.labelText==nil) {
        if (currentMBProgressView.message) {
            currentMBProgressView.HUD.labelText=currentMBProgressView.message;
        }
        else {
            currentMBProgressView.HUD.labelText=@"连接中";
        }
    }
    currentMBProgressView.HUD.mode=MBProgressHUDModeIndeterminate;
    currentMBProgressView.staticClick=click;
    
    [[NSNotificationCenter defaultCenter] addObserver:currentMBProgressView selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


+(void)changeState:(MBProgressHUDMode)aMode withMessage:(NSString *)aMessage
{
    if(!currentMBProgressView)
    {
        [MBProgressController getCurrentController];
    }
//        if (aImage) {
//            currentMBProgressView.HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:aImage]] autorelease];
//        }
    if (aMode) {
        currentMBProgressView.HUD.mode=aMode;
    }
    if (aMessage) {
        currentMBProgressView.HUD.labelText=aMessage;
    }
}

+(void)correctComplete
{
//    currentMBProgressView.staticClick.frame=CGRectMake(92, 273, 136, 25);
//    currentMBProgressView.HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]] autorelease];
//    currentMBProgressView.HUD.mode=MBProgressHUDModeCustomView;
//    currentMBProgressView.HUD.labelText=@"Completed";
    [MBProgressController dismiss];
}

+ (void)failedCompelete
{
//    currentMBProgressView.staticClick.frame=CGRectMake(87, 275, 146, 30);
    currentMBProgressView.HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]] autorelease];
    currentMBProgressView.HUD.mode=MBProgressHUDModeCustomView;
    currentMBProgressView.HUD.labelText=@"网络异常";
    [MBProgressController dismiss];
}

+ (void)dismiss
{
    if (currentMBProgressView) {
        currentMBProgressView.message=nil;
        currentMBProgressView.safeConnet=NO;
        [currentMBProgressView.HUD hide:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:currentMBProgressView name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

+(void)cancel:(id)sender
{
    [MBProgressController dismiss];
    if (currentMBProgressView.delegate) {
        [currentMBProgressView.delegate cancelTheRequest];
    }
}



-(void)dealloc
{
    self.HUD=nil;
    self.message=nil;
    self.staticClick=nil;
    [super dealloc];
}


#pragma mark -- MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

#pragma mark -- ASIProgressDelegate methods

- (void)setProgress:(float)newProgress {//进度条的代理
	NSLog(@"------%f",newProgress);
       if (newProgress>0) {
//           self.staticClick.frame=CGRectMake(95, 275, 130, 30);
            self.HUD.mode = MBProgressHUDModeDeterminate;
            self.HUD.labelText = @"读取中";
            self.HUD.progress=newProgress;
        }
}

#pragma mark - Actions

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	if (!currentMBProgressView) {
        [MBProgressController getCurrentController];
    }
    CGPoint centerOfHUD = currentMBProgressView.HUD.center;
    if (device_Type == UIUserInterfaceIdiomPad) {
        [currentMBProgressView.staticClick setFrame:CGRectMake(0, 0, 30, 30)];
        if (UIInterfaceOrientationIsLandscape(currentInterfaceOrientation)) {
            [currentMBProgressView.staticClick setCenter:CGPointMake(centerOfHUD.y+106+512, centerOfHUD.x-50+384)];
        } else {
            [currentMBProgressView.staticClick setCenter:CGPointMake(490+384, 462+512)];
        }
    } else {
        currentMBProgressView.staticClick.frame = CGRectMake(kCancelBtn_X+157, kCancelBtn_Y+243, 30, 30);
    }
}

@end
