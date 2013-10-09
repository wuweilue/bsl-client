//
//  TowFilesQuery.m
//  pilot
//
//  Created by wuzheng on 13-6-25.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "TowFilesQuery.h"

@implementation TowFilesQuery

- (void)queryTowFilesNameListWithPortCode:(NSString*)portCode planeType:(NSString *)planeType completion:(void (^)(NSObject *))completion failed:(void(^)(NSData *))failed{
    
    NSDictionary *paramDic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:portCode, planeType,nil] forKeys:[NSArray arrayWithObjects:@"portCode", @"planeType",nil]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,TOWFILE_LIST];

    [self queryObjectWithURL:url parameters:paramDic completion:^(NSObject *responseObject) {
        completion(responseObject);
    } failed:^(NSData *responseData) {
        failed(responseData);
    }];
}

- (void)queryTowFileWithPlaneType:(NSString*)planeType fileName:(NSString *)fileName completion:(void (^)(NSString *))completion failed:(void(^)(NSString *))failed{
    
}

@end
