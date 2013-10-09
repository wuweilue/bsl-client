//
//  EBExamLogInfo.h
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBExamLogInfo : NSObject

@property (nonatomic, retain) NSNumber *seqNum; // 题目编号
@property (nonatomic, retain) NSString *staffNo; // 员工号
@property (nonatomic, retain) NSString *testDate; // 答题时间
@property (nonatomic, retain) NSString *result; // 结果
@property (nonatomic, retain) NSString *baseCode; // 基地代码
@property (nonatomic, retain) NSString *fltNo; // 航班号
@property (nonatomic, retain) NSString *fltDate; // 航班日期
@property (nonatomic, retain) NSString *moduleId; // 步骤

@end
