//
//  PilotTask.m
//  pilot
//
//  Created by chen shaomou on 11/8/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "PilotTask.h"

@implementation PilotTask

@synthesize empId,currentTime,totalTime,fltTasks,otherTasks;

-(void)dealloc{
    [empId release];
    [currentTime release];
    [totalTime release];
    [fltTasks release];
    [otherTasks release];
    [super dealloc];
    
}

@end
