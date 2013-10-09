//
//  HealthyInfo.h
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthyInfo : NSObject

@property (nonatomic, retain) NSNumber *unHealthyCount; // 不健康次数
@property (nonatomic, retain) NSArray  *doctorPhoneList; // 航医电话
@property (nonatomic, retain) NSString *serviceTime; // 服务器时间
@property (nonatomic, retain) NSString *healthyFlag; // 健康标志
@property (nonatomic, retain) NSString *drinkFlag; // 饮酒标志
@property (nonatomic, retain) NSString *doseFlag; // 服药标志
@property (nonatomic, retain) NSString *drugDetail; // 服药详细信息
@property (nonatomic, retain) NSString *type; // 症状表现
@property (nonatomic, retain) NSString *remark; // 其他需要申报的内容
@property (nonatomic, retain) NSString *name; // 飞行员的姓名
@property (nonatomic, retain) NSArray  *mobileList; // 机队联系手机

@end