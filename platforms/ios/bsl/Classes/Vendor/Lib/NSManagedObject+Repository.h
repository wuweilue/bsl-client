//
//  NSManagedObject+Repository.h
//  ComicHunter
//
//  Created by Justin Yip on 9/26/10.
//  Copyright 2010 TenNights.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//仓储增强
@interface NSManagedObject(Repository)

#pragma mark Class Method

+(NSManagedObjectContext*)managedObjectContext;

//新建对象
+(id)insert;

//保存
//成功返回YES，失败返回NO
+(BOOL)save;

//取出所有对象
+(NSArray *)findAll;

//快速删除所有对象
+(BOOL)deleteAll;

//查找单个实体
+(id)first:(NSString*)aPredicate, ...;

//查找实体
+(NSArray*)find:(NSString*)aPredicate, ...;

//查找单个实体
+(id)getByPredicate:(NSPredicate*)aPredicate;

//查找实体
+(NSArray*)findByPredicate:(NSPredicate*)aPredicate;
+(NSArray*)findByPredicate:(NSPredicate*)aPredicate sortDescriptors:(NSArray *)sortDescriptors;

#pragma mark instance method

//短ID，格式： p1 p12
-(NSString*)shortID;

//保存
-(BOOL)save;

//删除实体
-(void)remove;

-(void)removeNoSave;

-(NSArray*)entitiesNamed:(NSString*)name predicate:(NSPredicate*)aPredicate orders:(NSArray*)sds;

@end
