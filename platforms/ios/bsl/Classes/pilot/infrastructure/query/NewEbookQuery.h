//
//  NewEbookQuery.h
//  pilot
//
//  Created by wuzheng on 13-3-14.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "Ebook.h"
#import "BaseQuery.h"

@interface NewEbookQuery : BaseQuery{
    NSMutableDictionary             *requestDic;
    NSMutableDictionary             *totalLengthDic;
}

@property (nonatomic, retain) NSMutableDictionary *requestDic;
@property (nonatomic, retain) NSMutableDictionary *totalLengthDic;

+ (NewEbookQuery *)sharedNewEbookQuery;

- (BOOL)checkDownloadingWithBookID:(NSString *)bookID;

- (void)disconnectDelegateWithBookID:(NSString *)bookID;

- (void)connectDelegateWithBookID:(NSString *)bookID object:(id)cell;

- (void)downLoadBookListWithType:(NSString *)bookType completion:(void (^)(NSMutableArray *))completion failed:(void (^)(NSString *))failed;

- (void)downLoadBookWithBook:(Ebook *)ebook withCell:(id)cell completion:(void (^)(Ebook *))completion failed:(void (^)(NSString *))failed;

//同步下载电子书列表
-(void)synchronousBookListWithType:(NSString *)bookType completion:(void (^)(NSMutableArray *))completion failed:(void (^)(NSString *))failed;

//暂停下载
- (void)pauseBookRequestWithBookID:(NSString *)bookID;

//取消下载
- (void)cancelBookRequestWithBookID:(NSString *)bookID;

- (NSString *)getDownloadDirectory;

//删除PDF缓存文件
-(void)delCatchFileByBookId:(NSString*)bookId;

@end
