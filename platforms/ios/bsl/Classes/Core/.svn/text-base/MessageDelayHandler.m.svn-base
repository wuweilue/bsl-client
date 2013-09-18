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
@synthesize handlerArray;
static FMDatabase *database;
static MessageDelayHandler *instance;
+(MessageDelayHandler*)shareInstance
{
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
        queueArray = [[NSMutableArray alloc]initWithCapacity:0];
        handlerArray = [[NSMutableArray alloc]initWithCapacity:0];
        NSString *path = [[NSFileManager applicationDocumentsDirectory]path];
        database = [[FMDatabase alloc]initWithPath:[path stringByAppendingPathComponent:@"cube.sqlite"]];
        [database open];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleQueue) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//        });
        
    }
    return self;
}

-(void)addToQueue:(MessageObject*)msg
{
    [queueArray addObject:msg];
}
-(void)sendBroadCast:(MessageObject*)msg
{
    
}

-(void)handleQueue
{
    if(queueArray.count ==0)
    {
        return;
    }
    [handlerArray addObjectsFromArray:queueArray];
    [queueArray removeAllObjects];
    int pk = [self fectchLastPK];
    [database beginDeferredTransaction];
    for (MessageObject *msg in handlerArray)
    {
        pk++;
        NSString *sql = @"insert into ZMESSAGERECORD(Z_PK,Z_ENT,Z_OPT,ZALERT,ZSOUND,ZBADGE,ZMODULE,ZRECORDID,ZCONTENT,ZREVICETIME,ZISICONBADGE,ZSTORE,ZISMESSAGEBADGE,ZISREAD,ZWARNINGID)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        NSMutableArray *valueArray = [[NSMutableArray alloc]init];
        [valueArray addObject:[NSNumber numberWithInt:pk]];
        [valueArray addObject:[NSNumber numberWithInt:2]];
        [valueArray addObject:[NSNumber numberWithInt:1]];
        [valueArray addObject:msg.alert];
        [valueArray addObject:msg.sound];
        [valueArray addObject:msg.badge];
        [valueArray addObject:msg.module];
        [valueArray addObject:msg.recordId];
        [valueArray addObject:msg.content];
        [valueArray addObject:msg.reviceTime];
        [valueArray addObject:msg.isIconBadge];
        [valueArray addObject:msg.store];
        [valueArray addObject:msg.isMessageBadge];
        [valueArray addObject:msg.isRead];
        [valueArray addObject:msg.faceBackId];
        
        [database executeUpdate:sql withArgumentsInArray:valueArray];
        [valueArray release];
    }
    [database commit];
    
}
-(int)fectchLastPK
{
    if(![database open])
    {
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
