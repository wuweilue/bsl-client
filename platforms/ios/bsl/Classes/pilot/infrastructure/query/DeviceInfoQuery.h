//
//  DeviceInfoQuery.h
//  pilot
//
//  Created by chen shaomou on 8/30/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"
#import "DeviceInfo.h"

@interface DeviceInfoQuery : BaseQuery

-(void)updateDeviceInfo:(DeviceInfo *)deviceInfo completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed;

-(void)getDeviceInfoWithDeviceId:(NSString *)deviceId completion:(void (^)(DeviceInfo *))completion failed:(void (^)(NSString *))failed;

- (void)checkDeviceRegister:(DeviceInfo *)deviceInfo completion:(void (^)(NSString *))completion failed:(void(^)(NSString *))failed;

//- (void)checkDeviceRegister:(DeviceInfo *)deviceInfo completion:(void (^)(NSObject *))completion failed:(void(^)(NSObject *))failed;

- (void)getVerifyCodeWithphoneNo:(NSString *)phoneNo deviceId:(NSString *)deviceId completion:(void (^)(NSObject *))completion failed:(void (^)(NSObject *))failed;

- (void)deviceRegister:(DeviceInfo *)deviceInfo completion:(void (^)(NSString *))completion failed:(void(^)(NSString *))failed;

@end
