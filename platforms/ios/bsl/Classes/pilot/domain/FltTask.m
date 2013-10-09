//
//  FltTask.m
//  pilot
//
//  Created by chen shaomou on 11/8/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "FltTask.h"

@implementation FltTask

@synthesize flightNo,leaderNo,taskType,depPort,arrPort,depTime,arrTime,plane,tailNum,flightDate,members,readyFlag,readyFlagName;

-(void)setReadyFlag:(NSString *)_readyFlag{
    
    if (readyFlag) {
        [readyFlag release];
    }
    readyFlag=[_readyFlag retain];
    
   /*
    *  result = "B"    基地和始发站不一致，不需要准备
	*  result = "T"    时间不符合要求
	*  result = "C"    准备完成
	*  result = "R"    正在准备
	*  result = "N"    未准备
	*  result = "NO"   暂不需要准备
    */
    if ([_readyFlag isEqualToString:@"C"]) {
        self.readyFlagName=@"已准备";
        return;
    }
    if ([_readyFlag isEqualToString:@"R"]) {
        self.readyFlagName=@"正在准备";
        return;
    }
    if ([_readyFlag isEqualToString:@"N"]) {
        self.readyFlagName=@"未准备";
        return;
    }
    if ([_readyFlag isEqualToString:@"NO"]) {
        self.readyFlagName=@"暂不需准备";
        return;
    }
    if ([_readyFlag isEqualToString:@"B"]) {
        self.readyFlagName=@"不需要准备";
        return;
    }
    if ([_readyFlag isEqualToString:@"T"]) {
        self.readyFlagName=@"时间不符合要求";
        return;
    }
    
    
    
    
}


-(void)dealloc{
    
    [flightDate release];
    [flightNo release];
    [leaderNo release];
    [taskType release];
    [depPort release];
    [arrPort release];
    [depTime release];
    [arrTime release];
    [plane release];
    [tailNum release];
    [members release];
    [readyFlag release];
    [readyFlagName release];
    [super dealloc];
}
@end
