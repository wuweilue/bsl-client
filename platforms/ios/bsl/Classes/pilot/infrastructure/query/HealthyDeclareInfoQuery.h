//
//  HealthyDeclareInfoQuery.h
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"

@interface HealthyDeclareInfoQuery : BaseQuery

- (void)postObject:(NSObject *)object date:(NSString *)date baseCode:(NSString *)baseCode planeType:(NSString *)planeType staffNo:(NSString *) staffNo fltNo:(NSString *)fltNo fltDate:(NSString *)fltDate depPort:(NSString *)depPort totalTime:(NSString *)totalTime completion:(void (^)(NSArray *))completion failed:(void (^)(NSData *))failed;

@end
