//
//  IMServerAPI.h
//  cube-ios
//
//  Created by dong on 13-9-17.
//
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@class HTTPRequest;
@class FormDataRequest;

@interface IMServerAPI : NSObject

// === === 即时聊天功能 === ===

/**
 *	@brief	收藏好友
 *
 *	@param 	user 好友信息对象
 *          _myJid 用户的JID
 *          _block 状态 statue true/false 表示操作是否成功
 */
+(FormDataRequest*)collectIMFriend:(NSString*)friendJid block:(void (^)(BOOL statue))_block
;


/**
 *	@brief	获取收藏好友
 *
 *	@param 	myUserId 用户的JID
 *          _block 状态 statue true/false 表示操作是否成功
 *                      friends 用户的收藏好友
 */
+(HTTPRequest*)getCollectIMFriends:(void (^)(BOOL statue,NSArray*friends))_block;

/**
 *	@brief	删除收藏好友
 *
 *	@param 	myUserId 	用户的JID
 *	@param 	_delUserInfo  删除收藏好友的
 *          _block 状态 statue true/false 表示操作是否成功
 */
+(HTTPRequest*)deleteCollectIMFriend:(NSString*)friendId block:(void (^)(BOOL statue))_block;

// === === 即时聊天功能 === ===



/**
 *	@brief	批量添加群成员
 *
 *	@param 	userInfoArray 	批量添加的成员数组
 *	@param 	_roomId 	添加的房间ID
 *	@param 	_roomName 	添加的房名称
 *          _block 状态 statue true/false 表示操作是否成功
 */
+(FormDataRequest*)grouptAddMembers:(NSArray *)userInfoArray roomId:(NSString *)_roomId roomName:(NSString *)_roomName addSelf:(BOOL)addSelf block:(void (^)(BOOL))_block;

/**
 *	@brief	根据房间的id获取房间的成员
 *
 *	@param 	_roomId 	房间ID
 *          _block 状态 statue true/false 表示操作是否成功
 *                      memnbers 返回该房间中所有的成员
 */
+(HTTPRequest*)grouptGetMembers:(NSString*)_roomId block:(void (^)(BOOL statue,NSArray*memnbers))_block
;


/**
 *	@brief	获取该用户的所有群主
 *
 *	@param 	userJid 用户的JID
 *          _block 状态 statue true/false 表示操作是否成功
 *                      roomArray 返回该用户的所有群组
 */
+(HTTPRequest*)grouptGetRooms:(NSString*)userJid block:(void (^)(BOOL statue,NSArray*roomArray))_block
;

/**
 *	@brief	删除群中的成员
 *
 *	@param 	userinfo 	删除成员信息
 *	@param 	_roomId 	房间ID
 *          _block 状态 statue true/false 表示操作是否成功
 */
+(HTTPRequest*)grouptDeleteMember:(NSString*)userId roomId:(NSString*)_roomId block:(void (^)(BOOL statue))_block;

/**
 *	@brief	删除房间
 *
 *	@param 	_roomId 	需要删除房间的ID
 *          _block 状态 statue true/false 表示操作是否成功
 */
+(HTTPRequest*)grouptDeleteRoom:(NSString*)_roomId block:(void (^)(BOOL statue))_block
;

/**
 *	@brief	改变房间名称
 *
 *	@param 	_roomName 	房间名称
 *	@param 	_roomId 	房间ID
 *          _block 状态 statue true/false 表示操作是否成功
 */
+(FormDataRequest*)grouptChangeRoomName:(NSString*)_roomName roomId:(NSString*)_roomId block:(void (^)(BOOL statue))_block;

@end
