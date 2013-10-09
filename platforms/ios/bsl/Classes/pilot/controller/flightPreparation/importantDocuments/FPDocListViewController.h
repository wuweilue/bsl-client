//
//  DocListViewController.h
//  pilot
//
//  Created by lei chunfeng on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPDocListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// 用于显示重要文件列表
@property (retain, nonatomic) IBOutlet UITableView *docListTableView;

// 数据源数组
@property (nonatomic, retain) NSMutableArray *dataSourceArray;

// 已读的重要文件
@property (nonatomic, retain) NSMutableArray *readDocumentArray;;

// 保存待要提交的日志，每查看一个重要文件将对应生成一条日志
@property (nonatomic, retain) NSMutableArray *ebArticleLogInfoArray;

// 下一步按钮
@property (nonatomic, retain) UIButton *buttonForNextStep;

// 查询重要文件
- (void)queryArticleInfo;

// 将查询出来的重要文件与SQLite中的日志进行比较，看是否存在以前查看过但未提交日志的重要文件
- (void)judgeIfHaveArticleReadBefore;

@end
