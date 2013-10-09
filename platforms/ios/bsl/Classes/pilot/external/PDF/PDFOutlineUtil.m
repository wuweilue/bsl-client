//
//  PDFOutlineUtil.m
//  pilot
//
//  Created by wuzheng on 13-3-26.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "PDFOutlineUtil.h"
#import "NewEbookQuery.h"

static PDFOutlineUtil *sharedPDFOutlineUtil;

@implementation PDFOutlineUtil

+(PDFOutlineUtil *)sharedPDFOutlineUtil{
    if (sharedPDFOutlineUtil == nil) {
        @synchronized([PDFOutlineUtil class]){
            if (sharedPDFOutlineUtil == nil) {
                [[PDFOutlineUtil alloc] init];
                return sharedPDFOutlineUtil;
            }
        }
    }
    return sharedPDFOutlineUtil;
}

+(id)alloc{
    @synchronized([PDFOutlineUtil class]){
        sharedPDFOutlineUtil = [super alloc];
        return sharedPDFOutlineUtil;
    }
    return nil;
}

- (NSMutableArray *)getOutlinesWithBookID:(NSString *)bookID{
    CGPDFDocumentRef  thePDFDocRef = NULL;
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",[[NewEbookQuery sharedNewEbookQuery] getDownloadDirectory],bookID,@"pdf"];
    
    CFStringRef path;
    CFURLRef url;
    
    path = CFStringCreateWithCString(NULL, [filePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease(path);
    
    thePDFDocRef = CGPDFDocumentCreateWithURL(url);
    
    CFRelease(url);
    
    NSMutableArray *cataLogTitles = [NSMutableArray array];
    
    CGPDFDictionaryRef catalogDictionary = CGPDFDocumentGetCatalog(thePDFDocRef);
    
    CGPDFDictionaryRef namesDictionary = NULL;
    //获取目录总信息namesDictionary
    if (CGPDFDictionaryGetDictionary(catalogDictionary, "Outlines", &namesDictionary)) {
        
        long int myCount;
        if (CGPDFDictionaryGetInteger(namesDictionary, "Count", &myCount)) {
            NSLog(@"destinationName:%ld", myCount);
        }
        if (myCount < 20) {
            myCount = 20;
        }
        
        CGPDFDictionaryRef myDic;
        //获取第一个章节信息myDic
        if( CGPDFDictionaryGetDictionary(namesDictionary, "First", &myDic) )
        {            
            CGPDFStringRef myTitle;
            if( CGPDFDictionaryGetString(myDic, "Title", &myTitle) )
            {
                NSString *tempStr = (NSString *)CGPDFStringCopyTextString(myTitle);
                tempStr = [self getPDFNamewithoutSuffix:[tempStr autorelease]];
                
                NSLog(@"myTitle===:%@", tempStr);
                NSString *num = [self returnCatalogListNumber:myDic PDFDoc:thePDFDocRef];
                
                long int chapterCount;
                //可能有子目录但是取不到count，所以定指定最多30个一级目录
                if (CGPDFDictionaryGetInteger(myDic, "Count", &chapterCount)) {
                    NSLog(@"chapterCount:%ld", chapterCount);
                    if (chapterCount < 0) {
                        chapterCount = 0 - chapterCount;
                    }
                }else{
                    chapterCount = 30;
                }
                CGPDFDictionaryRef tempFirstDic;
                tempFirstDic = myDic;
                NSMutableArray *firstChapterArray = [NSMutableArray array];
                int i = 0;
                //循环第一个章节的子章节
                while ( i < chapterCount ) {
                    char *key = "";
                    if (i == 0) {
                        key = "First";
                        //如果当前目录没有first即没有子目录则退出循环
                        CGPDFDictionaryRef tempDic = tempFirstDic;
                        if( !CGPDFDictionaryGetDictionary( tempDic , key, &tempDic) ) {
                            break;
                        }
                    }else{
                        key = "Next";
                    }
                    
                    //获取第一个目录的子目录信息
                    if( CGPDFDictionaryGetDictionary( tempFirstDic , key, &tempFirstDic) ) {
                        CGPDFStringRef tempTitle;
                        if( CGPDFDictionaryGetString(tempFirstDic, "Title", &tempTitle) )
                        {
                            NSString *tempStr = (NSString *)CGPDFStringCopyTextString(tempTitle);
                            tempStr = [self getPDFNamewithoutSuffix:[tempStr autorelease]];
                            NSLog(@"kids    :%@", tempStr);
                            NSString *num = [self returnCatalogListNumber:tempFirstDic PDFDoc:thePDFDocRef];
                            NSDictionary *_chapterDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         tempStr, @"title",
                                                         num, @"link",
                                                         nil];
                            [firstChapterArray addObject:_chapterDic];
                        }
                    }
                    i++;
                }
                //保存第一个一级目录信息（包含子目录信息）
                NSDictionary *_MyDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        tempStr, @"title",
                                        num, @"link",
                                        firstChapterArray,@"chapter",
                                        nil];
                
                [cataLogTitles addObject:_MyDic];
                
                NSLog(@"%@===", num);
                CGPDFDictionaryRef tempDic;
                tempDic = myDic;
                int j = 0;
                //循环电子书所有一级章节
                while ( j < myCount ) {
                    //获取第一个一级目录的下一个一级目录信息
                    if( CGPDFDictionaryGetDictionary( tempDic , "Next", &tempDic) )
                    {
                        CGPDFStringRef tempTitle;
                        if( CGPDFDictionaryGetString(tempDic, "Title", &tempTitle) )
                        {
                            CFStringRef tempStrRef = CGPDFStringCopyTextString(tempTitle);
                            NSString * tempStr = [self getPDFNamewithoutSuffix:(NSString*)tempStrRef];
                            CFRelease(tempStrRef);
                            NSLog(@"myTitle:%@", tempStr);
                            
                            NSString *num = [self returnCatalogListNumber:tempDic PDFDoc:thePDFDocRef];
                            NSLog(@"%@", num);
                        
                            long int chapterCount;
                            //可能有子目录但是取不到count，所以定指定最多50个二级目录
                            if (CGPDFDictionaryGetInteger(tempDic, "Count", &chapterCount)) {
                                NSLog(@"------chapter count  %ld",chapterCount);
                                if (chapterCount < 0) {
                                    chapterCount = 0 - chapterCount;
                                }
                            }else{
                                chapterCount = 50;
                            }
                            CGPDFDictionaryRef tempNexttDic;
                            tempNexttDic = tempDic;
                            NSMutableArray *nextChapterArray = [NSMutableArray array];
                            int m = 0;
                            //循环某个一级目录的子目录
                            while ( m < chapterCount ) {
                                char *key = "";
                                if (m == 0) {
                                    key = "First";
                                    CGPDFDictionaryRef tempDic = tempNexttDic;
                                    //如果当前目录没有first即没有子目录则退出循环
                                    if( !CGPDFDictionaryGetDictionary( tempDic , key, &tempDic) ) {
                                        break;
                                    }
                                }else{
                                    key = "Next";
                                }
                                
                                //获取某个一级目录的子目录信息
                                if( CGPDFDictionaryGetDictionary( tempNexttDic , key, &tempNexttDic) ) {
                                    CGPDFStringRef tempTitle;
                                    if( CGPDFDictionaryGetString(tempNexttDic, "Title", &tempTitle) )
                                    {
                                        NSString *tempStr = (NSString *)CGPDFStringCopyTextString(tempTitle);
                                        tempStr = [self getPDFNamewithoutSuffix:tempStr];
                                        
                                        NSString *num = [self returnCatalogListNumber:tempNexttDic PDFDoc:thePDFDocRef];
                                        NSLog(@"kids    :%@  ,       num :%@", tempStr,num);
                                        NSDictionary *_chapterDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                     tempStr, @"title",
                                                                     num, @"link",
                                                                     nil];
                                        [nextChapterArray addObject:_chapterDic];
                                    }
                                }
                                m++;
                            }
                            NSDictionary *_MyDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    tempStr, @"title",
                                                    num, @"link",
                                                    nextChapterArray,@"chapter",
                                                    nil];
                            [cataLogTitles addObject:_MyDic];
                        }
                    }
                    
                    j++;
                }
                
            }
        }
        
    }
    
    CGPDFDocumentRelease(thePDFDocRef);
    
    return cataLogTitles;
}


