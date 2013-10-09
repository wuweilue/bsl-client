//
//  FltTask.h
//  pilot
//
//  Created by chen shaomou on 11/8/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface FltTask : NSObject

@property(retain,nonatomic) NSString *flightNo;//航班号

@property(retain,nonatomic) NSString *leaderNo;//确认领导

@property(retain,nonatomic) NSString *taskType;//任务类型

@property(retain,nonatomic) NSString *depPort;//始发站

@property(retain,nonatomic) NSString *arrPort;//到达站

@property(retain,nonatomic) NSString *depTime;//起飞时刻

@property(retain,nonatomic) NSString *arrTime;//到达时刻

@property(retain,nonatomic) NSString *plane;//机型

@property(retain,nonatomic) NSString *tailNum;//飞机号

@property(retain,nonatomic) NSString *flightDate; // 航班日期

@property(retain,nonatomic) NSArray*   members;  //机组成员

@property(retain,nonatomic) NSString* readyFlag; //完成飞行准备标识

@property(retain,nonatomic) NSString* readyFlagName; //完成飞行准备标识中文

@end
