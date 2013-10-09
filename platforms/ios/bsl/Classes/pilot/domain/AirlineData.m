//
//  AirlineData.m
//  pilot
//
//  Created by Sencho Kong on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "AirlineData.h"

@implementation AirlineData

@synthesize arpShortCode;
@synthesize arpName;
@synthesize arpLongCode;
@synthesize latitude;
@synthesize longitude;
@synthesize locationName;
@synthesize fir;
@synthesize useful;
@synthesize ifInternat;
@synthesize elevation;
@synthesize var;
@synthesize railway;
@synthesize summertime;
@synthesize timezone;
@synthesize insrailway;
@synthesize comment;
@synthesize country;
@synthesize arpFileUrl;

-(void)dealloc{
    
     [arpShortCode release];
     [arpName release];
     [arpLongCode release];
     [latitude release];
     [longitude release];
     [locationName release];
     [fir release];
     [useful release];
     [ifInternat release];
     [elevation release];
     [var release];
     [railway release];
     [summertime release];
     [timezone release];
     [insrailway release];
     [comment release];
     [country release];
     [arpFileUrl release];
     [super dealloc];
}

@end
