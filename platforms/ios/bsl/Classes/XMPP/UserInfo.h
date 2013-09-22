//
//  UserInfo.h
//  XMPPIM
//
//  Created by 东 on 13-2-27.
//  Copyright (c) 2013年 imohoo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class MessageEntity;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString *userGroup;
@property (nonatomic, retain) NSString *userJid;
@property (nonatomic, retain) NSString *userStatue;
@property (nonatomic, retain) NSString *userSubscription;
@property (nonatomic, retain) NSString *userMessageCount;
@property (nonatomic, retain) NSString *userLastMessage;
@property (nonatomic, retain) NSString *userSex;
@property (nonatomic, retain) NSDate * userLastDate;
@property (nonatomic, retain) NSNumber * isCollected;


-(NSString*)name;

@end

