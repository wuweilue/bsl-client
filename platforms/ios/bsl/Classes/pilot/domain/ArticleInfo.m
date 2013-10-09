//
//  ArticleInfo.m
//  pilot
//
//  Created by lei chunfeng on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "ArticleInfo.h"

@implementation ArticleInfo

@synthesize seqID;
@synthesize typeID;
@synthesize deptID;
@synthesize baseCode;
@synthesize title;
@synthesize issuerDate;
@synthesize content;
@synthesize source;
@synthesize fdFlag;
@synthesize annexNameList;
@synthesize contentTxt;
@synthesize annexURLList;

- (void)dealloc {
    [seqID release];
    [typeID release];
    [deptID release];
    [baseCode release];
    [title release];
    [issuerDate release];
    [content release];
    [source release];
    [fdFlag release];
    [annexNameList release];
    [contentTxt release];
    [annexURLList release];
    [super dealloc];
}

@end
