//
//  MessageRecord.h
//  Cube-iOS
//
//  Created by chen shaomou on 2/1/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+Repository.h"
#import "MessageRecordManager.h"

#define MESSAGE_RECORD_DID_SAVE_NOTIFICATION @"message_record_did_save_notification" 


@interface MessageRecord : NSManagedObject

@property (nonatomic, retain) NSString * alert;//alert 的内容
@property (nonatomic, retain) NSString * sound;//声音
@property (nonatomic, retain) NSNumber * badge;//显示个数
@property (nonatomic, copy)   NSString * module;
@property (nonatomic, retain) NSString * recordId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * reviceTime;
@property (nonatomic, retain) NSNumber *isIconBadge;
@property (nonatomic, retain) NSString *store;
@property (nonatomic, retain) NSNumber *isMessageBadge;
@property (nonatomic, retain) NSNumber *isRead;
@property (nonatomic, retain) NSString * faceBackId;

+(MessageRecord *)createByApnsInfo:(NSDictionary *)info;

+(MessageRecord *)createByJSON:(NSString *)jsonString;

+(void)createModuleBadge:(NSString *)identifier num:(int)num;

+(NSArray *)findForModuleIdentifier:(NSString *)moduleName;

+(NSArray *)findSystemRecord;

+(int)countForModuleIdentifierAtBadge:(NSString *)identifier;

+(void)dismissModuleBadge:(NSString *)identifier;

+(int)countAllAtBadge;
+(MessageRecord *) findMessageRecordByRecordId:(NSString*)recordId;
+(MessageRecord*) findMessageRecordByAnounceId:(NSString *)announceId;
@end
