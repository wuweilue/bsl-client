//
//  OperateLog.m
//  cube-ios
//
//  Created by zhoujun on 13-8-1.
//
//

#import "OperateLog.h"


@implementation OperateLog

@dynamic action;
@dynamic appName;
@dynamic moduleName;
@dynamic username;
@dynamic datetime;


+(NSArray*)findAllLog
{
    
    return [OperateLog findAll];
}
+(BOOL)deleteLog:(NSArray *)array
{
    for(OperateLog *log in array)
    {
        [log remove];
    }
    return YES;
}
+(void)recordOperateLog:(CubeModule *)module;
{
    NSString *identifer= module.identifier;
    [self recordOperateLogWithIdentifier:identifer];
}

+(void)recordOperateLogWithIdentifier:(NSString*)identifier
{
    NSString *identifer = [[NSBundle mainBundle]bundleIdentifier];
    NSString *userName  = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    OperateLog *log = [OperateLog insert];
    [log setAction:@"Module"];
    [log setAppName:identifer];
    [log setModuleName:identifier];
    [log setUsername:userName];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    dateformatter=nil;
    [log setDatetime:morelocationString];
    [log save];
}

@end
