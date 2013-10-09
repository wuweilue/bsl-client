//
//  EBArticleLogInfo.h
//  pilot
//
//  Created by lei chunfeng on 12-11-8.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EBArticleLogInfo : NSManagedObject

@property (nonatomic, retain) NSString * staffNo; // 员工号
@property (nonatomic, retain) NSString * filename; // 重要文件编号
@property (nonatomic, retain) NSString * operType; // 操作类型
@property (nonatomic, retain) NSString * operDate; // 操作时间

@end
