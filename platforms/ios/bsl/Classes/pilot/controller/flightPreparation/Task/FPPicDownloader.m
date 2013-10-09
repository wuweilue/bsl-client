//
//  FPPicDownloader.m
//  pilot
//
//  Created by Sencho Kong on 12-12-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPPicDownloader.h"
#import "ASIFormDataRequest.h"
#import "Base64.h"
#import "NetworkConfig.h"
#import "NSData+DES.h"


@interface FPPicDownloader (){
   
    #define DES_KEY @"39ZgCUNHEW0aaRJSOMS66OVM"
    ASIHTTPRequest* request;
}

@end


@implementation FPPicDownloader

@synthesize request;
@synthesize indexPathInTableView;
@synthesize member;
@synthesize delegate;

-(void)dealloc{
    
    [request clearDelegatesAndCancel];
    [request release];
    [member release];
    [indexPathInTableView release];
    [super dealloc];
}

-(void)startDownloadNew{
    NSString *downloadFilename = [self.member.empId stringByAppendingPathExtension:@"jpg"];
    
    NSString *localPath = [NSString stringWithFormat:@"%@/%@",[self getDownloadDirectoryWithCategory:HEAD_PIC],downloadFilename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath] ) {
        
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:localPath]];
        
        if (delegate && [delegate respondsToSelector:@selector(imageDidLoad:)] && image) {
            self.member.image=image;
            [delegate imageDidLoad:self.indexPathInTableView];
            return;
        }
                
        
    }

    NSString *parameter = [NSString stringWithFormat:@"remoteFilePath=%@&fileName=%@",PHOTO_REMOTEPATH,downloadFilename];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@",BASEURL,FTPFile_URL,parameter];
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    self.request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDownloadDestinationPath:localPath];
    
    
    [request buildRequestHeaders];
    
    request.timeOutSeconds = 30;
    
    request.delegate=self;
    
    [request startAsynchronous];
    
}

//-(void)startDownload{
//    
//    
//     NSString *localPath = [NSString stringWithFormat:@"%@/%@",[self getDownloadDirectoryWithCategory:HEAD_PIC],[self.member.empId stringByAppendingPathExtension:@"jpg"]];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath] ) {
//        
//        self.member.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:localPath]];
//        
//        [delegate imageDidLoad:self.indexPathInTableView];
//        
//        return;
//    }
//    
//       
//    NSString *downloadFilename = [Base64 stringByEncodingData:[[self.member.empId stringByAppendingPathExtension:@"png"] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//     request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:FILE_DOWNLOAD_URL]];
//    
//    [request setPostValue:downloadFilename forKey:@"filename"];
//    
//    [request setPostValue:HEAD_PIC forKey:@"filepath"];
//    
//    [request setRequestMethod:@"POST"];
//    
//    request.delegate=self;
//   
//    [request startAsynchronous];
//    
//
//    
//}

-(void)cancelDownload{
    
    if (self.request) {
        [request clearDelegatesAndCancel];
    }
    
    
}

-(void)requestFinished:(ASIHTTPRequest *)arequest{
    
    NSString *localPath = [NSString stringWithFormat:@"%@/%@",[self getDownloadDirectoryWithCategory:HEAD_PIC],[self.member.empId stringByAppendingPathExtension:@"jpg"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:localPath]];
    
    if (image && arequest.responseStatusCode==200) {
        self.member.image = image;
        if (delegate && [delegate respondsToSelector:@selector(imageDidLoad:)]) {
            [delegate imageDidLoad:self.indexPathInTableView];
        }

    }else{
        [self requestFailed:arequest];
    }
    
  
    
}

-(void)requestFailed:(ASIHTTPRequest *)arequest{
    
    if (arequest.error) {
       NSLog(@"download HeadPic failed: %@" ,[arequest.error localizedDescription]); 
    }else{
       NSLog(@"下载图片失败 StatusCode: %i" ,arequest.responseStatusCode);
    }
    
    
    
    
}

-(NSString *)getDownloadDirectoryWithCategory:(NSString *)category{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *downloadURL = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"tempFile/%@",category] isDirectory:YES];
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




@end
