//
//  Announcement.h
//  Cube-iOS
//
//  Created by chen shaomou on 2/5/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define ANNOUNCEMENT_DID_SAVE_NOTIFICATION @"message_record_did_save_notification"


@interface Announcement : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * activeTime;
@property (nonatomic, retain) NSString * invalidTime;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * attachment;
@property (nonatomic, retain) NSString * applicationId;
@property (nonatomic, retain) NSString * announcementId;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * modifiedAt;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSDate * reviceTime;
@property (nonatomic,retain) NSString* recordId;

+(void)requestAnnouncement:(NSString *)announcementId;

+(void)requestAnnouncement:(NSString *)announcementId withRecordId:(NSString*)recordId;

+(NSArray *)findAllOrderByReviceTime;


@end
