//
//  EbookQuery.m
//  pilot
//
//  Created by chen shaomou on 9/20/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "EbookQuery.h"
#import "Ebook.h"
#import "Chapter.h"
#import "ASIHttpRequest.h"
#import "EbookDownloadProgressDelegate.h"

#define QUEUE_CANCEL        @"cancel"
#define QUEUE_FAILED        @"failed"

@implementation EbookQuery

@synthesize queue;
@synthesize requestDictionary;
@synthesize ebook;
@synthesize chapterQueueDic;

static EbookQuery *instance;

+(EbookQuery *)shareInstance{
    if(instance == nil){
        {
            @synchronized([EbookQuery class]){
                if(instance == nil){
                    instance = [[EbookQuery alloc] init];
                    instance.queue = [ASINetworkQueue queue];
                    instance.chapterQueueDic = [NSMutableDictionary dictionary];
                    instance.requestDictionary = [NSMutableDictionary dictionary];
                }
            }
        }
    }
    return instance;
}

-(void)dealloc{
    // Cancel all requests in a queue
    [queue cancelAllOperations];
    [ebook release];
    [super dealloc];
}

- (void)queryEbookListByType:(NSString *)type completion:(void (^)(NSMutableArray *))completion failed:(void (^)(NSData *))failed{
    
    [self queryEbookListWithUrl:[NSString stringWithFormat:@"%@%@",BASEURL,EbookList] bookType:type completion:completion failed:failed];
    
}



- (void)queryEbookList:(void (^)(NSMutableArray *))completion failed:(void (^)(NSData *))failed{

    [self queryEbookListWithUrl:[NSString stringWithFormat:@"%@%@",BASEURL,EbookList] bookType:nil completion:completion failed:failed];
    
}

- (void)queryEbookListWithUrl:(NSString *)url bookType:(NSString *)bookType completion:(void (^)(NSMutableArray *))completion failed:(void (^)(NSData *))failed{

    [self queryArrayWithURL:url parameters:nil completion:^(NSArray *downloadBooks) {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSArray *currentBooks = [Ebook findAll];
        
        
        //得到所有电子书列表，更新本地电子书列表
        for(Ebook *eachDownloadBook in downloadBooks){
            
            for(Ebook *eachCurrentBook in currentBooks){
                //如果有新书，更新本地电子书列表
                if(eachCurrentBook != eachDownloadBook && [eachCurrentBook.bookId isEqualToString:eachDownloadBook.bookId]){
                    
                    NSDate *eachCurrentBookTime = [df dateFromString:eachCurrentBook.upTime];
                    
                    NSDate *eachDownloadBookTime = [df dateFromString:eachDownloadBook.upTime];
                    
                    //比较电子书更新时间，如果比现在的时间新就删除现有的
                    if([eachDownloadBookTime compare:eachCurrentBookTime] == NSOrderedDescending){
                        
                        [eachCurrentBook remove];
                        
                        [eachDownloadBook save];
                        
                    }else{
                        
                        [eachDownloadBook remove];
                    }
                    
                    break;
                }
            }
        }
        
        //重新取最新的本地电子书列表，创建返回列表
        currentBooks = [Ebook findAll];
        
        NSMutableArray *returnBooks = [NSMutableArray array];
        
      /*  2012 03 01 edit by Sencho Kong 
          需求变更，要显示已下载和未下载的电子书，约定电子书有url值时为已下载
          注释部分为原始代码
       
        for(Ebook *eachBook in currentBooks){
            //筛选出未下载的书，约定电子书有url值时为已下载
            if(!eachBook.url){
                //筛选出同类型的电子书
                if(bookType && [bookType isEqualToString:eachBook.bookType])
                    [returnBooks addObject:eachBook];
            }
        }
       */
        
        for(Ebook *eachBook in currentBooks){
            //筛选出未下载的书，约定电子书有url值时为已下载
           
                //筛选出同类型的电子书
                if(bookType && [bookType isEqualToString:eachBook.bookType])
                    [returnBooks addObject:eachBook];
            
        }

        
        [df release];
        
        completion(returnBooks);
        
    } failed:^(NSData *failedData) {
        
        failed(failedData);
        
    }];
}

- (BOOL)isBookDownloading:(Ebook *)book{

    NSArray *allBookId = [[self requestDictionary] allKeys];
    for(NSString *eachBookId in allBookId){
//        if([eachBookId isEqualToString:book.bookId]){
//            return TRUE;
//        }
        
        if([eachBookId hasPrefix:[book.bookId substringToIndex:book.bookId.length -2]]){
            return TRUE;
        }
    }
    
    return FALSE;
}

