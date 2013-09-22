//
//  RoomService.h
//  cube-ios
//
//  Created by 肖昶 on 13-9-17.
//
//

#import <Foundation/Foundation.h>

@class XMPPRoom;

@interface RoomService : NSObject{
    NSTimer* checkTimer;
    NSMutableArray*  rooms;

}
-(void)tearDown;
-(XMPPRoom*)findRoomByJid:(NSString*)roomId;
-(NSString*)createNewRoom;
-(void)removeNewRoom:(NSString*)roomId;
-(void)joinAllRoomService;
-(void)joinRoomServiceWithRoomID:(NSString*)roomID;

@end
