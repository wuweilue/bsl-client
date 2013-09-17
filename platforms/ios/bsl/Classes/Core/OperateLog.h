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

@property (nonatomic, strong) NSString * action;
@property (nonatomic, strong) NSString * appName;
@property (nonatomic, strong) NSString * moduleName;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * datetime;

+(NSArray*)findAllLog;
+(BOOL)deleteLog:(NSArray *)array;
+(void)recordOperateLog:(CubeModule *)module;
+(void)recordOperateLogWithIdentifier:(NSString*)identifier;
@end
