//
//  RectangleChat.h
//  cube-ios
//
//  Created by 肖昶 on 13-9-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    RectangleChatContentTypeMessage=0,
    RectangleChatContentTypeImage,
    RectangleChatContentTypeVoice
}RectangleChatContentType;

@interface RectangleChat : NSManagedObject

@property(nonatomic,retain) NSNumber* chatId;
@property(nonatomic,retain) NSNumber* chatMemberCount;
@property(nonatomic,retain) NSString* content;
@property(nonatomic,retain) NSNumber* contentType;
@property(nonatomic,retain) NSString* createrJid;
@property(nonatomic,retain) NSString* receiverJid;
@property(nonatomic,retain) NSNumber* isGroup;
@property(nonatomic,retain) NSDate*  updateDate;
@property(nonatomic,retain) NSNumber* noReadMsgNumber;
@property(nonatomic,retain) NSString* name;


@end
