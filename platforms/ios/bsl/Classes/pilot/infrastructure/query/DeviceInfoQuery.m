//
//  DeviceInfoQuery.m
//  pilot
//
//  Created by chen shaomou on 8/30/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "DeviceInfoQuery.h"
#import "NSObject+propertyList.h"
#import "NSDictionary+ObjectExtensions.h"

@implementation DeviceInfoQuery

-(void)updateDeviceInfo:(DeviceInfo *)deviceInfo completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed{

    [self updateObjectWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,DEVICE_INFO] object:deviceInfo completion:^(NSData *returnData) {
        
        NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"upload device info sucess %@",result);
        
        [result release];
        
    } failed:^(NSData *returnData) {
        
        NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"upload device info failed %@",result);
        
        [result release];
    }];
}

-(void)getDeviceInfoWithDeviceId:(NSString *)deviceId completion:(void (^)(DeviceInfo *))completion failed:(void (^)(NSString *))failed{

    [self queryObjectWithURL:[NSString stringWithFormat:@"%@%@/%@",BASEURL,DEVICE_INFO,deviceId] parameters:nil completion:^(NSObject *obj) {
        
        //业务逻辑，重要，不与congtroller耦合,处理data,给出合适的返回
        
        NSLog(@"sucess %@",[(DeviceInfo *)obj email]);
        
        completion((DeviceInfo *)obj);
        
    } failed:^(NSData *returnData) {
        
        NSString *resultStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        failed(resultStr);
        [resultStr release];
        
    }];
}

- (void)checkDeviceRegister:(NSObject *)deviceInfo completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed{
    [self updateObjectWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,DEVICE_CHECK_REGISTER] object:deviceInfo completion:^(NSData *responseData) {
        NSString *resultStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        completion(resultStr);
        [resultStr release];
    } failed:^(NSData *responseData) {
        NSString *resultStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        completion(resultStr);
        [resultStr release];
    }];
}

//- (void)checkDeviceRegister:(NSObject *)deviceInfo completion:(void (^)(NSObject *))completion failed:(void (^)(NSObject *))failed{
//    [self updateObjectWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,DEVICE_CHECK_REGISTER] object:deviceInfo completion:^(NSData *responseData) {
//        NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:nil];
//        completion([dic dictionary2Object]);
//    } failed:^(NSData *responseData) {
//        NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:nil];
//        failed([dic dictionary2Object]);
//    }];
//}

//获取验证码
- (void)getVerifyCodeWithphoneNo:(NSString *)phoneNo deviceId:(NSString *)deviceId completion:(void (^)(NSObject *))completion failed:(void (^)(NSObject *))failed{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:phoneNo,deviceId, nil] forKeys:[NSArray arrayWithObjects:@"userPhone",@"deviceId", nil]];
    [self queryDataWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,DEVICE_GETVERIFCODE] parameters:parameters completion:^(NSData *responseData) {
        NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:nil];
        completion([dic dictionary2Object]);
    } failed:^(NSData *responseData) {
        NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:nil];
        completion([dic dictionary2Object]);
    }];
}

- (void)deviceRegister:(DeviceInfo *)deviceInfo completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed{
    [self updateObjectWithURL:[NSString stringWithFormat:@"%@%@",BASEURL,DEVICE_REGISTER] object:deviceInfo completion:^(NSData *responseData) {
        NSString *resultStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        completion(resultStr);
        [resultStr release];
    } failed:^(NSData *responseData) {
        NSString *resultStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        completion(resultStr);
        [resultStr release];
    }];
}

@end
