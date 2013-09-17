//
//  ChatRoomMessage.h
//  cube-ios
//
//  Created by Mr Right on 13-8-12.
//
//

#import <Foundation/Foundation.h>

@interface ChatRoomMessage : NSObject
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * flag_sended;
@property (nonatomic, retain) NSDate * sendDate;
@property (nonatomic, retain) NSNumber * flag_readed;
@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSString * sendUser;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * statue;
@property (nonatomic, retain) NSString * fileId;
@property (nonatomic,retain) NSString  *chat_roomID;

@end
