//
//  MessageDelayHandler.h
//  cube-ios
//
//  Created by zhoujun on 13-8-27.
//
//

#import <Foundation/Foundation.h>
#import "MessageObject.h"
@interface MessageDelayHandler : NSObject
@property(nonatomic,strong)NSMutableArray *queueArray;
+(MessageDelayHandler*)shareInstance;
-(void)addToQueue:(MessageObject*)msg;
-(void)sendBroadCast:(MessageObject*)msg;
-(void)handleQueue;
@end
