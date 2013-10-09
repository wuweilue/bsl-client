//
//  FeedBack.h
//  pilot
//
//  Created by wuzheng on 10/23/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+Repository.h"

@interface FeedBack : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * flightDate;
@property (nonatomic, retain) NSString * flightNo;
@property (nonatomic, retain) NSString * opDate;
@property (nonatomic, retain) NSString * opID;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * synsign;

@end
