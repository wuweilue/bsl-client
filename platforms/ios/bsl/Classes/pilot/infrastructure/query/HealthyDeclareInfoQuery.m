//
//  HealthyDeclareInfoQuery.m
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "HealthyDeclareInfoQuery.h"

@implementation HealthyDeclareInfoQuery

- (void)postObject:(NSObject *)object date:(NSString *)date baseCode:(NSString *)baseCode planeType:(NSString *)planeType staffNo:(NSString *) staffNo fltNo:(NSString *)fltNo fltDate:(NSString *)fltDate depPort:(NSString *)depPort totalTime:(NSString *)totalTime completion:(void (^)(NSArray *))completion failed:(void (^)(NSData *))failed {
    
    NSArray *objectsArray = [NSArray arrayWithObjects:date, baseCode, planeType, staffNo, fltNo, fltDate, depPort, totalTime, nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"date", @"baseCode", @"planeType", @"staffNo", @"fltNo", @"fltDate", @"depPort", @"totalTime", nil];
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjects:objectsArray forKeys:keysArray];
    [self postObjectWithURL:[NSString stringWithFormat:@"%@%@", BASEURL, HEALTHY_DECLARE_INFO_URL] object:object parameters:paramDic completion:^(NSObject *responseObject) {
        completion((NSArray *)responseObject);
    } failed:^(NSData *responseData) {
        failed(responseData);
    }];
    [paramDic release];
}

@end