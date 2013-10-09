//
//  FileQuery.m
//  pilot
//
//  Created by chen shaomou on 11/5/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "FileQuery.h"
#import "ASIHTTPRequest.h"
#import "ASIDataDecompressor.h"
#import "NSData+DES.h"
#import "NetworkConfig.h"
#import "Base64.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"


#define DES_KEY @"39ZgCUNHEW0aaRJSOMS66OVM"

@interface FileQuery (){
  
    __block ASIFormDataRequest *request;
}

@end

@implementation FileQuery

-(void)dealloc{
     [super dealloc];
}

-(void)queryWeatherMapNameListWithremotePath:(NSString *)remotePath andType:(NSString *)type andArea:(NSString *)area completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASEURL,WEATHERMAP_LIST];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:remotePath,type,area,nil] forKeys:[NSArray arrayWithObjects:@"remotePath",@"type",@"area",nil]];
    [self queryDataWithURL:url parameters:paramDic completion:^(NSData *responseData) {
        
        if(responseData){
            NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            completion(result);
        }else{
            failed(nil);
        }
    } failed:^(NSData *responseData) {
        NSLog(@"------list   failed");
        failed(nil);
    }];
}

-(NSString *)getDownloadDirectoryWithCategory:(NSString *)category{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *downloadURL = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"tempFile/%@",category] isDirectory:YES];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:[downloadURL path] isDirectory:&isDir]) {
        NSLog(@"目录%@不存在！",[downloadURL path]);
        NSError *err;
        if(![fileManager createDirectoryAtPath:[downloadURL path] withIntermediateDirectories:YES attributes:nil error:&err])
        {
            NSLog(@"%@",err);
        }
    }
    return [downloadURL path];
}

-(NSString *)getTowFileDirectoryWithCategory:(NSString *)planeType{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *downloadURL = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"tempFile/%@",planeType] isDirectory:YES];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:[downloadURL path] isDirectory:&isDir]) {
        NSLog(@"目录%@不存在！",[downloadURL path]);
        NSError *err;
        if(![fileManager createDirectoryAtPath:[downloadURL path] withIntermediateDirectories:YES attributes:nil error:&err])
        {
            NSLog(@"%@",err);
        }
    }
    return [downloadURL path];
}

//飞行准备中文件下载
- (void)downloadFileWithRemotePath:(NSString *)remotePath AndFileName:(NSString *)fileName AndFileType:(NSString *)fileType inTimeFlag:(NSString *)inTimeFlag completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed{
    
    NSString *localPath = [NSString stringWithFormat:@"%@/%@",[self getDownloadDirectoryWithCategory:fileType],fileName];
    
    //非时时文件，本地缓存
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath] && [@"N" isEqualToString:inTimeFlag]) {
        completion(localPath);
    }else{
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:remotePath,fileName,inTimeFlag,nil] forKeys:[NSArray arrayWithObjects:@"remoteFilePath",@"fileName",@"inTimeFlag",nil]];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,FTPFile_URL];
        
        [self downloadFileWithURL:urlStr param:parameters localPath:localPath completion:^(NSString *path) {
            completion(path);
        } failed:^(NSString *path) {
            failed(path);
        }];
    }
}

//起飞限重表文件下载
- (void)downloadTowFileWithPlaneType:(NSString *)planeType AndFileName:(NSString *)fileName completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed{
    
    NSString *localPath = [NSString stringWithFormat:@"%@/%@",[self getDownloadDirectoryWithCategory:planeType],fileName];
        
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:planeType,fileName,nil] forKeys:[NSArray arrayWithObjects:@"planeType",@"fileName",nil]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,TOWFILE];
    
    [self downloadFileWithURL:urlStr param:parameters localPath:localPath completion:^(NSString *path) {
        completion(path);
    } failed:^(NSString *path) {
        failed(path);
    }];
}

//飞行计划文件下载
- (void)downloadPlanFileWithFlightNo:(NSString *)fltNr fltDt:(NSString *)fltDt arvArpCd:(NSString *)arvArpCd depArpCd:(NSString *)depArpCd completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed{
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@_%@%@",fltNr,fltDt,arvArpCd,depArpCd,@".txt"];
    
    NSString *localPath = [NSString stringWithFormat:@"%@/%@",[self getDownloadDirectoryWithCategory:@"PLAN"],fileName];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:fltNr,fltDt,arvArpCd,depArpCd,nil] forKeys:[NSArray arrayWithObjects:@"fltNr",@"fltDt",@"arvArpCd",@"depArpCd", nil]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,PLANFILE];
    
    [self downloadFileWithURL:urlStr param:parameters localPath:localPath completion:^(NSString *path) {
        completion(path);
    } failed:^(NSString *path) {
        failed(path);
    }];
}

//文件下载公共方法
- (void)downloadFileWithURL:(NSString *)urlStr param:(NSDictionary *)parameters localPath:(NSString *)localPath completion:(void(^)(NSString *))completion failed:(void(^)(NSString *))failed{
    
    if (parameters) {
        NSArray *allParaKeys = [parameters allKeys];
        
        NSString *parameterString = [NSString string];
        
        for(int index = 0 ;index < [allParaKeys count]; index ++){
            
            parameterString =[parameterString stringByAppendingFormat:@"%@=%@",[allParaKeys objectAtIndex:index],[parameters valueForKey:[allParaKeys objectAtIndex:index]]];
            
            if(index + 1 < [allParaKeys count]){
                
                parameterString = [parameterString stringByAppendingString:@"&"];
            }
        }
        urlStr = [urlStr stringByAppendingFormat:@"?%@",parameterString];
    }
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    __block ASIHTTPRequest *fileRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    
    [fileRequest setDownloadDestinationPath:localPath];
    
    [fileRequest buildRequestHeaders];
    
    fileRequest.timeOutSeconds = 120;
    
    [fileRequest setCompletionBlock:^{
        
        int code = [fileRequest responseStatusCode];
        
        if (code == 200) {            
            completion(localPath);
            
        }else{
            failed(nil);
        }
    }];
    
    [fileRequest setFailedBlock:^{
        if ([fileRequest isCancelled]) {
            failed(@"CANCEL");
        }else{
            failed(@"FAILED");
        }
    }];
    
    [fileRequest startAsynchronous];
}

-(void)cancelQuery{
    [request cancel];
}

@end
