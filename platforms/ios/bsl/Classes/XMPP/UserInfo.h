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

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString *userGroup;
@property (nonatomic, strong) NSString *userJid;
@property (nonatomic, strong) NSString *userStatue;
@property (nonatomic, strong) NSString *userSubscription;
@property (nonatomic, strong) NSString *userMessageCount;
@property (nonatomic, strong) NSString *userLastMessage;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) NSDate * userLastDate;
@property (nonatomic, strong) NSNumber * isCollected;


-(NSString*)name;

@end

