//
//  ExamInfo.h
//  pilot
//
//  Created by lei chunfeng on 12-11-13.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamInfo : NSObject

@property (nonatomic, retain) NSNumber *seqNum; // 题目编号
@property (nonatomic, retain) NSString *examText; // 问题
@property (nonatomic, retain) NSString *opt1; // 选项1，选项的个数不一定是四个
@property (nonatomic, retain) NSString *opt2; // 选项2
@property (nonatomic, retain) NSString *opt3; // 选项3
@property (nonatomic, retain) NSString *opt4; // 选项4
@property (nonatomic, retain) NSString *answer; // 答案
@property (nonatomic, retain) NSString *choiceType; // 题目类型
@property (nonatomic, retain) NSString *reference; // 提示信息

@end
