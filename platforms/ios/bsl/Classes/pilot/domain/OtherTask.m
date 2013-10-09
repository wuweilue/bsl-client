//
//  OtherTask.m
//  pilot
//
//  Created by chen shaomou on 11/8/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "OtherTask.h"

@implementation OtherTask

@synthesize empId,code,beginTime,endTime;


-(void)dealloc{
    
    [empId release];
    [code release];
    [beginTime release];
    [endTime release];
    [super dealloc];
}

@end
