//
//  FPHealthDeclarationViewController.h
//  pilot
//
//  Created by lei chunfeng on 12-11-8.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthyInfo.h"
#import "HealthyDeclareInfo.h"
#import "DCRoundSwitch.h"

@interface FPHealthDeclarationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *healthDeclarationTableView;

// 用于选择是否饮酒，DCRoundSwitch为可以自定义开关文字的UISwitch子类
@property (retain, nonatomic) DCRoundSwitch *isDrinkSwitch;

// 用于选择是否服药
@property (retain, nonatomic) DCRoundSwitch *isMedicationSwitch;

// 用于选择是否健康
@property (retain, nonatomic) DCRoundSwitch *isHealthySwitch;

// 用户输入的手机号
@property (retain, nonatomic) NSString *userPhoneNumber;

// 用户选择的症状表现
@property (retain, nonatomic) NSMutableArray *selectedsymptomExpressionArray;

// 用户输入的其他需要申报的内容
@property (retain, nonatomic) NSString *otherDeclarationContent;

// 用户输入的所服用药品的名称
@property (retain, nonatomic) NSString *drugDetailInfo;

// 重要文件界面传过来的待提交的日志数组
@property (nonatomic, retain) NSMutableArray *ebArticleLogInfoArray;

// 查询到的健康申报界面的初始信息
@property (nonatomic, retain) HealthyInfo *healthyInfo;

// 用户输入后的待提交的健康申报信息
@property (nonatomic, retain) HealthyDeclareInfo *healthyDeclareInfo;

// 是否再次查询健康申报信息的标志
// 0代表需要，其他代表不需要
// 0代表从其他界面返回
// 1代表从输入服药信息的界面返回，不需要再次查询
// 2代表从选择症状界面返回，不需要查询
@property (nonatomic, retain) NSNumber *ifQueryFlag;

// 上一步持续时间
@property (nonatomic, retain) NSString *totalTime;

// 下一步按钮
@property (nonatomic, retain) UIButton *buttonForNextStep;

@end
