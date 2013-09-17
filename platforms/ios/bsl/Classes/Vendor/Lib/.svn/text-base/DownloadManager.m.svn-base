//
//  DownloadManager.m
//  Cube-iOS
//
//  Created by Justin Yip on 12/8/12.
//
//

#import "DownloadManager.h"
#import "HTTPRequest.h"

@implementation DownloadManager
@synthesize queue;
@synthesize operationDict;

+(id)instance
{
    static DownloadManager *instance;
    @synchronized(self) {
        if (nil == instance) {
            instance = [[DownloadManager alloc] init];
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        queue = [[ASINetworkQueue alloc] init];
        queue.delegate = self;
        queue.requestDidFinishSelector = @selector(didFinish:);
        queue.requestDidFailSelector = @selector(didFail:);
        [queue go];
        operationDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    [queue cancelAllOperations];
    
	[operationDict release];
	[super dealloc];
}

- (void) didFinish:(HTTPRequest*)request
{
    NSArray *keys = [operationDict allKeysForObject:request];
    [operationDict removeObjectsForKeys:keys];
}

- (void)didFail:(HTTPRequest*)request
{
    NSArray *keys = [operationDict allKeysForObject:request];
    [operationDict removeObjectsForKeys:keys];
}

- (void) addOperation:(NSOperation*)op forIdentifier:(id)aID
{
    if(!aID)
        return;
	[operationDict setObject:op forKey:aID];
	
	[queue addOperation:op];
}

- (void) cancelOperation:(id)aID {
	NSOperation * op = [operationDict objectForKey:aID];
	[op cancel];
	[operationDict removeObjectForKey:aID];
}

- (void)addRequest:(HTTPRequest*)request forKey:(id)aID {
    [self addRequest:request forKey:aID strategy:ExecuteTaskReplaceExists];
}

- (void)addRequest:(HTTPRequest*)request forKey:(id)aID strategy:(TaskExecutionStrategy)strategy {
    
    switch (strategy) {
        case ExecuteTaskReplaceExists:
            //取消现有的
            [self cancelRequestForKey:aID];
            //添加
            [operationDict setObject:request forKey:aID];
            [queue addOperation:request];
            
            break;
        case ExecuteTaskIfNotExists:
            if (![operationDict objectForKey:aID]) {
                //添加
                [operationDict setObject:request forKey:aID];
                [queue addOperation:request];
            } else {
                NSLog(@"task [%@] already exists", aID);
            }
            break;
    }
}

- (void)cancelRequestForKey:(id)aID {
    id op = [operationDict objectForKey:aID];
    if (!op) return;
    HTTPRequest *request = (HTTPRequest *)op;
	[request clearDelegatesAndCancel];
	[operationDict removeObjectForKey:aID];
}

@end
