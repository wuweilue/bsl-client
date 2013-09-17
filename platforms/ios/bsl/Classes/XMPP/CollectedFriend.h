//
//  CollectedFriend.h
//  cube-ios
//
//  Created by zhoujun on 13-7-8.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CollectedFriend : NSManagedObject

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * friendId;

@end
