//
//  EbookQuery.h
//  pilot
//
//  Created by chen shaomou on 9/20/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "BaseQuery.h"
#import "Ebook.h"
#import "ASIProgressDelegate.h"
#import "ASINetworkQueue.h"

@interface EbookQuery : BaseQuery{
    ASINetworkQueue *queue;
    NSMutableDictionary *requestDictionary;
    
    NSMutableArray *queueArray;
}

@property(retain,nonatomic)  ASINetworkQueue *queue;
@property(retain,nonatomic)  NSMutableDictionary *requestDictionary;
@property(retain,nonatomic)  Ebook* ebook;
@property (retain, nonatomic) NSMutableDictionary *chapterQueueDic;

+(EbookQuery *)shareInstance;

- (void)queryEbookList:(void (^)(NSMutableArray *))completion failed:(void (^)(NSData *))failed;

- (void)downloadEbook:(Ebook *)aEbook downloadProgressDelegate:(id)downloadProgressDelegate completion:(void (^)(Ebook *))completion failed:(void (^)(Ebook *))failed;

- (void)downloadEbook:(Ebook *)aEbook completion:(void (^)(Ebook *))completion failed:(void (^)(Ebook *))failed;

- (void)cancelDownloadEbook:(Ebook *)aEbook;

- (BOOL)isBookDownloading:(Ebook *)book;

- (void)setEbookDownloadDelegate:(Ebook *)book downloadProgressDelegate:(id)downloadProgressDelegate;

- (void)cancelAllDownload;

- (void)queryEbookListByType:(NSString *)type completion:(void (^)(NSMutableArray *))completion failed:(void (^)(NSData *))failed;

@end
