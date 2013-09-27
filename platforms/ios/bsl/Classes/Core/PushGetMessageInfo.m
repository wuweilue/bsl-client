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
#import "HTTPRequest.h"
#import "NSManagedObject+Repository.h"

static PushGetMessageInfo* instance=nil;

@interface PushGetMessageInfo()
-(void)startTimer:(BOOL)callNow;
-(void)sendFeedBack:(NSMutableArray*)outputArrayIds;
@end

@implementation PushGetMessageInfo

+(PushGetMessageInfo*)sharedInstance{
    if(instance==nil)
        instance=[[PushGetMessageInfo alloc] init];
    return instance;
}

-(void)dealloc{
    [request cancel];
    [updateTimer invalidate];
}

-(void)startTimer:(BOOL)callNow{
    [request cancel];
    request=nil;
    [updateTimer invalidate];
    updateTimer=nil;

    if(callNow){
        [self updatePushMessage];
    }
    else{
        updateTimer=[NSTimer scheduledTimerWithTimeInterval:300.0f target:self selector:@selector(updatePushMessage) userInfo:nil repeats:NO];
    }
}

-(void)sendFeedBack:(NSMutableArray*)outputArrayIds{
    FormDataRequest *formDataRequest = [FormDataRequest requestWithURL:[NSURL URLWithString:kPushServerReceiptsUrl]];

    formDataRequest.timeOutSeconds=5.0f;
    formDataRequest.persistentConnectionTimeoutSeconds=5.0f;
//    [request setPostValue:self.faceBackId  forKey:@"sendId"];
    
    NSString * uuid = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    [formDataRequest setPostValue:uuid forKey:@"deviceId"];
    [formDataRequest setPostValue:kAPPKey forKey:@"appKey"];
    [formDataRequest setRequestMethod:@"PUT"];
    [formDataRequest startAsynchronous];
}

-(void)updatePushMessage{
    [request cancel];
    [updateTimer invalidate];
    updateTimer=nil;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [userDefaults objectForKey:@"deviceToken"];
    NSString* deviceId = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSString* requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@",kPushGetMessageUrl,token,deviceId,kAPPKey];
    
    if (token && [token length] > 0 ) {
        
        request = [HTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        __block HTTPRequest* __request=request;
        __block PushGetMessageInfo* objSelf=self;
        [request setCompletionBlock:^{

            BOOL startNow=NO;
            if (__request.responseStatusCode != 500) {
                NSData *data = [__request responseData];
                NSMutableArray * messageArray = [data objectFromJSONData];
                NSMutableArray* outputArrayIds=[[NSMutableArray alloc] init];
                //FMDB 事务
                for (NSDictionary* dictionary in messageArray) {
                    [MessageRecord createByApnsInfo:dictionary outputArrayIds:outputArrayIds];
                }
                if([outputArrayIds count]>0)
                    [objSelf sendFeedBack:outputArrayIds];
                if([MessageRecord.managedObjectContext hasChanges]){
                    [MessageRecord.managedObjectContext save:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_RECORD_DID_SAVE_NOTIFICATION object:nil];

                }

                startNow=([messageArray count]>0);
            }
            [objSelf startTimer:startNow];
        }];
        [request setFailedBlock:^{
            [objSelf startTimer:NO];
        }];
        [request startAsynchronous];
    }

}

@end
