//
//  VersionInfoQuery.h
//  pilot
//
//  Created by wuzheng on 9/13/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseQuery.h"
#import "VersionInfo.h"

@interface VersionInfoQuery : BaseQuery

- (void)checkVersionWithVersionCode:(NSString *)versionCode completionBlock:(void(^)(NSMutableDictionary *))completionBlock failedBlock:(void (^)(NSMutableDictionary *))failedBlock;

@end
