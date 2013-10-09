//
//  Ebook.h
//  pilot
//
//  Created by Sencho Kong on 13-1-29.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+Repository.h"


@class Chapter;

@interface Ebook : NSManagedObject{

    
}

@property (nonatomic, retain) NSString * bookId;
@property (nonatomic, retain) NSString * bookName;
@property (nonatomic, retain) NSString * bookType;
@property (nonatomic, retain) NSString * upTime;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet    *chapters;
@property (nonatomic, retain) NSURL    * bookURL;
@property (nonatomic, retain) NSMutableArray* selections; //搜索结果




+(NSArray *)findByType:(NSString *)type;


+(NSArray *)findByBookID:(NSString *)bookId;

- (BOOL)removeEbookFromDefaultManager;


@end


@interface Ebook (CoreDataGeneratedAccessors)

- (void)addChaptersObject:(Chapter *)value;
- (void)removeChaptersObject:(Chapter *)value;
- (void)addChapters:(NSSet *)values;
- (void)removeChapters:(NSSet *)values;
@end
