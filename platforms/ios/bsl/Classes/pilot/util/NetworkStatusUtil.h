//
//  NetworkStatusUtil.h
//  pilot
//
//  Created by wuzheng on 9/6/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkStatusUtil : NSObject

+ (NetworkStatusUtil *)sharedNetworkStatusUtil;

- (NetworkStatus)getNetworkStatus;

- (BOOL)checkNetworkStatusReachable;

@end
