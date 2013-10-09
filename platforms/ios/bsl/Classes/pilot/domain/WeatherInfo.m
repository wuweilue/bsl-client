//
//  WeatherInfo.m
//  pilot
//
//  Created by Sencho Kong on 12-11-14.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "WeatherInfo.h"

@implementation WeatherInfo

@synthesize arpName,arpType,optTxts;


-(void)dealloc{
    [arpType release];
    [arpName release];
    [optTxts release];
    [super dealloc];

}

@end

