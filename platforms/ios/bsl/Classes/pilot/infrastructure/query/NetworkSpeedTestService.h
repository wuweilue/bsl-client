//
//  NetworkSpeedTestService.h
//  Mcs
//
//  Created by Ma Cunzhang on 12-5-23.
//  Copyright (c) 2012年 RYTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@class NetworkSpeedTestService;
@protocol NetworkSpeedTestServiceDelegate <NSObject>

@optional
//测速开始时候被调用
- (void)networkSpeedTestBegin;
//测速时候被调用，返回实时网速
- (void)networkSpeedTestting:(NetworkSpeedTestService*)sender;
//测速结束后，返回平均速度
- (void)networkSpeedTestFinished:(NetworkSpeedTestService*)sender;
//测速失败时被调用
- (void)networkSpeedTestFailed;
//测速超时的时候被调用
- (void)networkSpeedTestTimeout:(NetworkSpeedTestService*)sender;
@end

//网速测速服务
@interface NetworkSpeedTestService : NSObject<ASIHTTPRequestDelegate>{
    id<NetworkSpeedTestServiceDelegate> delegate;
    NSTimeInterval lastTimeInterval;
    double realSpeed;                                //实时速度
    double averageSpeed;                             //平均速度
    long long totalDataLength;                          //总数据长度
    long long currentDataLength;                        //已经下载数据长度
    double startTestTime;                            //测试开始时间
    NSTimer *timer;
    ASIHTTPRequest *request;
    BOOL isTestting;                                //测速当中
}

@property(retain, nonatomic) id<NetworkSpeedTestServiceDelegate> delegate;
@property(assign, nonatomic, readonly) double realSpeed;
@property(assign, nonatomic, readonly) double averageSpeed;
@property(assign, nonatomic, readonly) BOOL isTestting;
@property(retain, nonatomic) ASIHTTPRequest *request;
@property (nonatomic,retain) NSDate* startTime;
@property (nonatomic,retain) NSDate* endTime;
@property (nonatomic,assign) double passedTime;
@property (nonatomic,assign) float currentPercent;
+ (NetworkSpeedTestService*)shareNetworkSpeedTestService;
//开启网速测试服务
- (void)startNetworkSpeedTestService;
//取消测速服务
- (void)cancelNetworkSpeedTestService;
//测速超时被调用
- (void)networkSpeedTestTimeout:(NetworkSpeedTestService*)sender;

@end
