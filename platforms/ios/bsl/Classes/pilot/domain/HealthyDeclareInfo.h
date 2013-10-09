//
//  HealthyDeclareInfo.h
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthyDeclareInfo : NSObject

@property (nonatomic, retain) NSString *staffNo; // 员工号
@property (nonatomic, retain) NSString *fltDate; // 航班日期
@property (nonatomic, retain) NSString *fltNo; // 航班号
@property (nonatomic, retain) NSString *planeNo; // 机型
@property (nonatomic, retain) NSString *drinkFlag; // 饮酒标志
@property (nonatomic, retain) NSString *doseFlag; // 服药标志
@property (nonatomic, retain) NSString *drugDetail; // 服药详细信息
@property (nonatomic, retain) NSString *healthyFlag; // 健康标志
@property (nonatomic, retain) NSString *type; // 症状表现，文字形式，例：头痛、头晕
@property (nonatomic, retain) NSString *typeCode; // 症状表现，字母形式，例：Z-A-B
@property (nonatomic, retain) NSString *count; // 不健康次数
@property (nonatomic, retain) NSArray  *doctorPhoneList; // 航医电话
@property (nonatomic, retain) NSString *phoneNo; // 用户输入的手机号
@property (nonatomic, retain) NSString *declareDate; // 健康申报时间
@property (nonatomic, retain) NSString *remark; // 其他需要申报的内容
@property (nonatomic, retain) NSArray  *mobileList; // 机队联系手机

@end
