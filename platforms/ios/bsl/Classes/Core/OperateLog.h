//
//  OperateLog.h
//  cube-ios
//
//  Created by zhoujun on 13-8-1.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+Repository.h"

@interface OperateLog : NSManagedObject

@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSString * appName;
@property (nonatomic, retain) NSString * moduleName;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * datetime;

+(NSArray*)findAllLog;
+(BOOL)deleteLog:(NSArray *)array;
+(void)recordOperateLog:(CubeModule *)module;
+(void)recordOperateLogWithIdentifier:(NSString*)identifier;
@end
