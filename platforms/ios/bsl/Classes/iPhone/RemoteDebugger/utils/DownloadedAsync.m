//
//  DownloadedAsync.m
//  SVW_STAR
//
//  Created by fanty on 13-8-5.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "DownloadedAsync.h"
#import "ThreadTask.h"
#import "HTTPRequest.h"
#import "SSZipArchive.h"

@interface DownloadedAsync()<ASIProgressDelegate>

-(void)unZipOrFinish;
-(void)callHttp:(int)callIndex;
@end


@implementation DownloadedAsync
@synthesize delegate;
@synthesize downloadSize;
@synthesize totalsize;

-(void)dealloc{
    [self cancel];
}

-(void)start{
    //http 下载
    [self callHttp:0];
}

-(void)cancel{
    if(fp!=nil){
        fclose(fp);
        fp=nil;
    }
    [threadTask cancel];
    threadTask=nil;
    [httpRequest setCompletionBlock:nil];
    [httpRequest setFailedBlock:nil];
    [httpRequest cancel];
    httpRequest=nil;
    
}

-(void)writeData:(NSData*)data{
    if(fp!=nil){
        fwrite([data bytes], 1, [data length], fp);
    }

}

-(void)close{
    if(fp!=nil){
        fclose(fp);
        fp=nil;
    }
    httpRequest=nil;

}


-(void)callHttp:(int)callIndex{
    if(fp!=nil){
        fclose(fp);
        fp=nil;
    }
    NSString* filename=[self.downloadPath stringByAppendingString:@".zip"];
    
    fp=fopen([filename UTF8String], "wb");
    
    totalsize=100;
    downloadSize=0;
    
    if([self.delegate respondsToSelector:@selector(process:now:)])
        [self.delegate process:self now:YES];
    
    httpRequest=[HTTPRequest requestWithURL:[NSURL URLWithString:self.downloadUrl]];
    httpRequest.timeOutSeconds=30.0f;
    httpRequest.persistentConnectionTimeoutSeconds=15.0f;
    
    __block DownloadedAsync* async=self;
    
    [httpRequest setHeadersReceivedBlock:^(NSDictionary* header){
        async.totalsize=[[header objectForKey:@"Content-Length"] intValue];
    }];
    
    [httpRequest setDataReceivedBlock:^(NSData* data){

        [async writeData:data];
        async.downloadSize+=[data length];
        if([async.delegate respondsToSelector:@selector(process:now:)])
            [async.delegate process:async now:YES];

    }];
    
    [httpRequest setCompletionBlock:^{
        [async close];
        [async unZipOrFinish];
        
    }];
    
    [httpRequest setFailedBlock:^{
        [async close];

        if(callIndex<3){
            [async callHttp:(callIndex+1)];
        }
        else{
            if([async.delegate respondsToSelector:@selector(finish:success:)])
                [async.delegate finish:async success:NO];
        }
        
    }];
    [httpRequest startAsynchronous];
    
}

-(void)unZipOrFinish{
    
    if([self.delegate respondsToSelector:@selector(unzipBegin:)])
        [self.delegate unzipBegin:self];
    threadTask=[ThreadTask asyncStart:^{
        
        @autoreleasepool {
            NSString* zipFile=[self.downloadPath stringByAppendingString:@".zip"];
            [SSZipArchive unzipFileAtPath:zipFile toDestination:self.downloadPath];
            [[NSFileManager defaultManager] removeItemAtPath:zipFile error:nil];
        }
    } end:^{
        threadTask=nil;
        if([self.delegate respondsToSelector:@selector(finish:success:)])
            [self.delegate finish:self success:YES];
        
    }];
}



@end
