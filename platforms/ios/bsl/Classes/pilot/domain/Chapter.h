//
//  Chapter.h
//  pilot
//
//  Created by Sencho Kong on 13-1-29.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Chapter : NSManagedObject

@property (nonatomic, retain) NSString * bookId;
@property (nonatomic, retain) NSString * chapterId;
@property (nonatomic, retain) NSString * upTime;
@property (nonatomic, retain) NSString * bookName;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * bookType;
@property (nonatomic, retain) NSURL    * bookURL;
@end
