//
//  HealthyInfo.m
//  pilot
//
//  Created by lei chunfeng on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "HealthyInfo.h"

@implementation HealthyInfo

@synthesize unHealthyCount;
@synthesize doctorPhoneList;
@synthesize serviceTime;
@synthesize healthyFlag;
@synthesize drinkFlag;
@synthesize doseFlag;
@synthesize drugDetail;
@synthesize type;
@synthesize remark;
@synthesize name;
@synthesize mobileList;

- (void)dealloc {
    [unHealthyCount release];
    [doctorPhoneList release];
    [serviceTime release];
    [healthyFlag release];
    [drinkFlag release];
    [doseFlag release];
    [drugDetail release];
    [type release];
    [remark release];
    [name release];
    [mobileList release];
    [super dealloc];
}

@end