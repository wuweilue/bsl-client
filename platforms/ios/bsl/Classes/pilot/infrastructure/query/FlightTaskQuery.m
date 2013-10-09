//
//  FlightTaskQuery.m
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "FlightTaskQuery.h"

@implementation FlightTaskQuery

- (void)queryFlightTaskWithWorkNo:(NSString *)workNo completionBlock:(void (^)(NSArray *))completionBlock failedBlock:(void (^)(NSData *))failedBlock{
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:workNo,nil] forKeys:[NSArray arrayWithObjects:@"workNo", nil]];
    [self queryArrayWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,FLIGHT_TASK] parameters:paramDic completion:^(NSArray *responseArray) {
        completionBlock(responseArray);
    } failed:^(NSData *responseData) {
        failedBlock(responseData);
    }];
}

- (void)queryFlightTaskFromSDESWithWorkNo:(NSString *)workNo taskDays:(int)days completionBlock:(void (^)(NSArray *))completionBlock failedBlock:(void (^)(NSData *))failedBlock{
    NSNumber *taskDays = [NSNumber numberWithInt:days];
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:workNo,taskDays,nil] forKeys:[NSArray arrayWithObjects:@"workNo",@"taskDays",nil]];
    [self queryArrayWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,TASK_SDES] parameters:paramDic completion:^(NSArray *responseArray) {
        completionBlock(responseArray);
    } failed:^(NSData *responseData) {
        failedBlock(responseData);
    }];
}

@end
