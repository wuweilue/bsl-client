//
//  DeviceInfo.h
//  pilot
//
//  Created by chen shaomou on 8/30/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

@property (nonatomic) int device_ID;
@property (retain, nonatomic) NSString* deviceId;
@property (retain, nonatomic) NSString* deviceSpec;
@property (retain, nonatomic) NSString* deviceType;
@property (retain, nonatomic) NSString* appVersion;
@property (retain, nonatomic) NSString* appUpdateTime;
@property (retain, nonatomic) NSString* osVersion;
@property (retain, nonatomic) NSString* diskSizeAvailable;
@property (retain, nonatomic) NSString* diskSize;
@property (retain, nonatomic) NSString* iccid;
@property (retain, nonatomic) NSString* deviceSource;
@property (retain, nonatomic) NSString* simSerialNumber;
@property (retain, nonatomic) NSString* simPhone;
@property (retain, nonatomic) NSString* simOperatorMame;
@property (retain, nonatomic) NSString* workNo;
@property (retain, nonatomic) NSString* email;
@property (retain, nonatomic) NSString* userDeptment;
@property (retain, nonatomic) NSString* userName;
@property (retain, nonatomic) NSString* userPhone;
@property (retain, nonatomic) NSString* verifCode;
@property (retain, nonatomic) NSString* regitflag;
@property (retain, nonatomic) NSString* subject;

@end