- (void)setEbookDownloadDelegate:(Ebook *)book downloadProgressDelegate:(id)downloadProgressDelegate{
    if([self isBookDownloading:book]){
        ASIHTTPRequest *request = [[self requestDictionary] objectForKey:book.bookId];
        [request setDownloadProgressDelegate:downloadProgressDelegate];
    }
}

- (ASIHTTPRequest *)requestWithEbook:(id)aEbook downloadProgressDelegate:(id)downloadProgressDelegate completion:(void (^)(Ebook *))completion failed:(void (^)(Ebook *))failed {
    
    NSString* bookId;
    NSURL* url;
    if ([aEbook isKindOfClass:[Ebook class]]) {
        bookId=[(Ebook*)aEbook bookId];
        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BASEURL,Ebook_URL,bookId]];
        
    }else{
        bookId=[(Chapter*)aEbook chapterId];
        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BASEURL,Ebook_Chapter_URL,bookId]];
    }
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@.%@",[self getDownloadDirectory], bookId,@"pdf"]];
    
    [request setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@/%@.%@.%@",[self getDownloadDirectory],bookId,@"pdf",@"download"]];
    
    [request setAllowResumeForFileDownloads:YES];
    
    [request setAllowCompressedResponse:NO];
    
	[request buildRequestHeaders];
    
    [request setDownloadProgressDelegate:downloadProgressDelegate];
    
    [requestDictionary setValue:request forKey:bookId];
    
    
    
    [request setCompletionBlock:^{
        
        [aEbook setUrl: [NSString stringWithFormat:@"%@/%@.%@",[self getDownloadDirectory],bookId,@"pdf"]];
        //wood
//        [aEbook save];
        
        if ([aEbook isKindOfClass:[Ebook class]]) {
            [aEbook save];
        }
        
        [requestDictionary removeObjectForKey:bookId];
        
        completion(aEbook);
    }];
    
    [request setFailedBlock:^{
        //
        
        id<EbookDownloadProgressDelegate> delegate = (id<EbookDownloadProgressDelegate> )[request downloadProgressDelegate];
        
        if([request isCancelled]){
            [delegate downloadCancel];
            
        }else{
            
//            [self removeEBook:aEbook];
            [delegate downloadFailed];
        }
        
        [requestDictionary removeObjectForKey:bookId];
        
        failed(aEbook);
    }];
    return request;
}

- (void)downloadEbook:(Ebook *)aEbook downloadProgressDelegate:(id)downloadProgressDelegate completion:(void (^)(Ebook *))completion failed:(void (^)(Ebook *))failed{

    
    self.ebook=aEbook;
//    if (aEbook.chapters.count>0) {//电子书多章节下载
    if (false) {//电子书多章节下载
    
        for (id chapter in aEbook.chapters) {

            ASIHTTPRequest *request = [self requestWithEbook:chapter downloadProgressDelegate:nil completion:completion failed:failed];


            [queue addOperation:request];

        }
        [queue setQueueDidFinishSelector:@selector(downloadQueueDidFinish:)];
        [queue setDelegate:self];
        [queue setDownloadProgressDelegate:downloadProgressDelegate];
        [queue go];
        
        
        ASINetworkQueue *chapterQueue = [[ASINetworkQueue alloc] init];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:ebook forKey:@"bookInfo"];
        for (id chapter in aEbook.chapters) {
            ASIHTTPRequest *request = [self requestWithEbook:chapter downloadProgressDelegate:nil completion:completion failed:failed];
            [request setUserInfo:userInfo];
            [chapterQueue addOperation:request];
        }

        [chapterQueue setUserInfo:userInfo];
        [chapterQueue setQueueDidFinishSelector:@selector(downloadQueueDidFinish:)];
        [chapterQueue setRequestDidFailSelector:@selector(downloadQueueDidFailed:)];
        [chapterQueue setDelegate:self];
        [chapterQueue setDownloadProgressDelegate:downloadProgressDelegate];
        [chapterQueue go];

        [chapterQueueDic setObject:chapterQueue forKey:ebook.bookId];
    }else{
        //单章节电子书下载
    
        ASIHTTPRequest *request = [self requestWithEbook:aEbook downloadProgressDelegate:downloadProgressDelegate completion:completion failed:failed];
        [queue addOperation:request];
        [queue go];
    }

}

