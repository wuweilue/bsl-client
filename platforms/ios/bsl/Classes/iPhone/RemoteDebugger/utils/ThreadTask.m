//
//  ThreadTask.m
//  
//
//  Created by fanty on 13-5-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ThreadTask.h"

@interface ThreadTask()


@property(nonatomic,copy) ThredTaskBlock startBlock;
@property(nonatomic,copy) ThredTaskBlock finishBlock;
@property(nonatomic,strong) NSThread* thread;


-(void)clear;
-(void)runBackgroundThread;
-(void)end;
@end

@implementation ThreadTask

-(id)init{
    self=[super init];
    return self;
}

+(ThreadTask*)asyncStart:(ThredTaskBlock)start end:(ThredTaskBlock)finish{
    ThreadTask* task=[[ThreadTask alloc] init];
    [task start:start end:finish];
    return task;
}


-(void)clear{
    self.thread=nil;
    self.startBlock=nil;
    self.finishBlock=nil;
    self.result=nil;
}

-(void)start:(ThredTaskBlock)start end:(ThredTaskBlock)finish{
    [self clear];
    
    self.startBlock=start ;
    self.finishBlock=finish;
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(runBackgroundThread) object:nil];
    
    [self.thread start];
}


-(void)cancel{
    skipFinish=YES;
    self.finishBlock=nil;
}

-(BOOL)isCancel{
    return skipFinish;
}

-(void)end{
    
    @autoreleasepool {
        if(!skipFinish && self.finishBlock!=nil)
            self.finishBlock();
        [self clear];

    }
    
}


-(void)runBackgroundThread{

    @autoreleasepool {
        self.startBlock();
    }
    [self performSelectorOnMainThread:@selector(end) withObject:nil waitUntilDone:NO];
}


@end
