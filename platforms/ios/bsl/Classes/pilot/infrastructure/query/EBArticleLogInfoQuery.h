//
//  EBArticleLogInfoQuery.h
//  pilot
//
//  Created by lei chunfeng on 12-11-8.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"

@interface EBArticleLogInfoQuery : BaseQuery

- (void)postEBArticleLogInfoArray:(NSArray *)array workNo:(NSString *)workNo baseCode:(NSString *)baseCode fltNo:(NSString *)fltNo fltDate:(NSString *)fltDate planeType:(NSString *)planeType depPort:(NSString *)depPort totalTime:(NSString *)totalTime completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed;

@end
