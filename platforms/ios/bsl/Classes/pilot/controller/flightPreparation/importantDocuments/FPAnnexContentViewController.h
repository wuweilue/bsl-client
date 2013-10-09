//
//  FPAnnexContentViewController.h
//  pilot
//
//  Created by lei chunfeng on 12-11-6.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FPAnnexContentViewController : UIViewController <UIWebViewDelegate>

// 用于显示附件的内容
@property (retain, nonatomic) IBOutlet UIWebView *annexContentWebView;

// 该附件的URL
@property (retain, nonatomic) NSURL *annexURL;

@property (retain, nonatomic) MBProgressHUD *mbProgressHUD;

// txt文件的内容
@property (retain, nonatomic) NSString *body;

@property (retain, nonatomic) NSString *annexString;

@end
