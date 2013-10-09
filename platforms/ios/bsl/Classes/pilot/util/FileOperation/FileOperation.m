//
//  FileOperation.m
//  pilot
//
//  Created by leichunfeng on 13-3-20.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "FileOperation.h"
#import "ZipArchive.h"

@implementation FileOperation

+ (void)decompressionDocument:(NSString *)zipFilePath UnzipFileTo:(NSString *)filePath {
    ZipArchive *zip = [[[ZipArchive alloc] init] autorelease];
    
    // 解压缩zip文件
    if([zip UnzipOpenFile:zipFilePath])
    {
        BOOL ret = [zip UnzipFileTo:filePath overWrite:YES];
        
        if(NO == ret)
        {
            NSLog(@"解压%@失败", zipFilePath);
        } else {
            NSLog(@"解压%@成功", zipFilePath);
            
            // 解压成功后删除原zip文件
            [self removeDocument:zipFilePath];
        }
        [zip UnzipCloseFile];
    }
}

+ (void)removeDocument:(NSString *)url {
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    BOOL result = [defaultFileManager removeItemAtPath:url error:&error];
    if (!result || error) {
        NSLog(@"删除%@失败", url);
    } else {
        NSLog(@"删除%@成功", url);
    }
}

@end
