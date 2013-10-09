//
//  CabinOrderQuery.h
//  pilot
//
//  Created by wuzheng on 9/19/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseQuery.h"
#import "CabinOrder.h"
#import "Task.h"

@interface CabinOrderQuery : BaseQuery

- (void)queryFlightCabinOrderWithFlightTask:(Task *)flightTask completionBlock:(void (^)(CabinOrder *))completionBlock failedBlock:(void (^)(NSData *))failedBlock;

@end
