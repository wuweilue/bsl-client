//
//  Chapter.m
//  pilot
//
//  Created by Sencho Kong on 13-1-29.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "Chapter.h"


@implementation Chapter

@dynamic bookId;
@dynamic chapterId;
@dynamic upTime;
@dynamic bookName;
@dynamic url;
@dynamic bookType;
@synthesize bookURL;

-(void)dealloc{
    [bookURL release];
    [super dealloc];
}

@end
