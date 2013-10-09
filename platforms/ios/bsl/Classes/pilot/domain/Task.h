//
//  Task.h
//  pilot
//
//  Created by wuzheng on 13-7-12.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject{
    NSString        *actingRank;
	NSString        *alnCd;
	NSString        *arrPort;
	NSString        *arrPortName;
	NSString        *arrTime;
	NSString        *depPort;
	NSString        *depPortName;
	NSString        *depTime;
	NSString        *flightDate;
	NSString        *flightNo;
	NSString        *name;
	NSString        *plane;
	NSString        *planeId;
	NSString        *schFlightDate;
	NSString        *taskType;
}

@property (nonatomic, retain) NSString *actingRank;
@property (nonatomic, retain) NSString *alnCd;
@property (nonatomic, retain) NSString *arrPort;
@property (nonatomic, retain) NSString *arrPortName;
@property (nonatomic, retain) NSString *arrTime;
@property (nonatomic, retain) NSString *depPort;
@property (nonatomic, retain) NSString *depPortName;
@property (nonatomic, retain) NSString *depTime;
@property (nonatomic, retain) NSString *flightDate;
@property (nonatomic, retain) NSString *flightNo;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *plane;
@property (nonatomic, retain) NSString *planeId;
@property (nonatomic, retain) NSString *schFlightDate;
@property (nonatomic, retain) NSString *taskType;


@end
