//
//  MessageRecordManager.h
//  cube-ios
//
//  Created by chen shaomou on 4/9/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MessageRecordManager : NSObject{

    sqlite3 *database;
}

+ (MessageRecordManager *)sharedMessageRecordManager;

-(BOOL)storeJSONObject:(NSDictionary *)object module:(NSString *)module;

- (NSArray *)excuteQuery:(NSString *)sql;
@end
