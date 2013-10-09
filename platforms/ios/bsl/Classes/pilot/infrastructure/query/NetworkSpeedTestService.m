//
//  NetworkSpeedTestService.m
//  Mcs
//
//  Created by Ma Cunzhang on 12-5-23.
//  Copyright (c) 2012年 RYTong. All rights reserved.
//

#import "NetworkSpeedTestService.h"


//南航官网
//#define NetworkSpeedTestURL [NSURL URLWithString:@"http://b2c.csair.com/B2C40/common/css/css.css"]
//大约1M的文件
//#define NetworkSpeedTestURL [NSURL URLWithString:@"http://icrew.csair.com/file/fileDownload!down.action?fileId=MTA5NQ=="]
//大约200K的文件
#define NetworkSpeedTestURL [NSURL URLWithString:@"http://icrew.csair.com/file/fileDownload!down.action?fileId=MTQ4MA=="]

#define NetworkSpeedTestTimeoutSeconds 10.0f
#define NanoToSce 1000000000.0 //1秒 = 1000000000纳秒
static NetworkSpeedTestService *singleton = nil;

@implementation NetworkSpeedTestService
@synthesize delegate;
@synthesize realSpeed;
@synthesize averageSpeed;
@synthesize isTestting;
@synthesize request;
@synthesize startTime,endTime,passedTime,currentPercent;
+ (NetworkSpeedTestService*)shareNetworkSpeedTestService{
    @synchronized(self){
        if (singleton == nil) {
            singleton = [[NetworkSpeedTestService alloc] init];
        }
    }
    return singleton;
}
- (id)init{
    self = [super init];
    if (self) {
        isTestting = NO;
        realSpeed = 0.0f;
        averageSpeed = 0.0f;
//        startTestTime = 0.0f;
        totalDataLength = 0.0f;
        request = nil;
        timer = nil;
        return self;
    }
    return nil;
}
//开启网速测试服务
- (void)startNetworkSpeedTestService{
    realSpeed = 0.0f;
    averageSpeed = 0.0f;
//    startTestTime = 0.0f;
    totalDataLength = 0.0f;
    currentDataLength = 0.0f;
    //清理旧有数据
    self.startTime = [NSDate date];
    self.endTime = nil;
    self.passedTime = 0.0f;
    self.currentPercent = 0.0f;
    
    if ([request retainCount] < 2 ) {
        self.request = [ASIHTTPRequest requestWithURL:NetworkSpeedTestURL];
        [request setTimeOutSeconds:5.0];
        [request setDelegate:self];
        [request startAsynchronous];
//        startTestTime = [NSDate timeIntervalSinceReferenceDate];
        
    }
    
}
//取消测速服务
- (void)cancelNetworkSpeedTestService{
    if ([request retainCount] > 1 ) {
        [request cancel];
        [timer invalidate];
        timer = nil;
    }
    //清理数据
    self.startTime = nil;
    self.endTime = nil;
    self.passedTime = 0.0f;
    self.currentPercent = 0.0f;
}
//网速测速超时监测，无论什么情况，测速开始后默认10秒内测速必须停止
- (void)networkSpeedTestTimeoutWatcher:(NSTimer*)iTimer{
    if (([[NSDate date]timeIntervalSince1970] - [startTime timeIntervalSince1970]) > NetworkSpeedTestTimeoutSeconds) {
        if (iTimer && [iTimer isValid]) {
            [iTimer invalidate];
            if ([request retainCount] > 1) {
                [self performSelector:@selector(networkSpeedTestTimeout:) withObject:self];
            }
        }
        
    }
}
- (void)networkSpeedTestTimeout:(NetworkSpeedTestService*)sender{
    [request clearDelegatesAndCancel];// 取消请求
    isTestting = NO;
    NSTimeInterval totalTimeLegnt = [[NSDate date] timeIntervalSince1970] - [self.startTime timeIntervalSince1970];
    averageSpeed = (currentDataLength/1024) / totalTimeLegnt;
    if (delegate && [delegate respondsToSelector:@selector(networkSpeedTestTimeout:)]) {
        [delegate performSelector:@selector(networkSpeedTestFailed) withObject:self];
    }
    
}
- (void)requestStarted:(ASIHTTPRequest *)request{
    isTestting = YES;
    //当request被停止的时候，timer要被invalidate
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(networkSpeedTestTimeoutWatcher:) userInfo:nil repeats:YES];
    if (delegate && [delegate respondsToSelector:@selector(networkSpeedTestBegin)]) {
        [delegate performSelector:@selector(networkSpeedTestBegin)];
    }
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    totalDataLength = request.contentLength;
    NSLog(@"获取到文件长度%lld",totalDataLength);
    if (totalDataLength == 0) {
        totalDataLength = NSIntegerMax;//赋值为1，防止报错
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request{
    
    isTestting = NO;
    [timer invalidate];
    timer = nil;
    NSTimeInterval totalTimeLegnt = [[NSDate date]timeIntervalSince1970] - [startTime timeIntervalSince1970];
    averageSpeed = (currentDataLength/1024.0) / totalTimeLegnt;
    NSLog(@"%f %f", currentDataLength/1024.0, totalTimeLegnt);
    self.currentPercent = 1.0f;
    if (delegate && [delegate respondsToSelector:@selector(networkSpeedTestFinished:)]) {
        [delegate performSelector:@selector(networkSpeedTestFinished:) withObject:self];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"测速请求失败");
    isTestting = NO;
    if (delegate && [delegate respondsToSelector:@selector(networkSpeedTestFailed)]) {
        [delegate performSelector:@selector(networkSpeedTestFailed)];
    }
}
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    //速率 = 接收数据长度/所需时间 单位为k/s
    NSTimeInterval thisTimeInterval = [[NSDate date]timeIntervalSince1970];
    NSTimeInterval realTimeInterval = thisTimeInterval -lastTimeInterval;
    realSpeed = ([data length]/1024) / realTimeInterval;
    lastTimeInterval = thisTimeInterval;
    currentDataLength += [data length];
//    NSLog(@"当前下载长度%lld，总长度%lld",currentDataLength,totalDataLength);
    averageSpeed = realSpeed;
    self.currentPercent = 1.000*currentDataLength/totalDataLength;
    self.endTime = [NSDate date];
    self.passedTime = [endTime timeIntervalSince1970]-[startTime timeIntervalSince1970];
//    NSLog(@"当前进度%f,经过时间%f",self.currentPercent,self.passedTime);
    if (delegate && [delegate respondsToSelector:@selector(networkSpeedTestting:)]) {
        [delegate performSelector:@selector(networkSpeedTestting:) withObject:self];
    }
}
@end
