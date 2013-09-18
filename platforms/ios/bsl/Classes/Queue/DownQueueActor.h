//
//  DownQueueActor.h
//  cube-ios
//
//  Created by 东 on 2/5/13.
//
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"


#define REQUEST_FINISH_NOTIFICATION @"REQUEST_FINISH_NOTIFICATION"  //下载完成后通知
#define REQUEST_FALSE_NOTIFICATION @"REQUEST_FALSE_NOTIFICATION"  //下载失败后通知
#define REQUEST_START_NOTIFICATION @"REQUEST_START_NOTIFICATION"  //下载开始后通知

#define QUEUE_ADD_NOTIFICATION @"QUEUE_ADD_NOTIFICATION"  //队列添加下载通知
#define QUEUE_FINISH_NEXT_NOTIFICATION @"QUEUE_FINISH_NEXT_NOTIFICATION"  //队列完成一个下载通知
#define QUEUE_FALSE_NOTIFICATION @"QUEUE_FALSE_NOTIFICATION" //队列中一个失败通知

#define QUEUE_START_NOTIFICATION @"QUEUE_START_NOTIFICATION" //队列完成通知
#define QUEUE_FINISH_NOTIFICATION @"QUEUE_FINISH__NOTIFICATION" //队列完成通知



/*
 *
 * 下载队列列表
 *
 *
 */



@interface DownQueueActor : NSObject<ASIHTTPRequestDelegate>{
    ASINetworkQueue * queue;
    NSMutableDictionary*queueKkeyArray;
}
@property (nonatomic,strong) ASINetworkQueue * queue;

-(void)initQueue;//初始化队列

-(void)resetQueue;//重置队列

-(void)addRequest:(ASIHTTPRequest*)request requsetKey:(NSString *)key; //一个队列请求 一个key（模块id）


-(BOOL)isExitRequestFroKey:(NSString*)key;

@end
