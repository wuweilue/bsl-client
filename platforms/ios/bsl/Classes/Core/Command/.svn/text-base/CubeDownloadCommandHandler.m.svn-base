
//
//  CubeDownloadCommand.m
//  Cube-iOS
//
//  Created by Justin Yip on 12/8/12.
//
//

#import "CubeDownloadCommandHandler.h"
#import "HTTPRequest.h"
#import "DownloadManager.h"
#import "NSFileManager+Extra.h"
#import "CubeApplication.h"
#define kCUBEAUDIO_PATH @"com.foss.audio"
#define kCUBEAUDIO_PLIST @"cube_Audio.plist"
#define kCUBEAUDIO_Notification @"Notification_AUDIO"
#define kCUBEEBOOK_Notification @"Notification_EBOOK"

@implementation CubeDownloadCommandHandler

-(BOOL)shouldHandleCommand:(NSString*)aCommand
{
    if (aCommand != NULL && [aCommand hasPrefix:@"download"]) {
        return YES;
    } else {
        return NO;
    }
}

-(void)execute:(NSDictionary*)params
{
    NSString *filename = [params objectForKey:@"fileName"];
    NSString *url = [params objectForKey:@"url"];
    
    //下载文件的完整路径
    NSURL *fullURL = [[NSFileManager applicationDocumentsDirectory] URLByAppendingPathComponent:filename];
    
    //下载任务
    HTTPRequest *request = [HTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.downloadDestinationPath = [fullURL absoluteString];
    [[DownloadManager instance] addOperation:request forIdentifier:url];
    [request setCompletionBlock:^{
        
    }];
}

////////
-(void)saveData:(NSMutableDictionary*)aDic
{
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:[self CubeMessagePath]])
    {
        [fm createFileAtPath:[self CubeMessagePath] contents:nil attributes:nil];
        NSArray * arr = [[NSArray alloc]initWithObjects:aDic, nil];
        [arr writeToFile:[self CubeMessagePath] atomically:YES];
        [arr release];
    }else
    {
        NSMutableArray *arry =[NSMutableArray arrayWithContentsOfFile:[self CubeMessagePath]];
        [arry addObject:aDic];
        [arry writeToFile:[self CubeMessagePath] atomically:YES];
    }
}

-(NSString*)currentTime
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *currentZone = [NSTimeZone localTimeZone];
    [df setTimeZone:currentZone];
    return [df stringFromDate:[NSDate date]];
}

- (NSString *)CubeMessagePath
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0];
    
    documentDir =[documentDir stringByAppendingPathComponent:kCUBEAUDIO_PATH];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm isReadableFileAtPath:documentDir])
    {
        [fm createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [documentDir stringByAppendingPathComponent:kCUBEAUDIO_PLIST];
}

-(void)sendTheNSNotification:(NSString*)type
{
    [[NSNotificationCenter defaultCenter]postNotificationName:type object:nil];
}

//////////

-(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type] ||[[filename pathExtension] isEqualToString:@"aac"]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}

-(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

@end
