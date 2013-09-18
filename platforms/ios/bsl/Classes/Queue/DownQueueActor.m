//
//  DownQueueActor.m
//  cube-ios
//
//  Created by 东 on 2/5/13.
//
//

#import "DownQueueActor.h"

#define SYSTEM_REQUEST_TIMEOUT 10  //请求超时时间



@implementation DownQueueActor
@synthesize queue;

-(void)initQueue{
    //初始化队列
    queue = [[ASINetworkQueue alloc]init];
    queue.delegate = self;
    queue.queueDidFinishSelector = @selector(queueFinished:);
    queue.requestDidFinishSelector = @selector(requestFinished:);
    queue.requestDidFailSelector = @selector(requestFailed:);
    queue.requestDidStartSelector = @selector(requesStrrt:);
    queue.showAccurateProgress =YES;
    //当ASINetworkQueue中的一个request失败时，默认情况下，ASINetworkQueue会取消所有其他的request。
    [queue setShouldCancelAllRequestsOnFailure:NO];
    
    //初始化数组
    queueKkeyArray = [[NSMutableDictionary alloc]init];
}

-(void)resetQueue{
    if ([queueKkeyArray count]>0) {
        [queueKkeyArray removeAllObjects];
    }
    
    
    [self initQueue];
}

-(void)addRequest:(ASIHTTPRequest*)request requsetKey:(NSString *)key{
    if (!queue) {
        [self initQueue];
    }
    //判断队列中是否处在当前下载任务
    if(![queueKkeyArray objectForKey:key]){
        [queueKkeyArray setObject:request forKey:key];
        NSLog(@"%@  功能 ： %@",[self class],@"添加队列下载");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QUEUE_ADD_NOTIFICATION" object:nil];
        [queue addOperation:request];
        // request.downloadProgressDelegate = self;
        if ([queue isSuspended]) {
            //发送下载广播，并且开始队列下载
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QUEUE_START_NOTIFICATION" object:nil];
            NSLog(@"%@  功能 ： %@",[self class],@"队列下载开始");
            [queue go];
        }
    }
    
}


//===================================================================
//===================ASIProgressDelegate     Start===================
//===================================================================
- (void)setProgress:(float)newProgress{
    
}

//===================================================================
//===================ASIProgressDelegate     End  ===================
//===================================================================




//下载开始时
-(void)requesStrrt:(HTTPRequest *)request{
    //下载模块开始  发送下子模块开始的广播
    NSLog(@"%@  功能 ： %@",[self class],@"请求下载开始");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REQUEST_START_NOTIFICATION" object:nil];
}

//下载队列完成后 解压操作
- (void)requestFinished:(ASIHTTPRequest *)request{
    //下载模块成功  发送下子模块成功的广播
    NSLog(@"%@  功能 ： %@",[self class],@"请求下载完成");
    [self removeRequest:request];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REQUEST_FINISH_NOTIFICATION" object:nil];
}


- (void)requestFailed:(ASIHTTPRequest *)request{
    //下载模块失败   发送下子模块失败的广播
    NSLog(@"%@  功能 ： %@",[self class],@"请求下载失败");
    [self removeRequest:request];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REQUEST_FALSE_NOTIFICATION" object:nil];
}

- (void)queueFinished:(ASINetworkQueue *)queue{
    //当队列下载完成的时候  发送广播 队列下载完成
    NSLog(@"%@  功能 ： %@",[self class],@"队列下载完成");
    [queueKkeyArray removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QUEUE_FINISH_NOTIFICATION" object:nil];
}



-(void)removeRequest:(ASIHTTPRequest *)request{
    NSString* key = [self KeyFromArrayToRequse:request];
    if (key != nil) {
        [queueKkeyArray removeObjectForKey:key];
    }
}

-(NSString*)KeyFromArrayToRequse:(ASIHTTPRequest *)request{
    for (NSString* key  in [queueKkeyArray keyEnumerator]) {
        if ([queueKkeyArray objectForKey:key] == request){
            return key;
        }
    }
    
    return nil;
}

-(BOOL)isExitRequestFroKey:(NSString*)_key{
    for (NSString* key  in [queueKkeyArray keyEnumerator]) {
        if ([key isEqualToString:_key]){
            return true;
        }
    }
    return false;
}

-(void)dealloc{
    queueKkeyArray = nil;
    [queue setDelegate:nil];
    [queue cancelAllOperations];
    
}

@end
