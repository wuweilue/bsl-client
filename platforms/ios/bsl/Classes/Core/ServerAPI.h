//
//  ServerAPI.h
//  Cube-iOS
//
//  Created by Justin Yip on 2/2/13.
//
//

#import <Foundation/Foundation.h>

@interface ServerAPI : NSObject

+(NSString*)urlForAttachmentId:(NSString*)aid;
+(NSString*)urlForAppUpdate;
+(NSString*)urlForLogin;
+(NSString*)urlforUserSync;
+(NSString*)urlForSync;
+(NSString*)urlForlogout:(NSString* )sessionKey;
+(NSString*)urlForAppApnsCheckin;
//南航定制的业务同步模块
+(NSString*)urlForSyncImpc;

@end

NSURL* ServerAPI2(NSString *path, ...);