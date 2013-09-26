//
//  Config.h
//  Cube-iOS
//
//  Created by Justin Yip on 2/2/13.
//
//


#ifndef Cube_iOS_Config_h
#define Cube_iOS_Config_h

//服务器地址 
extern NSString* const kServerURLString;

//登陆地址
extern NSString* const kServerLoginURLString;

//是否起用推送
extern const BOOL kEnablePushNotification;

//应用的app key
extern const NSString* const kAPPKey;

//xmpp host
extern NSString* const kXMPPHost;

// xmpp group host
extern NSString* const kXMPPGroupHost;

//xmpp domain
extern NSString* const kXMPPDomin;

//推送的地址
extern NSString* const kXMPPPushHost ;

//推送的尾巴名
extern NSString* const kXMPPPushDomin;

//应用名称
extern NSString* const kXMPPPusher;

//注册设备
extern NSString* const kPushServerRegisterUrl;

//发送回执
extern NSString* const kPushServerReceiptsUrl;

//应用程序名字 可能没用了
extern NSString* const kAPPName;

//没用了
extern NSString* const kAPPName_sandbox;

//通告地址
extern NSString* const kRequestAnnouncementUrl;

//设备注册地址
extern NSString* const kDeviceRegisterUrl;

//不用了
extern NSString* const kFeedBackRequestUrl;
//不用了
extern NSString* const kFeedBackPostUrl;

//xmpp port
extern int kXMPPPort;

//图片上传地址
extern NSString* const kFileUploadUrl;

//二期获取消息地址
extern NSString* const kPushGetMessageUrl;

//群聊地址
extern NSString* const kMUCSevericeDomin;

//更新签到
extern NSString* const kUpdatePushTagsUrl;

#endif
