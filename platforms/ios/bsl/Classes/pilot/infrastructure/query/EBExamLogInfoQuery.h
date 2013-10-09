//
//  EBExamLogInfoQuery.h
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"

@interface EBExamLogInfoQuery : BaseQuery

- (void)postEBExamLogInfoArray:(NSArray *)array staffNo:(NSString *)staffNo fltNo:(NSString *)fltNo fltDate:(NSString *)fltDate depPort:(NSString *)depPort totalTime:(NSString *)totalTime completion:(void (^)(NSString *))completion failed:(void (^)(NSData *))failed;

@end
