//
//  FeedBackQuery.h
//  pilot
//
//  Created by chen shaomou on 8/29/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"
#import "FeedBack.h"

@interface FeedBackQuery : BaseQuery

-(void)uploadAllFeedBacksWithCompletionBlock:(void (^)(NSString *))completionBlock failedBlock:(void (^)(NSString *))failedBlock;

@end
