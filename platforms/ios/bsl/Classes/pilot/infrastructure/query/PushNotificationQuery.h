//
//  PushNotificationQuery.h
//  pilot
//
//  Created by wuzheng on 9/25/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseQuery.h"

@interface PushNotificationQuery : BaseQuery{
    NSString                    *push_token;
    BOOL                        allowPush;
}

@property (nonatomic, retain) NSString *push_token;
@property (nonatomic) BOOL allowPush;

+ (PushNotificationQuery *)sharedPushNotificationQuery;

- (void)bindPushServiceWithCompletionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSString *))failedBlock;

- (void)unBindPushServiceWithCompletionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSString *))failedBlock;

@end
