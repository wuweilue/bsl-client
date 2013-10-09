//
//  EBExamLogInfoQuery.m
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "EBExamLogInfoQuery.h"

@implementation EBExamLogInfoQuery

- (void)postEBExamLogInfoArray:(NSArray *)array staffNo:(NSString *)staffNo fltNo:(NSString *)fltNo fltDate:(NSString *)fltDate depPort:(NSString *)depPort totalTime:(NSString *)totalTime completion:(void (^)(NSString *))completion failed:(void (^)(NSData *))failed {
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:staffNo, fltNo, fltDate, depPort, totalTime, nil] forKeys:[NSArray arrayWithObjects:@"staffNo", @"fltNo", @"fltDate", @"depPort", @"totalTime", nil]];
    [self postArrayWithURL:[NSString stringWithFormat:@"%@%@", BASEURL, EXAM_LOG_INFO_URL] array:array parameters:paramDic completion:^(NSObject *responseObject) {
        completion((NSString *)responseObject);
    } failed:^(NSData *responseData) {
        failed(responseData);
    }];
    [paramDic release];
}

@end
