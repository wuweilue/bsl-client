//
//  UserInfo.m
//  XMPPIM
//
//  Created by 涓 on 13-2-27.
//  Copyright (c) 2013骞� imohoo. All rights reserved.
//

#import "UserInfo.h"
#import "MessageEntity.h"

@implementation UserInfo

@dynamic userName;
@dynamic userStatue;
@dynamic userGroup;
@dynamic userJid;
@dynamic userSex;
@dynamic userSubscription;
@dynamic userLastMessage;
@dynamic userMessageCount;
@dynamic userLastDate;
@dynamic isCollected;


-(NSString*)name{
    if([self.userName length]>0){
        return self.userName;
    }
    else{
        int index=[self.userJid rangeOfString:@"@"].location;
        return [self.userJid substringToIndex:index];
    }
}


@end
