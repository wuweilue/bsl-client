//
//  ArticleInfoQuery.m
//  pilot
//
//  Created by lei chunfeng on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "ArticleInfoQuery.h"

@implementation ArticleInfoQuery

- (void)queryArticleInfoWithWorkNo:(NSString *)workNo baseCode:(NSString *)baseCode fltNo:(NSString *)fltNo fltDate:(NSString *)fltDate depPort:(NSString *)depPort totalTime:(NSString *)totalTime completionBlock:(void (^)(NSArray *))completionBlock failedBlock:(void (^)(NSData *))failedBlock {
    [self queryArrayWithURL:[NSString stringWithFormat:@"%@%@/%@/%@/%@/%@/%@/%@", BASEURL, ARTICLE_INFO_URL, workNo, baseCode, fltNo, fltDate, depPort, totalTime] parameters:nil completion:^(NSArray *responseArray) {
        completionBlock(responseArray);
    } failed:^(NSData *responseData) {
        failedBlock(responseData);
    }];
}

@end