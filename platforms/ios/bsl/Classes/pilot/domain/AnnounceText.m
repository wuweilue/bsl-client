//
//  AnnounceText.m
//  pilot
//
//  Created by Sencho Kong on 12-12-23.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "AnnounceText.h"

@implementation AnnounceText

@synthesize announceText;

-(void)dealloc{
    
    [announceText release];
    [super dealloc];
}
@end