//=============
-(NSString *)returnCatalogListNumber:(CGPDFDictionaryRef)tempCGPDFDic PDFDoc:(CGPDFDocumentRef)tempCGPDFDoc
{
    NSString *returnStr;
    CGPDFDictionaryRef destDic;
    CGPDFArrayRef destArray;
    if (CGPDFDictionaryGetDictionary(tempCGPDFDic, "A", &destDic)) {
        CGPDFArrayRef tempDestArray1;
        if( CGPDFDictionaryGetArray(destDic, "D", &tempDestArray1) == false){
            return @"0";
        }else{
            destArray = tempDestArray1;
        }
    }else{
        CGPDFArrayRef tempdestArray2;
        if(CGPDFDictionaryGetArray(tempCGPDFDic, "Dest", &tempdestArray2)){
            destArray = tempdestArray2;
        }else{
            return @"0";
        }
    }
    NSInteger targetPageNumber = 0; // The target page number
    
    CGPDFDictionaryRef pageDictionaryFromDestArray = NULL; // Target reference
    
    if (CGPDFArrayGetDictionary(destArray, 0, &pageDictionaryFromDestArray) == true)
    {
        NSInteger pageCount = CGPDFDocumentGetNumberOfPages(tempCGPDFDoc);
        
        for (NSInteger pageNumber = 1; pageNumber <= pageCount; pageNumber++)
        {
            CGPDFPageRef pageRef = CGPDFDocumentGetPage(tempCGPDFDoc, pageNumber);
            
            CGPDFDictionaryRef pageDictionaryFromPage = CGPDFPageGetDictionary(pageRef);
            
            if (pageDictionaryFromPage == pageDictionaryFromDestArray) // Found it
            {
                targetPageNumber = pageNumber; break;
            }
        }
    }
    else // Try page number from array possibility
    {
        CGPDFInteger pageNumber = 0; // Page number in array
        
        if (CGPDFArrayGetInteger(destArray, 0, &pageNumber) == true)
        {
            targetPageNumber = (pageNumber + 1); // 1-based
        }
    }
    
    if (targetPageNumber > 0) // We have a target page number
    {
        returnStr = [NSString stringWithFormat:@"%d", targetPageNumber];
    }else{
        returnStr = [NSString stringWithFormat:@"%d", 0];
    }
    return returnStr;
}

- (NSString *)getPDFNamewithoutSuffix:(NSString *)pdfName{
    return [pdfName stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
}

@end
