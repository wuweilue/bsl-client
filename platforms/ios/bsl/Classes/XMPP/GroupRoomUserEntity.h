//
//  GroupRoomUserEntity.h
//  cube-ios
//
//  Created by Mr Right on 13-8-20.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GroupRoomUserEntity : NSManagedObject

@property (nonatomic, strong) NSString * roomId;
@property (nonatomic, strong) NSString * roomName;
@property (nonatomic, strong) NSString * jid;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, strong) NSString * statue;
@property (nonatomic, strong) NSString *nickName;



@end
