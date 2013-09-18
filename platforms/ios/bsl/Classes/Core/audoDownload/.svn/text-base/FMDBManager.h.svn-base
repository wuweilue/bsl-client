//
//  FMDBManager.h
//  cube-ios
//
//  Created by zhoujun on 13-9-3.
//
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

#import "FMDatabaseAdditions.h"

@interface FMDBManager : NSObject
{
    FMDatabase *database;
}
@property(nonatomic,retain)FMDatabase *database;

+(FMDBManager*)getInstance;
-(BOOL)createTable:(NSString*)tableName withObject:(NSObject*)entity;

-(void)insertToTable:(NSObject*)object withTableName:(NSString*)tableName andOtherDB:(FMDatabase*)db;
-(void)batchInsertToTable:(NSArray*)objs withtableName:(NSString*)tableName;
-(void)deleteObj:(NSObject*)obj withTableName:(NSString*)tableName;


-(BOOL)recordIsExist:(NSString*)identifier withtableName:(NSString*)tableName withConditios:(NSString*)condition;
@end
