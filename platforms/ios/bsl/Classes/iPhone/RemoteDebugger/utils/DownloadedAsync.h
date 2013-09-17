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

@property(nonatomic,retain) NSString* downloadUrl;
@property(nonatomic,retain) NSString* downloadPath;
@property(nonatomic,readonly) unsigned int downloadSize;
@property(nonatomic,readonly) unsigned int totalsize;
@property(nonatomic,assign) id<DownloadedAsyncDelegate> delegate;

-(void)start;
-(void)cancel;
@end
