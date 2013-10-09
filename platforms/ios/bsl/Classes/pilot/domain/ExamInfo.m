//
//  ExamInfo.m
//  pilot
//
//  Created by lei chunfeng on 12-11-13.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "ExamInfo.h"

@implementation ExamInfo

@synthesize seqNum;
@synthesize examText;
@synthesize opt1;
@synthesize opt2;
@synthesize opt3;
@synthesize opt4;
@synthesize answer;
@synthesize choiceType;
@synthesize reference;

- (void)dealloc {
    [seqNum release];
    [examText release];
    [opt1 release];
    [opt2 release];
    [opt3 release];
    [opt4 release];
    [answer release];
    [choiceType release];
    [reference release];
    [super dealloc];
}

@end
