//
//  PushNotificationQuery.m
//  pilot
//
//  Created by wuzheng on 9/25/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "PushNotificationQuery.h"
#import "User.h"
#import "PushParam.h"

static PushNotificationQuery *sharedPushNotificationQuery = nil;

@implementation PushNotificationQuery
@synthesize push_token;
@synthesize allowPush;

- (void)dealloc{
    [push_token release];
    [super dealloc];
}

+ (PushNotificationQuery *)sharedPushNotificationQuery{
    @synchronized([PushNotificationQuery class]){
        if (sharedPushNotificationQuery == nil) {
            sharedPushNotificationQuery = [[PushNotificationQuery alloc] init];
        }
    }
    return sharedPushNotificationQuery;
}

//注册推送通知
- (void)bindPushServiceWithCompletionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSString *))failedBlock{
    PushParam *pushParam = [[PushParam alloc] init];
    pushParam.pushToken = push_token;
    pushParam.pushWorkNo = [User currentUser].workNo;
    pushParam.pushType = OS_Type;
    if (push_token && ![push_token isEqualToString:@""]) {
        [self updateObjectWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,PUSH_BIND_URL] object:pushParam completion:^(NSData *responseData) {
            NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            if (result) {
                completionBlock(result);
            }
        } failed:^(NSData *responseData) {
            NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            if (result) {
                failedBlock(result);
            }
        }];
    }
    
   [pushParam release];
    
}

//取消推送通知
- (void)unBindPushServiceWithCompletionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSString *))failedBlock{
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[User currentUser].workNo,nil] forKeys:[NSArray arrayWithObjects:@"pushWorkNo",nil]];
    [self queryDataWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,PUSH_UNBIND_URL] parameters:paramDic completion:^(NSData *responseData) {
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if (result) {
            completionBlock(result);
        }
    } failed:^(NSData *responseData) {
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if (result) {
            failedBlock(result);
        }
    }];
}

@end
