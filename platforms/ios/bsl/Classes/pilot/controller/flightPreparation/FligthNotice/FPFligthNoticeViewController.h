//
//  FPFligthNoticeViewController.h
//  pilot
//
//  Created by Sencho Kong on 12-11-7.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPFligthNoticeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *noticeInfoTableView;
@property (retain, nonatomic) IBOutlet UITableView *plantInfoTableView;
@property (retain, nonatomic) IBOutlet UITableView *mapTablewView;
@property (retain, nonatomic) IBOutlet UITableViewCell *AirlineDataCell;

@end
