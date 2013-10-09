//
//  FeedBackQuery.m
//  pilot
//
//  Created by chen shaomou on 8/29/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "FeedBackQuery.h"

@implementation FeedBackQuery

-(void)uploadAllFeedBacksWithCompletionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSString *))failedBlock{

    NSArray *allFeeBacks = [FeedBack findAll];
    
    [self updateArrayWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,FEEDBACK_UPDATE_URL] array:allFeeBacks completion:^(NSData *responseData){
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        completionBlock(result);
        [result release];
    } failed:^(NSData *responseData){
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"upload FeedBacks failed %@",result);
        failedBlock(result);
        [result release];
    }];
}

@end
 