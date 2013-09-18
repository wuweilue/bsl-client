//
//  DownloadManager.h
//  Cube-iOS
//
//  Created by Justin Yip on 12/8/12.
//
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"

@class  HTTPRequest;
typedef enum {
    ExecuteTaskReplaceExists,
    ExecuteTaskIfNotExists
} TaskExecutionStrategy;

@interface DownloadManager : NSObject

@property(nonatomic,strong)NSMutableDictionary *operationDict;
@property(nonatomic,strong)ASINetworkQueue *queue;

+(id)instance;

- (void)addOperation:(NSOperation*)op forIdentifier:(id)aID;
- (void)cancelOperation:(id)aID;

- (void)addRequest:(HTTPRequest*)request forKey:(id)aID;
- (void)addRequest:(HTTPRequest*)request forKey:(id)aID strategy:(TaskExecutionStrategy)strategy;
- (void)cancelRequestForKey:(id)aID;

@end
