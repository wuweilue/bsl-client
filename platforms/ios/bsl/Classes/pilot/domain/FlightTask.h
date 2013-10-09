//
//  FlightTask.h
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightTask : NSObject

@property (nonatomic, retain) NSString *carrier;
@property (nonatomic, retain) NSString *fltNo;
@property (nonatomic, retain) NSString *fltDate;
@property (nonatomic, retain) NSString *origin;       //出发地
@property (nonatomic, retain) NSString *destination;  //目的地
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *serverTime;

@end
