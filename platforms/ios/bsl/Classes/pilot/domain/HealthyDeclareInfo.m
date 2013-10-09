//
//  HealthyDeclareInfo.m
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "HealthyDeclareInfo.h"

@implementation HealthyDeclareInfo

@synthesize staffNo;
@synthesize fltDate;
@synthesize fltNo;
@synthesize planeNo;
@synthesize drinkFlag;
@synthesize doseFlag;
@synthesize drugDetail;
@synthesize healthyFlag;
@synthesize type;
@synthesize typeCode;
@synthesize count;
@synthesize doctorPhoneList;
@synthesize phoneNo;
@synthesize declareDate;
@synthesize remark;
@synthesize mobileList;

- (void)dealloc {
    [staffNo release];
    [fltDate release];
    [fltNo release];
    [planeNo release];
    [drinkFlag release];
    [doseFlag release];
    [drugDetail release];
    [healthyFlag release];
    [type release];
    [typeCode release];
    [count release];
    [doctorPhoneList release];
    [phoneNo release];
    [declareDate release];
    [remark release];
    [mobileList release];
    [super dealloc];
}

@end
