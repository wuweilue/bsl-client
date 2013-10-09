//
//  UserQuery.h
//  pilot
//
//  Created by chen shaomou on 8/24/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"
#import "User.h"

#define LOGIN_SUCESS @"Y"
#define LOGIN_FAILED @"N"
#define LOGIN_OA @"OA"
#define NETWORK_EXCEPTION @"EXCEPTION"

@interface UserQuery : BaseQuery

-(void) loginWithWorkNo:(NSString *)workNo password:(NSString *)password completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSString *))failedBlock;

-(void) newLoginWithWorkNo:(NSString *)workNo password:(NSString *)password completionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSString *))failedBlock;

-(void)updateUser:(User *)user;

- (void)queryAllUserscompletionBlock:(void (^)(NSArray *))completionBlock failedBlock:(void (^)(NSString *))failedBlock;

@end
