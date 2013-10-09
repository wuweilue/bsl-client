//
//  BaseQuery.m
//  pilot
//
//  Created by chen shaomou on 8/24/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"
#import "ASIHttpRequest.h"
#import "ASIFormDataRequest.h"
#import "NSObject+propertyList.h"
#import "NSDictionary+ObjectExtensions.h"
#import "ASIDataDecompressor.h"
#import "NSData+DES.h"
#import "NSData+echo.h"
#import "Base64.h"

#define DES_KEY @"39ZgCUNHEW0aaRJSOMS66OVM"

@implementation BaseQuery

@synthesize request = _request;

//post

- (void)postDataWithURL:(NSString *)url data:(NSData *)data parameters:(NSDictionary *)parameters completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed{

    self.request = [self getRequestWithURL:url data:data parameters:parameters completion:^(NSData *responseData) {
        
        [responseData echo];
        
        NSError *error;
        
        NSDictionary *returnDic = (NSDictionary *)[[CJSONDeserializer deserializer] deserialize:responseData error:&error];
        
        NSObject *returnObj = [returnDic dictionary2Object];
        
        completion(returnObj);
        
    } failed:^(NSData *responseData) {
        
        failed(responseData);
        
    }];
    
    [_request setRequestMethod:HTTP_METHOD_POST];
    
    [_request startAsynchronous];
}


- (void)postObjectWithURL:(NSString *)url object:(NSObject *)anobj parameters:(NSDictionary *)parameters completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed{
    
    [self postDataWithURL:url data:[self makeObjectData:anobj] parameters:parameters completion:completion failed:failed];
}

- (void)postArrayWithURL:(NSString *)url array:(NSArray *)array parameters:(NSDictionary *)parameters completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed{
    
    [self postDataWithURL:url data:[self makeArrayData:array] parameters:parameters completion:completion failed:failed];
}


//query

- (void)queryDataWithURL:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed{
    
    self.request = [self getRequestWithURL:url data:nil parameters:parameters completion:completion failed:failed];
    
    [_request setRequestMethod:HTTP_METHOD_GET];
    
    [_request startAsynchronous];
    
}

- (void)queryArrayWithURL:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(NSArray *))completion failed:(void (^)(NSData *))failed{
    [self queryDataWithURL:url parameters:parameters completion:^(NSData *responseData) {
        NSError *error;
        NSDictionary *returnDic = [[CJSONDeserializer deserializer] deserializeAsDictionary:responseData error:&error];
        NSArray *resultArray  = [returnDic dictionary2Array];
        completion(resultArray);
    } failed:^(NSData *responseData) {
        failed(responseData);
    }];
}

- (void)queryObjectWithURL:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed{
    
    [self queryDataWithURL:url parameters:parameters completion:^(NSData *responseData) {
        
        [responseData echo];
        
        NSError *error;
        
        NSDictionary *returnDic = (NSDictionary *)[[CJSONDeserializer deserializer] deserialize:responseData error:&error];
        
        NSObject *returnObj = [returnDic dictionary2Object];
        
        completion(returnObj);
        
    } failed:^(NSData *responseData) {
        
        failed(responseData);
        
    }];
    
}

//upload

- (void)uploadWithURL:(NSString *)url data:(NSData *)data completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed{

    self.request = [self getRequestWithURL:url data:data parameters:nil completion:completion failed:failed];
    
    [_request setRequestMethod:HTTP_METHOD_POST];
    
    [_request startAsynchronous];
    
}


- (void)updateObjectWithURL:(NSString *)url object:(id)anObject completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed{
    
    [self uploadWithURL:url data:[self makeObjectData:anObject] completion:completion failed:failed];
}


- (void)updateArrayWithURL:(NSString *)url array:(NSArray *)array completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed{
    
    if([array count] < 1){
    
        return;
    }
    
    [self uploadWithURL:url data:[self makeArrayData:array] completion:completion failed:failed];
}


//private

