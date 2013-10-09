//
//  FlightTask.m
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "FlightTask.h"

@implementation FlightTask

@synthesize carrier;
@synthesize fltNo;
@synthesize fltDate;
@synthesize origin;
@synthesize destination;
@synthesize serverTime;
@synthesize token;

- (void)dealloc{
    [carrier release];
    [fltNo release];
    [fltDate release];
    [origin release];
    [destination release];
    [serverTime release];
    [token release];
    [super dealloc];
}

@end
