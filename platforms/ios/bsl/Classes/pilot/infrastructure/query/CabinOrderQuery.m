//
//  CabinOrderQuery.m
//  pilot
//
//  Created by wuzheng on 9/19/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "CabinOrderQuery.h"

@implementation CabinOrderQuery

- (void)queryFlightCabinOrderWithFlightTask:(Task *)flightTask completionBlock:(void (^)(CabinOrder *))completionBlock failedBlock:(void (^)(NSData *))failedBlock{
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:flightTask.flightNo,flightTask.flightDate,flightTask.depPort,flightTask.arrPort, nil] forKeys:[NSArray arrayWithObjects:@"flightNo",@"flightDate",@"depPort",@"arrPort", nil]];
    [self queryObjectWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,FLIGHT_CABINORDER] parameters:paramDic completion:^(NSObject *responseObj) {
        if ([responseObj isKindOfClass:[CabinOrder class]]) {
            CabinOrder *cabinOrder = (CabinOrder *)responseObj;
            completionBlock(cabinOrder);
        }else{
            completionBlock(nil);
        }
    } failed:^(NSData *responseData) {
        
    }];
}

@end
