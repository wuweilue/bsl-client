//
//  PushGetMessageInfo.h
//  cube-ios
//
//  Created by 东 on 8/8/13.
//
//

#import <Foundation/Foundation.h>

@class HTTPRequest;
@interface PushGetMessageInfo : NSObject{
    NSTimer* updateTimer;
    HTTPRequest * request;
}

+(PushGetMessageInfo*)sharedInstance;

-(void)updatePushMessage;

@end
