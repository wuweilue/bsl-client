//
//  FPAnnexListViewController.h
//  pilot
//
//  Created by leichunfeng on 13-6-13.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPAnnexListViewController : UITableViewController

// 附件数据源
@property (nonatomic, retain) NSArray *dataSourceArray;

// 附件对应的URL
@property (nonatomic, retain) NSArray *annexURLArray;

@end
