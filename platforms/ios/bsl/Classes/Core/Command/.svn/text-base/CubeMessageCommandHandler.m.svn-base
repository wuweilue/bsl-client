//
//  CubeMessageCommandHandler.m
//  Cube-iOS
//
//  Created by Mr Right on 12-12-9.
//
//

#import "CubeMessageCommandHandler.h"
#define kCUBEMESSAGEPLIST @"CubeMessage.plist"
#define kCUBEMESSAGEDIRE_PATH @"com.foss.message"
#define kCUBEMESSAGE_Notification @"Notification_MESSAGE"

@implementation CubeMessageCommandHandler

-(BOOL)shouldHandleCommand:(NSString*)aCommand
{
    if (aCommand != NULL && [aCommand hasPrefix:@"MESSAGE"]) {
        return YES;
    } else {
        return NO;
    }
}

-(void)execute:(NSDictionary*)params
{
    
    NSString *title = [params objectForKey:@"title"];
    NSString *message = [params objectForKey:@"message"];
    BOOL isRead = YES;
    NSString *messageDate =[self currentTime];
    NSMutableDictionary *msgDic = [[NSMutableDictionary alloc]init];
    [msgDic setObject:title forKey:@"title"];
    [msgDic setObject:message forKey:@"message"];
    [msgDic setObject:[NSNumber numberWithBool:isRead] forKey:@"isRead"];
    [msgDic setObject:messageDate forKey:@"messageDate"];
    [self saveData:msgDic];
    [self sendTheNotification];
    [self showThemessage];
    [msgDic release];
    
}

-(void)saveData:(NSMutableDictionary*)aDic
{
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:[self CubeMessagePath]])
    {
        [fm createFileAtPath:[self CubeMessagePath] contents:nil attributes:nil];
        NSArray * arr = [[NSArray alloc]initWithObjects:aDic, nil];
        [arr writeToFile:[self CubeMessagePath] atomically:YES];
        [arr release];
    }else
    {
        NSMutableArray *arry =[NSMutableArray arrayWithContentsOfFile:[self CubeMessagePath]];
        [arry addObject:aDic];
        [arry writeToFile:[self CubeMessagePath] atomically:YES];
    }
}

-(NSString*)currentTime
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *currentZone = [NSTimeZone localTimeZone];
    [df setTimeZone:currentZone];
    return [df stringFromDate:[NSDate date]];
}

- (NSString *)CubeMessagePath
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0];

    documentDir =[documentDir stringByAppendingPathComponent:kCUBEMESSAGEDIRE_PATH];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm isReadableFileAtPath:documentDir])
    {
        [fm createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [documentDir stringByAppendingPathComponent:kCUBEMESSAGEPLIST];
}

-(void)sendTheNotification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kCUBEMESSAGE_Notification object:nil];
}
-(void)showThemessage
{
//     Class cls = NSClassFromString(@"MessagesViewController");
//    if (![[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:cls])
//    {
//        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"新的消息" message:@"你有一条新的消息" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [av show];
//        [av release];
//    }
    
}
@end
