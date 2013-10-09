//
//  TowFileName.m
//  pilot
//
//  Created by wuzheng on 13-6-25.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "TowFileName.h"

@implementation TowFileName
@synthesize fileNameList;

- (void)dealloc{
    [fileNameList release];
    [super dealloc];
}

@end
