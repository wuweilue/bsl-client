//
//  NetworkStatusUtil.m
//  pilot
//
//  Created by wuzheng on 9/6/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "NetworkStatusUtil.h"

static NetworkStatusUtil *sharedNetworkStatusUtil = nil;

@implementation NetworkStatusUtil

+ (NetworkStatusUtil *)sharedNetworkStatusUtil{
    @synchronized([NetworkStatusUtil class]){
        if (sharedNetworkStatusUtil == nil) {
            sharedNetworkStatusUtil = [[NetworkStatusUtil alloc] init];
            return sharedNetworkStatusUtil;
        }
    }
    return sharedNetworkStatusUtil;
}

+ (id)alloc{
    @synchronized([NetworkStatusUtil class]){
        sharedNetworkStatusUtil = [super alloc];
        return sharedNetworkStatusUtil;
    }
    return nil;
}

// 检测联网状态
- (NetworkStatus)getNetworkStatus{
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus connectionStatus = [reachability currentReachabilityStatus];
    return connectionStatus;
}

// 检测网络是否可用
- (BOOL)checkNetworkStatusReachable{
    BOOL reachable = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus connectionStatus = [reachability currentReachabilityStatus];
    if (connectionStatus == NotReachable) {
        reachable = NO;
    }else{
        reachable = YES;
    }
    return reachable;
}

@end
