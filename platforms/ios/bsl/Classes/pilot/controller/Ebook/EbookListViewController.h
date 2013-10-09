//
//  EbookListViewController.h
//  pilot
//
//  Created by Sencho Kong on 13-2-4.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EbookListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView* tableView;
@end
