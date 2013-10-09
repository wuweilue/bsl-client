//
//  EBArticleLogInfoQuery.m
//  pilot
//
//  Created by lei chunfeng on 12-11-8.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "EBArticleLogInfoQuery.h"

@implementation EBArticleLogInfoQuery

- (void)postEBArticleLogInfoArray:(NSArray *)array workNo:(NSString *)workNo baseCode:(NSString *)baseCode fltNo:(NSString *)fltNo fltDate:(NSString *)fltDate planeType:(NSString *)planeType depPort:(NSString *)depPort totalTime:(NSString *)totalTime completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed {
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:workNo, baseCode, fltNo, fltDate,planeType, depPort, totalTime, nil] forKeys:[NSArray arrayWithObjects:@"workNo", @"baseCode", @"fltNo", @"fltDate",@"planeType",@"depPort", @"totalTime", nil]];
    [self postArrayWithURL:[NSString stringWithFormat:@"%@%@", BASEURL, ARTICLE_LOG_INFO_URL] array:array parameters:paramDic completion:^(NSObject *responseObject) {
        completion(responseObject);
    } failed:^(NSData *responseData) {
        failed(responseData);
    }];
    [paramDic release];
}

@end