-(void)downloadQueueDidFinish:(id)sender{
    
//    self.ebook.url = [NSString stringWithFormat:@"%@/%@.%@",[self getDownloadDirectory],[self.ebook bookId],@"pdf"];
//    
//    [self.ebook save];
    
    ASINetworkQueue *aQueue = (ASINetworkQueue *)sender;
    
    NSDictionary *userInfo = [aQueue userInfo];

    Ebook *book = [userInfo objectForKey:@"bookInfo"];
    
    NSString *flag = [userInfo objectForKey:book.bookId];
    
    NSLog(@"-----------flag:     %@  ",flag);
    
    if (![QUEUE_CANCEL isEqualToString:flag] && ![QUEUE_FAILED isEqualToString:flag]) {
        book.url = [NSString stringWithFormat:@"%@/%@.%@",[self getDownloadDirectory],book.bookId,@"pdf"];
        NSArray *array = [Ebook findByBookID:book.bookId];
        
        if (array == nil || [array count] == 0) {
            [book save];
        }
    }
}

-(void)downloadQueueDidFailed:(id)sender{
    
    ASIHTTPRequest *re = (ASIHTTPRequest *)sender;
    
    Ebook *book = [[re userInfo] objectForKey:@"bookInfo"];
    
    ASINetworkQueue *aQueue = [chapterQueueDic objectForKey:book.bookId];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[re userInfo]];
    [dic setValue:QUEUE_FAILED forKey:book.bookId];
    [aQueue setUserInfo:dic];
    [chapterQueueDic setObject:aQueue forKey:book.bookId];
}

- (void)downloadEbook:(Ebook *)aEbook completion:(void (^)(Ebook *))completion failed:(void (^)(Ebook *))failed{

    [self downloadEbook:aEbook downloadProgressDelegate:nil completion:(void (^)(Ebook *))completion failed:(void (^)(Ebook *))failed];

}

- (void)cancelDownloadEbook:(Ebook *)aEbook{

//    ASIHTTPRequest *request = [requestDictionary objectForKey:aEbook.bookId];
//    [requestDictionary removeObjectForKey:aEbook.bookId];
//    [request cancel];
    
    
    
    
//    if ([aEbook.chapters count] > 0) {
    if (false) {
        for (ASINetworkQueue *aQueue in [chapterQueueDic allValues]) {
            NSDictionary *userInfo = [aQueue userInfo];
            Ebook *book = [userInfo objectForKey:@"bookInfo"];
            if ([book.bookId isEqualToString:aEbook.bookId]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
                [dic setValue:QUEUE_CANCEL forKey:aEbook.bookId];
                [aQueue setUserInfo:dic];
                [aQueue cancelAllOperations];
            }
        }
    }else{
        ASIHTTPRequest *request = [requestDictionary objectForKey:aEbook.bookId];
        [requestDictionary removeObjectForKey:aEbook.bookId];
        [request cancel];
    }
}

-(NSString *)getDownloadDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *downloadURL = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:@"download" isDirectory:YES];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:[downloadURL path] isDirectory:&isDir]) {
        NSLog(@"目录:%@ 不存在！",[downloadURL path]);
        NSError *err;
        if(![fileManager createDirectoryAtPath:[downloadURL path] withIntermediateDirectories:YES attributes:nil error:&err])
        {
            NSLog(@"%@",err);
        }
    }
    return [downloadURL path];
}

- (void)cancelAllDownload{
    [queue cancelAllOperations];
    
    for (ASINetworkQueue *aQueue in [chapterQueueDic allValues]) {
        NSDictionary *userInfo = [aQueue userInfo];
        Ebook *book = [userInfo objectForKey:@"bookInfo"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [dic setValue:@"cancel" forKey:book.bookId];
        [aQueue setUserInfo:dic];
        [aQueue cancelAllOperations];
    }
}

- (void)removeEBook:(Ebook *)abook{
    
    NSError *error = nil;
    NSArray *array = [Ebook findByBookID:abook.bookId];
    if (array && [array count] > 0) {
        Ebook *book = [array objectAtIndex:0];
//        if ([[book chapters] count] > 0) {
        if (false) {
            for (Chapter *chapter in book.chapters) {
                [[NSFileManager defaultManager] removeItemAtPath:chapter.url error:&error];
            }
        }else{
            [[NSFileManager defaultManager] removeItemAtPath:abook.url error:&error];
        }
        [book remove];
    }
}

@end
