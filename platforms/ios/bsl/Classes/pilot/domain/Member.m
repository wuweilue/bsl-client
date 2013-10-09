//
//  Member.m
//  pilot
//
//  Created by Sencho Kong on 12-11-21.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "Member.h"

@implementation Member

@synthesize  empId;    //员工号
@synthesize  chnName;     //姓名
@synthesize  position; //职务
@synthesize  base;     //基地
@synthesize  image;   //图片地址
@synthesize  readyFlag;
@synthesize  birthDtT;



-(void)setReadyFlag:(NSString *)_readyFlag{
    
    if (readyFlag) {
        [readyFlag release];
    }
    
    
    
    
    if ([_readyFlag isEqualToString:@"C"]) {
        readyFlag=@"已准备";
        return;
    }
    if ([_readyFlag isEqualToString:@"R"]) {
        readyFlag=@"准备中";
         return;
    }
    if ([_readyFlag isEqualToString:@"N"]) {
        readyFlag=@"未准备";
         return;
    }
    if ([_readyFlag isEqualToString:@"NO"]) {
        readyFlag=@"暂不需准备";
        return;
    }
    if ([_readyFlag isEqualToString:@"B"]) {
        readyFlag=@"不需要准备";
        return;
    }
    if ([_readyFlag isEqualToString:@"T"]) {
        readyFlag=@"时间不符合要求";
        return;
    }

    
       
    
    readyFlag=[_readyFlag retain];
    
}

-(void)dealloc{
    [empId release];
    [chnName release];
    [position release];
    [base release];
    [image release];
    [readyFlag release];
    [birthDtT release];
    [super dealloc];
}
@end
