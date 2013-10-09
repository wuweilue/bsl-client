//
//  HealthyDeclareLocalInfo.h
//  pilot
//
//  Created by leichunfeng on 12-11-27.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HealthyDeclareLocalInfo : NSManagedObject

@property (nonatomic, retain) NSString * staffNo; // 员工号
@property (nonatomic, retain) NSString * fltDate; // 航班日期
@property (nonatomic, retain) NSString * fltNo; // 航班号

@end
