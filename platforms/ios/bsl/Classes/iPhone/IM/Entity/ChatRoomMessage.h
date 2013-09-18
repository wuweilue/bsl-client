//
//  ChatRoomMessage.h
//  cube-ios
//
//  Created by Mr Right on 13-8-12.
//
//

#import <Foundation/Foundation.h>

@interface ChatRoomMessage : NSObject
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * flag_sended;
@property (nonatomic, strong) NSDate * sendDate;
@property (nonatomic, strong) NSNumber * flag_readed;
@property (nonatomic, strong) NSString * receiver;
@property (nonatomic, strong) NSString * sendUser;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * statue;
@property (nonatomic, strong) NSString * fileId;
@property (nonatomic,strong) NSString  *chat_roomID;

@end
