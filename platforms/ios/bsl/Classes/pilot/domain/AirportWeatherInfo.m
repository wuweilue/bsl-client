//
//  AirportWeatherInfo.m
//  pilot
//
//  Created by Sencho Kong on 12-11-14.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "AirportWeatherInfo.h"

@implementation AirportWeatherInfo

@synthesize queryTime;
@synthesize depArpCd;
@synthesize depArpFullName;
@synthesize arvArpCd;
@synthesize arvArpFullName;
@synthesize weatherInfos;

-(void)dealloc{
    
    [queryTime release];
    [depArpCd release];
    [depArpFullName release];
    [arvArpCd release];
    [arvArpFullName release];
    [weatherInfos release];
    [super dealloc];
}

@end
