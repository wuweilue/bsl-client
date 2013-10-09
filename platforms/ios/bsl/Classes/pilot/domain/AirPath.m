//
//  AirPath.m
//  pilot
//
//  Created by Sencho Kong on 12-12-25.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "AirPath.h"

@implementation AirPath

@synthesize fileName;
@synthesize operTm;
@synthesize fltNr;
@synthesize tailNr;
@synthesize depArpCode;
@synthesize arvArpCode;
@synthesize fileType;
@synthesize depDt;



-(void)dealloc{
    [operTm release];
    [fltNr release];
    [tailNr release];
    [depArpCode release];
    [arvArpCode release];
    [fileType release];
    [depDt release];
    [fileName release];
    [super dealloc];
}
@end
