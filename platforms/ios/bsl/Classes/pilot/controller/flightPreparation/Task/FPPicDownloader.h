//
//  FPPicDownloader.h
//  pilot
//
//  Created by Sencho Kong on 12-12-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileQuery.h"
#import "Member.h"
#import "ASIHTTPRequest.h"


@protocol imageDownloaderDelegate <NSObject>

- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end

@interface FPPicDownloader : NSObject<ASIHTTPRequestDelegate>


@property (nonatomic, retain) ASIHTTPRequest* request;
@property (nonatomic, retain) Member* member;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id<imageDownloaderDelegate>delegate;


- (void)cancelDownload;
- (void)startDownloadNew;
@end


