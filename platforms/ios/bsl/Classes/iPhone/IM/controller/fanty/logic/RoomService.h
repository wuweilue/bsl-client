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
@property (nonatomic,strong) XMPPRoom *room;
@property (nonatomic,strong) NSString *roomName;
@property (nonatomic,strong) NSString *roomID;
@property (nonatomic,copy )void (^roomDidCreateBlock)(XMPPRoom* room);
@property (nonatomic,copy )void (^roomDidJoinBlock)();
-(void)initRoomServce;
-(void)joinRoomServiceWithRoomID:(NSString*)roomID;

@end
