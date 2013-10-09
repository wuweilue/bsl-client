//
//  FlightTaskQuery.h
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseQuery.h"

@interface FlightTaskQuery : BaseQuery

- (void)queryFlightTaskWithWorkNo:(NSString *)workNo completionBlock:(void (^)(NSArray *))completionBlock failedBlock:(void (^)(NSData *))failedBlock;

- (void)queryFlightTaskFromSDESWithWorkNo:(NSString *)workNo taskDays:(int)taskDays completionBlock:(void (^)(NSArray *))completionBlock failedBlock:(void (^)(NSData *))failedBlock;

@end
