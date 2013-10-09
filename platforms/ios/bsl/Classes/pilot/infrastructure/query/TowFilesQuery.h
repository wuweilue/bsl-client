//
//  TowFilesQuery.h
//  pilot
//
//  Created by wuzheng on 13-6-25.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseQuery.h"

@interface TowFilesQuery : BaseQuery

- (void)queryTowFilesNameListWithPortCode:(NSString*)portCode planeType:(NSString *)planeType completion:(void (^)(NSObject *))completion failed:(void(^)(NSData *))failed;

- (void)queryTowFileWithPlaneType:(NSString*)planeType fileName:(NSString *)fileName completion:(void (^)(NSString *))completion failed:(void(^)(NSString *))failed;

@end
