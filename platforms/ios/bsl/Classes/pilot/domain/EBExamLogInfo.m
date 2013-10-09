//
//  EBExamLogInfo.m
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "EBExamLogInfo.h"

@implementation EBExamLogInfo

@synthesize seqNum;
@synthesize staffNo;
@synthesize testDate;
@synthesize result;
@synthesize baseCode;
@synthesize fltNo;
@synthesize fltDate;
@synthesize moduleId;

- (void)dealloc {
    [seqNum release];
    [staffNo release];
    [testDate release];
    [result release];
    [baseCode release];
    [fltNo release];
    [fltDate release];
    [moduleId release];
    [super dealloc];
}

@end
