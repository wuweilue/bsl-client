//
//  FPAnswerOnlineViewController.h
//  pilot
//
//  Created by lei chunfeng on 12-11-8.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthyDeclareInfo.h"

@interface FPAnswerOnlineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *questionListTableView;

// 数据源，题目数组
@property (retain, nonatomic) NSArray *questionArray;

// 是否显示答题结果
@property (nonatomic) BOOL isShowAnswer;

// 答题结果数组
@property (retain, nonatomic) NSMutableArray *showAnswerArray;

// 保存用户选中的cell选项对应的IndexPath
@property (retain, nonatomic) NSMutableArray *selectedIndexPaths;

// 总分
@property (nonatomic) int totalScore;

// 答题日志
@property (retain, nonatomic) NSMutableArray *ebExamLogInfoArray;

// 健康申报日志，从健康申报步骤传过来
@property (nonatomic, retain) HealthyDeclareInfo *healthyDeclareInfo;

// 该题目用户选中的选项个数
- (int)numberOfUserSelectedOptionInSection:(int)section;

@end
