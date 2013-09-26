//
//  MessageDelayHandler.m
//  cube-ios
//
//  Created by zhoujun on 13-8-27.
//
//

#import "MessageDelayHandler.h"
#import "NSFileManager+Extra.h"
#import "FMDatabase.h"
@implementation MessageDelayHandler
@synthesize queueArray;
static FMDatabase *database;
static MessageDelayHandler *instance;
+(MessageDelayHandler*)shareInstance{
    if(instance == nil)
    {
        instance = [[MessageDelayHandler alloc]init];
        
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.queueArray = [[NSMutableArray alloc]initWithCapacity:0];
        NSString *path = [[NSFileManager applicationDocumentsDirectory]path];
        database = [[FMDatabase alloc]initWithPath:[path stringByAppendingPathComponent:@"cube.sqlite"]];
        [database open];

        [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(handleQueue) userInfo:nil repeats:YES];

        
    }
    return self;
}

-(void)dealloc{
    self.queueArray=nil;
}

-(void)addToQueue:(MessageObject*)msg{
    [queueArray addObject:msg];
}
-(void)sendBroadCast:(MessageObject*)msg{
    
}

-(void)handleQueue{
    if([self.queueArray count] <1){
        return;
    }
    int pk = [self fectchLastPK];
    [database beginDeferredTransaction];
    for (MessageObject *msg in self.queueArray){
        pk++;
        NSString *sql = @"insert into ZMESSAGERECORD(Z_PK,Z_ENT,Z_OPT,ZALERT,ZSOUND,ZBADGE,ZMODULE,ZRECORDID,ZCONTENT,ZREVICETIME,ZISICONBADGE,ZSTORE,ZISMESSAGEBADGE,ZISREAD,ZWARNINGID)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        NSMutableArray *valueArray = [[NSMutableArray alloc]init];
        [valueArray addObject:[NSNumber numberWithInt:pk]];
        [valueArray addObject:[NSNumber numberWithInt:2]];
        [valueArray addObject:[NSNumber numberWithInt:1]];
        [valueArray addObject:msg.alert];
        if([msg.sound length]>0)
            [valueArray addObject:msg.sound];
        else
            [valueArray addObject:@""];

        if(msg.badge!=nil)
            [valueArray addObject:msg.badge];
        else
            [valueArray addObject:@"0"];
        
        if([msg.module length]>0)
            [valueArray addObject:msg.module];
        else
            [valueArray addObject:@""];
        
        if([msg.recordId length]>0)
            [valueArray addObject:msg.recordId];
        else
            [valueArray addObject:@""];
        if([msg.content length]>0)
            [valueArray addObject:msg.content];
        else
            [valueArray addObject:@""];
        
        if(msg.reviceTime!=nil)
            [valueArray addObject:msg.reviceTime];
        else
            [valueArray addObject:[NSDate date]];
        
        if(msg.isIconBadge!=nil)
            [valueArray addObject:msg.isIconBadge];
        else
            [valueArray addObject:@"0"];
        
        if(msg.store!=nil)
            [valueArray addObject:msg.store];
        else
            [valueArray addObject:@""];

        if(msg.isMessageBadge!=nil)
            [valueArray addObject:msg.isMessageBadge];
        else
            [valueArray addObject:@"0"];

        if(msg.isRead!=nil)
            [valueArray addObject:msg.isRead];
        else
            [valueArray addObject:@"0"];
        
        if(msg.faceBackId!=nil)
            [valueArray addObject:msg.faceBackId];
        else
            [valueArray addObject:@""];
        
        [database executeUpdate:sql withArgumentsInArray:valueArray];
    }
    [queueArray removeAllObjects];

    [database commit];
    
}
-(int)fectchLastPK
{
    if(![database open]){
        [database open];
    }
    NSString *sql = @"select max(Z_PK) from ZMESSAGERECORD";
    FMResultSet *result = [database executeQuery:sql];
    int count = 0;
    if([result next])
    {
        count= [result intForColumnIndex:0];
    }
    return count;
}


@end
