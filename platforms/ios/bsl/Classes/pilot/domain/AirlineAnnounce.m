//
//  AirlineAnnoun.m
//  pilot
//
//  Created by Sencho Kong on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "AirlineAnnounce.h"

@implementation AirlineAnnounce

@synthesize effectTime,queryTime,route,infoArea,alterArea,other,routeCH,infoAreaCH,alterAreaCH,otherCH, announceTexts;

-(void)dealloc{
    
    [effectTime release];
    [queryTime release];
    [route release];
    [infoArea release];
    [alterArea release];
    [other release];
    [routeCH release];
    [infoAreaCH release];
    [alterAreaCH release];
    [otherCH release];
    [announceTexts release];
    [super dealloc];
}

@end
