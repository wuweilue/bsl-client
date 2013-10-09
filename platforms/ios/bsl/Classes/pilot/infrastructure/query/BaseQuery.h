//
//  BaseQuery.h
//  pilot
//
//  Created by chen shaomou on 8/24/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConfig.h"
#import "NSManagedObject+Repository.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "MBProgressController.h"

#define HTTP_METHOD_GET @"GET"
#define HTTP_METHOD_POST @"POST"
#define HTTP_METHOD_DELETE @"DELETE"
#define HTTP_METHOD_PUT @"PUT"

@interface BaseQuery : NSObject <MBProgressControllerDelegate>

@property (retain, nonatomic) ASIHTTPRequest *request;

//查询方法

- (void)queryDataWithURL:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed;

- (void)queryArrayWithURL:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(NSArray *))completion failed:(void (^)(NSData *))failed;

- (void)queryObjectWithURL:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed;

- (void)updateObjectWithURL:(NSString *)url object:(id)anObject completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed;

- (void)updateArrayWithURL:(NSString *)url array:(NSArray *)array completion:(void (^)(NSData *))completion failed:(void (^)(NSData *))failed;

- (void)postDataWithURL:(NSString *)url data:(NSData *)data parameters:(NSDictionary *)parameters completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed;

- (void)postObjectWithURL:(NSString *)url object:(NSObject *)anobj parameters:(NSDictionary *)parameters completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed;

- (void)postArrayWithURL:(NSString *)url array:(NSArray *)array parameters:(NSDictionary *)parameters completion:(void (^)(NSObject *))completion failed:(void (^)(NSData *))failed;


-(void)cancelTheRequest;
@end
