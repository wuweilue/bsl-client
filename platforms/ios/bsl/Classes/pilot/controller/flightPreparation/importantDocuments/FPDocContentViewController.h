//
//  FPDocContentViewController.h
//  pilot
//
//  Created by lei chunfeng on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPDocContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// 用于显示重要文件的正文
@property (retain, nonatomic) IBOutlet UIWebView *docContentWebView;

// 重要文件正文内容
@property (nonatomic, retain) NSString *contentTxt;

// 附件数据源
@property (nonatomic, retain) NSArray *dataSourceArray;

// 附件对应的URL
@property (nonatomic, retain) NSArray *annexURLArray;

@end
