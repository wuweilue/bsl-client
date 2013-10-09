//
//  PushParam.m
//  pilot
//
//  Created by wuzheng on 9/26/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "PushParam.h"

@implementation PushParam

@synthesize pushType;
@synthesize pushWorkNo;
@synthesize pushToken;

- (void)dealloc{
    [pushToken release];
    [pushType release];
    [pushWorkNo release];
    [super dealloc];
}

@end
