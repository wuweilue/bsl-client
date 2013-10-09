//
//  FPHealthDeclarationTableViewCell.h
//  pilot
//
//  Created by lei chunfeng on 12-11-9.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPHealthDeclarationTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *unHealthyCountDescriptionLabel; // 不健康次数的描述文字
@property (retain, nonatomic) IBOutlet UILabel *unHealthyCountLabel; // 不健康次数
@property (retain, nonatomic) IBOutlet UILabel *staffNumLabel; // 员工号
@property (retain, nonatomic) IBOutlet UILabel *nameLabel; // 姓名
@property (retain, nonatomic) IBOutlet UILabel *taskFlightLabel; // 航班号
@property (retain, nonatomic) IBOutlet UILabel *aircraftModelLabel; // 机型
@property (retain, nonatomic) IBOutlet UILabel *declarationTimeLabel; // 申报时间

// 类方法，用于获取实例
+ (FPHealthDeclarationTableViewCell *)getInstance;

@end
