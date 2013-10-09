//
//  Task.m
//  pilot
//
//  Created by wuzheng on 13-7-12.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "Task.h"

@implementation Task
@synthesize actingRank;
@synthesize alnCd;
@synthesize arrPort;
@synthesize arrPortName;
@synthesize arrTime;
@synthesize depPort;
@synthesize depPortName;
@synthesize depTime;
@synthesize flightDate;
@synthesize flightNo;
@synthesize name;
@synthesize plane;
@synthesize planeId;
@synthesize schFlightDate;
@synthesize taskType;

- (void)dealloc{
    [actingRank release];
    [alnCd release];
    [arrPort release];
    [arrPortName release];
    [arrTime release];
    [depPort release];
    [depPortName release];
    [depTime release];
    [flightDate release];
    [flightNo release];
    [name release];
    [plane release];
    [planeId release];
    [schFlightDate release];
    [taskType release];
    [super dealloc];
}

@end
