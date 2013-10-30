//
//  DownloadedAsync.h
//  
//
//  Created by fanty on 13-8-5.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadedAsync;
@class HTTPRequest;
@class ThreadTask;
@class FileWriter;

@protocol DownloadedAsyncDelegate <NSObject>

-(void)process:(DownloadedAsync*)async now:(BOOL)now;
-(void)unzipBegin:(DownloadedAsync*)async;
-(void)finish:(DownloadedAsync*)async success:(BOOL)success;

@end

@interface DownloadedAsync : NSObject{
    ThreadTask* threadTask;
    
    HTTPRequest* httpRequest;

    FILE* fp;
}

@property(nonatomic,strong) NSString* downloadUrl;
@property(nonatomic,strong) NSString* downloadPath;
@property(nonatomic,assign) unsigned int downloadSize;
@property(nonatomic,assign) unsigned int totalsize;
@property(nonatomic,weak) id<DownloadedAsyncDelegate> delegate;

-(void)start;
-(void)cancel;
@end
