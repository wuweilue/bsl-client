//
//  ArticleInfoQuery.h
//  pilot
//
//  Created by lei chunfeng on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"

@interface ArticleInfoQuery : BaseQuery

- (void)queryArticleInfoWithWorkNo:(NSString *)workNo baseCode:(NSString *)baseCode fltNo:(NSString *)fltNo fltDate:(NSString *)fltDate depPort:(NSString *)depPort totalTime:(NSString *)totalTime completionBlock:(void (^)(NSArray *))completionBlock failedBlock:(void (^)(NSData *))failedBlock;

@end