- (NSData *)makeObjectData:(NSObject *)anObj{
    
    if(anObj == nil){
    
        return nil;
    }

    NSError *error;
    
    NSMutableDictionary *objectDict = [NSMutableDictionary dictionary];
    
    [objectDict setObject:[anObj formDictory] forKey:NSStringFromClass([anObj class])];
    
    return [[CJSONSerializer serializer] serializeObject:objectDict error:&error];
    
}

- (NSData *)makeArrayData:(NSArray *)array{
    
    if([array count] < 1){
    
        return nil;
    }
    
    NSMutableArray *dictArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for(id object in  array){
        
        [dictArray addObject:[object formDictory]];
    }
    
    NSError *error;
    
    NSMutableDictionary *arrayDict = [NSMutableDictionary dictionary];
    
    [arrayDict setObject:dictArray forKey:NSStringFromClass([[array objectAtIndex:0] class])];
    
    NSData *data = [[CJSONSerializer serializer] serializeDictionary:arrayDict error:&error];
    
    [dictArray release];
    
    return data;

}



-(ASIHTTPRequest *)getRequestWithURL:(NSString *)url data:(NSData *)data parameters:(NSDictionary *)parameters completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed{
    
    if(parameters){
        
        NSArray *allParaKeys = [parameters allKeys];
        
        NSString *parameterString = [NSString string];
        
        for(int index = 0 ;index < [allParaKeys count]; index ++){
            
            parameterString =[parameterString stringByAppendingFormat:@"%@=%@",[allParaKeys objectAtIndex:index],[parameters valueForKey:[allParaKeys objectAtIndex:index]]];
            
            if(index + 1 < [allParaKeys count]){
                
                parameterString = [parameterString stringByAppendingString:@"&"];
            }
            
        }
        
        NSData *encryptData = [[parameterString dataUsingEncoding:NSUTF8StringEncoding] doEncryptWithKey:DES_KEY];
        
        NSData *base64Data = [Base64 encodeData:encryptData];
        
        NSString *encryptString = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
        
        url = [url stringByAppendingFormat:@"?%@",encryptString];
        
        [encryptString release];
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [MBProgressController getCurrentController].delegate = self;
    
    if(data != nil){
        
        //这里设置使用GZIP压缩
        request.shouldCompressRequestBody = YES;
        
        NSData *encryptData = [data doEncryptWithKey:DES_KEY];
        
        [encryptData echo];
        
        [request appendPostData:encryptData];
    }
    
    //设置超时时间
    [request setTimeOutSeconds:600];
    
    [request setCompletionBlock:^{
        
        //下载下来是数据采用GZIP解压
        //If the response headers contain a Content-Encoding header that specifies the data is compressed, calls to responseData or responseString will uncompress the data before returning it.
        //通过设定返回response的http头,可以自动返回解压值
        NSData *cipherData = [ASIDataDecompressor uncompressData:[request rawResponseData] error:NULL];
        
        [cipherData echo];
        
        NSData *plainData = [cipherData doDecryptWithKey:DES_KEY];
        
        [plainData echo];
        
        int code = [request responseStatusCode];
        
        if( code / 2 >= 200){
            //业务错误返回形式{"error":"message"}
            
            failed(plainData);
            
        }else{
            NSString *responsedString = [[[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding]autorelease];
            
            if (responsedString && [responsedString hasPrefix:@"{\"error\":"]) {
                completion(nil);
            }else{
                completion(plainData);
            }
            
        }
        
    }];
    
    [request setFailedBlock:^{
        NSData *cipherData = [ASIDataDecompressor uncompressData:[request rawResponseData] error:NULL];
        
        [cipherData echo];
        
        NSData *plainData = [cipherData doDecryptWithKey:DES_KEY];
        
        failed(plainData);
        
    }];
    
    return request;
    
}

#pragma mark - MBProgressControllerDelegate

-(void)cancelTheRequest {
    [_request clearDelegatesAndCancel];
}

@end
