//
//  VersionInfoQuery.m
//  pilot
//
//  Created by wuzheng on 9/13/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "VersionInfoQuery.h"

@implementation VersionInfoQuery

- (void)checkVersionWithVersionCode:(NSString *)versionCode completionBlock:(void(^)(NSMutableDictionary *))completionBlock failedBlock:(void (^)(NSMutableDictionary *))failedBlock{
    [self queryObjectWithURL:[NSString stringWithFormat:@"%@%@/%@",BASEURL,VERSION_CHECK,versionCode]  parameters:nil completion:^(NSObject *resopnseObj) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        if (resopnseObj) {
            VersionInfo *versionInfo = (VersionInfo *)resopnseObj;
            NSString *isnewest = versionInfo.isnewest;
            NSString *enable = versionInfo.enable;
            if ([@"Y" isEqualToString:isnewest]) {
                [dic setObject:check_newest forKey:@"status"];
            }else{
                if ([@"Y" isEqualToString:enable]) {
                    [dic setObject:check_available forKey:@"status"];
                    [dic setObject:versionInfo.description forKey:@"description"];
                }else{
                    [dic setObject:check_unAvailable forKey:@"status"];
                    [dic setObject:versionInfo.description forKey:@"description"];
                }
            }
        }else{
            [dic setObject:query_failed_flag forKey:@"status"];
        }
        completionBlock(dic);
    } failed:^(NSData *resopnseObj) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:query_failed_flag forKey:@"status"];
        failedBlock(dic);
    }];
}

@end
