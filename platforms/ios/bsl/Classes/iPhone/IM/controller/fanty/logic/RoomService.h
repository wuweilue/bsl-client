//
//  RoomService.h
//  cube-ios
//
//  Created by 肖昶 on 13-9-17.
//
//

#import <Foundation/Foundation.h>

@class XMPPRoom;

@interface RoomService : NSObject<NSFetchedResultsControllerDelegate>
@property (nonatomic,retain) XMPPRoom *room;
@property (nonatomic,retain) NSString *roomName;
@property (nonatomic,retain) NSString *roomID;
@property (nonatomic,copy )void (^roomDidCreateBlock)(XMPPRoom*);
@property (nonatomic,copy )void (^roomDidJoinBlock)(XMPPRoom*);
-(void)initRoomServce;
-(void)joinRoomServiceWithRoomID:(NSString*)roomID;

@end
