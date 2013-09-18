//
//  ChatLogic.h
//  cube-ios
//
//  Created by apple2310 on 13-9-7.
//
//

#import <Foundation/Foundation.h>
@class FormDataRequest;
@interface ChatLogic : NSObject{
    FormDataRequest * request;
}

-(void)sendMessage:(NSString* )content chatWithUser:(NSString*)chatWithUser name:(NSString*)name;

-(void)sendfile:(NSString* )content path:(NSString*)path chatWithUser:(NSString*)chatWithUser name:(NSString*)name;


-(void)sendVoice:(NSString* )content urlVoiceFile:(NSURL*)urlVoiceFile chatWithUser:(NSString*)chatWithUser name:(NSString*)name;


-(void)uploadImageToServer:(UIImage*)image finish:(void (^)(NSString* id,NSString* path))finish;


-(BOOL)isInFaviorContacts:(NSString*)chatWithUser;
-(void)addFaviorInContacts:(NSString*)chatWithUser;
-(void)removeFaviorInContacts:(NSString*)chatWithUser;


@end

