//
//  PilotTask.h
//  pilot
//
//  Created by chen shaomou on 11/8/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PilotTask : NSObject

@property(retain,nonatomic) NSString *empId;
@property(retain,nonatomic) NSString *currentTime;
@property(retain,nonatomic) NSString *totalTime;
@property(retain,nonatomic) NSArray *fltTasks;
@property(retain,nonatomic) NSArray *otherTasks;

@end
