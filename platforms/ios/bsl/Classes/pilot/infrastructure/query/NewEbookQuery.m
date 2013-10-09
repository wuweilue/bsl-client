//
//  NewEbookQuery.m
//  pilot
//
//  Created by wuzheng on 13-3-14.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "NewEbookQuery.h"
#import "ASIHTTPRequest.h"
#import "Ebook.h"
#import "FileOperation.h"


#define BOOKTYPE_PDF                   @"pdf"
#define BOOKTYPE_ZIP                   @"zip"

@implementation NewEbookQuery
@synthesize requestDic;
@synthesize totalLengthDic;

static NewEbookQuery *sharedEbookQuery;

+ (NewEbookQuery *)sharedNewEbookQuery{
    if (sharedEbookQuery == nil) {
        @synchronized([NewEbookQuery class]){
            if (sharedEbookQuery == nil) {
                [[NewEbookQuery alloc] init];
                return sharedEbookQuery;
            }
        }
    }
    return sharedEbookQuery;
}

+ (id)alloc{
    @synchronized([NewEbookQuery class]){
        sharedEbookQuery = [super alloc];
        return sharedEbookQuery;
    }
    return nil;
}

- (id)init{
    if (self = [super init]) {
        self.requestDic = [NSMutableDictionary dictionary];
        totalLengthDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc{
    [requestDic release];
    [totalLengthDic release];
    [super dealloc];
}

//同步下载电子书列表
-(void)synchronousBookListWithType:(NSString *)bookType completion:(void (^)(NSMutableArray *))completion failed:(void (^)(NSString *))failed{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,EbookList];
    //请求服务器电子书列表
    [self queryArrayWithURL:urlStr parameters:[NSDictionary dictionaryWithObject:bookType forKey:@"bookType"] completion:^(NSArray *downloadBooks) {
        
        //以下是请求电子书列表后与本地列表同步过程
        /***************同步，把本地的列表删除，保存下载的最新列表*********
         * 约定已下载的电子书对象都有bookURL值，下载后会自动插入一个新对象并添加bookURL值，这个对象与这里同步的列表对象是两个不同的对象；
         */        
        //查出全部书列表，列表中删除已下载的对象后再从coredata后删除，剩下的就是与服务器同步的列表
        NSMutableArray *delBookArray=[NSMutableArray arrayWithArray:[Ebook find:[NSString stringWithFormat:@"url==nil AND bookType==\"%@\"",bookType]]];
        [delBookArray removeObjectsInArray:downloadBooks];
        for (Ebook *delAbook in delBookArray) {
            [delAbook remove];
        }        
        /***************比较，与本地已下载的对象作比较，返回可下载的列表*********/        
        /*
         *localBooksArray本地已下载的书列表,bookURL不为空就是已下载的书;
         *比较更新日期，如果下载列表对象的更新日期比本地的新，则把它加入到返回列表returnBooksArray中;
         */        
       
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSArray *localBooksArray=[Ebook find:[NSString stringWithFormat:@"url!=nil AND bookType==\"%@\"",bookType]];
        NSMutableArray *returnBooksArray=[NSMutableArray arrayWithArray:downloadBooks];
        
        for (Ebook *aDownLoadBook in downloadBooks) {
            for (Ebook *aLocalBook in localBooksArray) {
                
                //比较更新时间
                NSDate *aLocalBookTime = [dateFormatter dateFromString:aLocalBook.upTime];                
                NSDate *aDownLoadBookTime = [dateFormatter dateFromString:aDownLoadBook.upTime];
                if ([aLocalBook.bookId isEqualToString:aDownLoadBook.bookId]) {
                    //如果不相同加入返回列表
                    if ([aDownLoadBookTime compare:aLocalBookTime]==NSOrderedSame) {
                        [returnBooksArray removeObject:aDownLoadBook];
                        break;
                    }

                }
                             
            }
        
        }
        [dateFormatter release];
        
        [Ebook save];
        
        completion(returnBooksArray);
        
        
    } failed:^(NSData *failedData) {
        
        NSString *failedStr = [[NSString alloc] initWithData:failedData encoding:NSUTF8StringEncoding];
        
        failed([failedStr autorelease]);
        
    }];
    
    
}
   

- (ASIHTTPRequest *)requestWithEBook:(Ebook *)ebook withFileType:(NSString *)fileType withCell:(id)cell completion:(void (^)(Ebook *))completion failed:(void (^)(NSString *))failed{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@/%@",BASEURL,Ebook_URL,ebook.bookId,fileType]];
    
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    if ([BOOKTYPE_ZIP isEqualToString:fileType]) {
        
        [request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@.%@",[self getDownloadDirectory], ebook.bookId,@"zip"]];
        
        [request setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@/%@.%@.%@",[self getDownloadDirectory],ebook.bookId,@"zip",@"download"]];
    }else if([BOOKTYPE_PDF isEqualToString:fileType]){
    
        [request setDownloadDestinationPath:[NSString stringWithFormat:@"%@/%@.%@",[self getDownloadDirectory], ebook.bookId,@"pdf"]];
        
        [request setTemporaryFileDownloadPath:[NSString stringWithFormat:@"%@/%@.%@.%@",[self getDownloadDirectory],ebook.bookId,@"pdf",@"download"]];
    }
    
    [request setAllowResumeForFileDownloads:YES];
    
    [request setAllowCompressedResponse:NO];
    
	[request buildRequestHeaders];
    
    request.timeOutSeconds = 30;
    
    request.showAccurateProgress = YES;
    
    request.downloadProgressDelegate = cell;
    
    //把bookId复制一下，因为ebook对象会因为再请求同步下载列表时会被释放，导致ebook为nil
    NSString* bookId=[NSString stringWithString:ebook.bookId];
    
    [request setCompletionBlock:^{
        
        //请求头中返回的文件原本的大小，是自定义的key:"Content-Size";
        long long contentSize = [request.responseHeaders objectForKey:@"Content-Size"];
        
        //请求头中返回请求内容的大小，可能报错也会返回大于0的值
        long long contentLength = request.contentLength;
        
      
        //请求长度与文件大小相等才下载成功并保存
        if (contentSize>0 && contentLength>0 && request.responseStatusCode==200) {
            
            //这里是约定本地ebook对象有url属性值时为已下载实体书
            //复制前先查询是否有同名的书，如果有就删除
            NSArray *exitBookArray=[Ebook find:[NSString stringWithFormat:@"url!=nil AND bookId==\"%@\"",bookId]];
            
            //删除本地已存在的对象，（即已下载的对象，更新），注意：更新文件覆盖文件时必须删除pdf的缓存文件.plist，路径在Application Support下
            if (exitBookArray.count>0) {
                for (Ebook *delBook in exitBookArray) {
                    [delBook remove];
                    //删除缓存文件
                    [self delCatchFileByBookId:delBook.bookId];
                }
            }
            
            //用ebookId查出对象
            Ebook *aBook=[[Ebook findByBookID:bookId] objectAtIndex:0];
            
            NSAssert(aBook!=nil, @"ebook object is Null!");
            NSAssert(aBook.bookId!=nil, @"bookId is Null!");
            
            //复制对象
            Ebook *cloneLocalBook=(Ebook*)[Ebook clone:aBook];            
            
            //把url值写入，表示电书书已下载（约定有url值时为已下载的电子书对象）
            if ([BOOKTYPE_ZIP isEqualToString:fileType]) {
                [cloneLocalBook setUrl: [NSString stringWithFormat:@"%@/%@.%@",[self getDownloadDirectory],aBook.bookId,@"zip"]];
                [FileOperation decompressionDocument:ebook.url UnzipFileTo:[self getDownloadDirectory]];
            }else if([BOOKTYPE_PDF isEqualToString:fileType]){
                [cloneLocalBook setUrl: [NSString stringWithFormat:@"%@/%@.%@",[self getDownloadDirectory],aBook.bookId,@"pdf"]];
            }
            
            [requestDic removeObjectForKey:aBook.bookId];
            
            [cloneLocalBook save];
            
            //返回列表中的aBook对象，通知tableview控制器在表格中移除
            completion(aBook);
        }else{
            //表示文件不存在
            failed(@"FAILED");
        }
        
    }];
    [request setFailedBlock:^{
        if ([request isCancelled]) {
            failed(@"CANCEL");
        }else{
            failed(@"FAILED");
        }
    }];
    return request;
}

- (void)downLoadBookWithBook:(Ebook *)ebook withCell:(id)cell completion:(void (^)(Ebook *))completion failed:(void (^)(NSString *))failed{
    
    NSString *fileType = @"";

    if (false) {
        fileType = @"zip";
    }else {
        fileType = @"pdf";
    }
    
    if ([requestDic objectForKey:ebook.bookId]) {
        [[requestDic objectForKey:ebook.bookId] clearDelegatesAndCancel];
        [requestDic removeObjectForKey:ebook.bookId];
    }
    
    ASIHTTPRequest *bookRequest = [self requestWithEBook:ebook withFileType:fileType withCell:cell completion:completion failed:failed];
    [bookRequest startAsynchronous];
    
    [requestDic setObject:bookRequest forKey:ebook.bookId];
}

- (void)pauseBookRequestWithBookID:(NSString *)bookID{
    if ([requestDic objectForKey:bookID]) {
        [[requestDic objectForKey:bookID] clearDelegatesAndCancel];
    }
}

- (void)cancelBookRequestWithBookID:(NSString *)bookID{
    if ([requestDic objectForKey:bookID]) {
        [[requestDic objectForKey:bookID] clearDelegatesAndCancel];
        [requestDic removeObjectForKey:bookID];
    }
}

//清除下载进度代理
- (void)disconnectDelegateWithBookID:(NSString *)bookID{
    NSLog(@"-----断开连接-----%@",bookID);
    if ([requestDic objectForKey:bookID]) {
        ASIHTTPRequest *request = [requestDic objectForKey:bookID];
        [request setDownloadProgressDelegate:nil];

    }
}

//连接下载进度代理
- (void)connectDelegateWithBookID:(NSString *)bookID object:(id)cell{
    NSLog(@"-------重新连接-----%@",bookID);
    if ([requestDic objectForKey:bookID]) {
        ASIHTTPRequest *request = [requestDic objectForKey:bookID];
        [request setDownloadProgressDelegate:cell];
    }
}

- (BOOL)checkDownloadingWithBookID:(NSString *)bookID{
    if ([requestDic objectForKey:bookID]) {
        return YES;
    }else{
        return NO;
    }
}


//删pdf的缓存文件
-(void)delCatchFileByBookId:(NSString*)bookId{
   
    NSString* libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* asPath = [libPath stringByAppendingFormat:@"/Application Support/%@.plist",bookId];
    NSError *error=nil;
    [[NSFileManager defaultManager] removeItemAtPath:asPath error:&error];
    
}

- (NSString *)getDownloadDirectory{
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

@end
