//
//  PushGetMessageInfo.m
//  cube-ios
//
//  Created by 东 on 8/8/13.
//
//

#import "PushGetMessageInfo.h"
#import "UIDevice+IdentifierAddition.h"
#import "JSONKit.h"
#import "MessageRecord.h"

static HTTPRequest * request=nil;

@implementation PushGetMessageInfo

+(void)getPushMessageInfo{
    
    [request cancel];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [userDefaults objectForKey:@"deviceToken"];
    NSString* deviceId = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSString* requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@",kPushGetMessageUrl,token,deviceId,kAPPKey];
    
    NSLog(@"getPushMessageInfo  url:%@",requestUrl);
    
    if (token && [token length] > 0 ) {
        
        request = [HTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        __block HTTPRequest* __request=request;
        [request setCompletionBlock:^{
            NSLog(@"获取推送信息完成");
            if (__request.responseStatusCode != 500) {
                NSData *data = [__request responseData];
                NSMutableArray * messageArray = [data objectFromJSONData];
                    //FMDB 事务
                int index=0;
                for (NSDictionary* dictionary in messageArray) {
                        [MessageRecord createByApnsInfo:dictionary];
                    if(index>50){
                        [MessageRecord save];
                    }
                }
            }
            [__request cancel];
            request=nil;

        }];
        [request setFailedBlock:^{
            [__request cancel];
            request=nil;
            NSLog(@"获取推送信息出错");
        }];
        [request startAsynchronous];
    }
}

@end
