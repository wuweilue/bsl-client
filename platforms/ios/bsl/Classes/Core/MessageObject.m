//
//  MessageObject.m
//  cube-ios
//
//  Created by zhoujun on 13-8-27.
//
//

#import "MessageObject.h"
#import "ASIFormDataRequest.h"
#import "UIDevice+IdentifierAddition.h"
@implementation MessageObject
@synthesize alert;
@synthesize sound;
@synthesize badge;
@synthesize module;
@synthesize recordId;
@synthesize content;
@synthesize reviceTime;
@synthesize isIconBadge;
@synthesize store;
@synthesize isMessageBadge;
@synthesize isRead;
@synthesize faceBackId;


- (void)sendFeedBack{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kPushServerReceiptsUrl]];
    if (self.faceBackId) {
        [request setPostValue:self.faceBackId  forKey:@"sendId"];
    }
    
    NSString * uuid = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    [request setPostValue:uuid forKey:@"deviceId"];
    [request setPostValue:kAPPKey forKey:@"appKey"];
    [request setRequestMethod:@"PUT"];
    [request startAsynchronous];
    
}
-(void)showAlert{
    UILocalNotification * localAlert = [[UILocalNotification alloc]init];
    localAlert.alertBody = self.alert;
    localAlert.alertAction = @"确定";
    [[UIApplication sharedApplication] scheduleLocalNotification:localAlert];
}
@end
