


#import "Scanner.h"


#pragma mark

@interface Scanner ()

{
    
    
    NSUInteger selectionCount;
    __block BOOL isStop;
    
    
}


#pragma mark - Text showing

// Text-showing operators
void Tj(CGPDFScannerRef scanner, void *info);
void quot(CGPDFScannerRef scanner, void *info);
void doubleQuot(CGPDFScannerRef scanner, void *info);
void TJ(CGPDFScannerRef scanner, void *info);

#pragma mark Text positioning

// Text-positioning operators
void Td(CGPDFScannerRef scanner, void *info);
void TD(CGPDFScannerRef scanner, void *info);
void Tm(CGPDFScannerRef scanner, void *info);
void TStar(CGPDFScannerRef scanner, void *info);

#pragma mark Text state

// Text state operators
void BT(CGPDFScannerRef scanner, void *info);
void Tc(CGPDFScannerRef scanner, void *info);
void Tw(CGPDFScannerRef scanner, void *info);
void Tz(CGPDFScannerRef scanner, void *info);
void TL(CGPDFScannerRef scanner, void *info);
void Tf(CGPDFScannerRef scanner, void *info);
void Ts(CGPDFScannerRef scanner, void *info);

#pragma mark Graphics state

// Special graphics state operators
void q(CGPDFScannerRef scanner, void *info);
void Quite(CGPDFScannerRef scanner, void *info);
void cm(CGPDFScannerRef scanner, void *info);


@property (nonatomic, retain)   Selection *currentSelection;
@property (nonatomic, readonly) RenderingState *currentRenderingState;
@property (nonatomic, readonly) Font *currentFont;
/* Returts the operator callbacks table for scanning page stream */
@property (nonatomic, readonly) CGPDFOperatorTableRef operatorTable;
@property (nonatomic, retain)   NSMutableArray* selectionsBatch;        //一批关键字结果

@end

#pragma mark

@implementation Scanner

static const  NSUInteger kMaximumResultNumber = 30;  //搜索结果最大数量
static const  NSUInteger kMaximumNumberToSearch = 30;  //一次搜索结果最大数量

NSString *kAddEarthquakesNotif = @"AddDataNotif";
NSString *kEarthquakeResultsKey = @"EarthquakeResultsKey";





@synthesize scanAllFilesFlag;
@synthesize scanAllPagesFlag;
@synthesize documentURL, keyword, stringDetector, fontCollection, renderingStateStack, currentSelection, selections /* rawTextContent */, content,currentFileName,fileOfSelections,pageNumberOfSelections,currentPageNumber;
@synthesize isScanning;
@synthesize delegate;
@synthesize selectionsBatch;
@synthesize tag;
@synthesize ebook;
@synthesize chapter;







#pragma mark - Initialization


- (id)initWithEbook:(Ebook*)aEbook
{
	if ((self = [super init]))
	{
        self.ebook=aEbook;
      
        NSURL* url =[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", aEbook.bookId ]isDirectory:NO];
        self.documentURL=url;
        CGPDFDocumentRef docRef = CGPDFDocumentCreateWithURL((CFURLRef)url);
        pdfDocument = CGPDFDocumentRetain(docRef);
        self.content = [NSMutableString stringWithString:@""];
        
	}
	return self;
}


- (id)initWithDocument:(CGPDFDocumentRef)document
{
	if ((self = [super init]))
	{
		pdfDocument = CGPDFDocumentRetain(document);
		self.content = [NSMutableString stringWithString:@""];
        
	}
	return self;
}

- (id)initWithContentsOfFile:(NSString *)path
{
	if ((self = [super init]))
	{
		self.documentURL = [NSURL fileURLWithPath:path];
        self.content = [NSMutableString stringWithString:@""];
	}
	return self;
}

#pragma mark Scanner state accessors

- (RenderingState *)currentRenderingState
{
	return [self.renderingStateStack topRenderingState];
}

- (Font *)currentFont
{
	return self.currentRenderingState.font;
}

- (CGPDFDocumentRef)pdfDocument
{
	if (!pdfDocument)
	{
       pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)self.documentURL);

	}
	return pdfDocument;
}

/* The operator table used for scanning PDF pages */
- (CGPDFOperatorTableRef)operatorTable
{
	if (operatorTable)
	{
		return operatorTable;
	}
	
	operatorTable = CGPDFOperatorTableCreate();
    
	// Text-showing operators
	CGPDFOperatorTableSetCallback(operatorTable, "Tj", Tj);
	CGPDFOperatorTableSetCallback(operatorTable, "\'", quot);
	CGPDFOperatorTableSetCallback(operatorTable, "\"", doubleQuot);
	CGPDFOperatorTableSetCallback(operatorTable, "TJ", TJ);
	
	// Text-positioning operators
	CGPDFOperatorTableSetCallback(operatorTable, "Tm", Tm);
	CGPDFOperatorTableSetCallback(operatorTable, "Td", Td);
	CGPDFOperatorTableSetCallback(operatorTable, "TD", TD);
	CGPDFOperatorTableSetCallback(operatorTable, "T*", TStar);
	
	// Text state operators
	CGPDFOperatorTableSetCallback(operatorTable, "Tw", Tw);
	CGPDFOperatorTableSetCallback(operatorTable, "Tc", Tc);
	CGPDFOperatorTableSetCallback(operatorTable, "TL", TL);
	CGPDFOperatorTableSetCallback(operatorTable, "Tz", Tz);
	CGPDFOperatorTableSetCallback(operatorTable, "Ts", Ts);
	CGPDFOperatorTableSetCallback(operatorTable, "Tf", Tf);
	
	// Graphics state operators
	CGPDFOperatorTableSetCallback(operatorTable, "cm", cm);
	CGPDFOperatorTableSetCallback(operatorTable, "q", q);
	CGPDFOperatorTableSetCallback(operatorTable, "Q", Quite);
	
	CGPDFOperatorTableSetCallback(operatorTable, "BT", BT);
	
	return operatorTable;
}

/* Create a font dictionary given a PDF page */
- (FontCollection *)fontCollectionWithPage:(CGPDFPageRef)page
{
	CGPDFDictionaryRef dict = CGPDFPageGetDictionary(page);
	if (!dict)
	{
		NSLog(@"Scanner: fontCollectionWithPage: page dictionary missing");
		return nil;
	}
	CGPDFDictionaryRef resources;
	if (!CGPDFDictionaryGetDictionary(dict, "Resources", &resources))
	{
		NSLog(@"Scanner: fontCollectionWithPage: page dictionary missing Resources dictionary");
		return nil;
	}
	CGPDFDictionaryRef fonts;
	if (!CGPDFDictionaryGetDictionary(resources, "Font", &fonts)) return nil;
	FontCollection *collection = [[FontCollection alloc] initWithFontDictionary:fonts];
	return [collection autorelease];
}
//added by Joy Zeng 2012/9/12
- (void) scanLastPageOfSelectionsFromPage:(NSInteger)currentPage
{
    //搜索单文件，设置标志
    scanAllFilesFlag = NO;
    scanAllPagesFlag = YES;
    //取得文件页数
    
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDocument);
    
    int scanCount = 0;   //搜索次数
    //从上一页开始搜索，一有结果则跳出搜索
    for (int i = currentPage - 1 ; i >= 0; i--) {
        
        @autoreleasepool {
            
            //如果搜索到第一页，则跳到最后页进行搜索
            if (i == 0) {
                i = numberOfPages;
            }
            
            [self scanDocumentPage:i];
            
            //判断当前扫描页是否有新增结果，若有，则跳出搜索
            
            if ([selections count] > 0 && selections ) {
                
                return;
            }
            
            //增加搜索次数，如果次数等于文件页数，表明整个文件已搜完，没有匹配的关键字，则跳出循环
            scanCount++;
            if (scanCount >= numberOfPages) {
                break;
            }
            
        }
        
        
        
    }
    
}

- (void) scanNextPageOfSelectionsFromPage: (NSInteger) currentPage
{
    //搜索单文件，设置标志
    scanAllFilesFlag = NO;
    scanAllPagesFlag = YES;
    //取得文件页数
    
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDocument);
    
    //从下一页开始搜索，一有结果则跳出搜索
    for (int i = currentPage + 1; i <= numberOfPages + 1; i++) {
        
        @autoreleasepool {
            
            //如果次数等于文件页数，表明整个文件已搜完，没有匹配的关键字，则跳出循环
            //            if (i >= numberOfPages) {
            //                break;
            //            }
            //
            //如果已搜索到最后一页，则跳到第一页进行搜索
            if (i == numberOfPages + 1) {
                i = 1;
            }
            [self scanDocumentPage:i];
            
            
            //判断是否有新增结果，若有，则跳出搜索
            if ([selections count] > 0 && selections ) {
                
                return;
            }
            
        }
        
    }
    
    
}

- (void) scanAllPagesWithFileUrl:(NSURL *)docUrl
{
    scanAllFilesFlag = NO;
    scanAllPagesFlag = YES;
    self.documentURL  = docUrl;
    pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)self.documentURL);
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDocument);
    for (int i = 1; i <= numberOfPages; i++) {
        [self scanDocumentPage:i];
    }
}

//end added

/* Scan the given page of the current document */
- (void)scanDocumentPage:(NSUInteger)pageNumber
{
	CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, pageNumber);
    
    //[self scannerReset];
    
    [self scanPage:page];
    
}

-(void)scannerReset{
    
    self.content=nil;
    self.selections=nil;
    self.renderingStateStack=nil;
    self.stringDetector=nil;
}

#pragma mark Start scanning

- (void)scanPage:(CGPDFPageRef)page
{
    isStop=NO;
    isScanning=YES;
	// Return immediately if no keyword set
	if (!keyword) return;
    
    [self.stringDetector reset];
    self.stringDetector.keyword = self.keyword;
    //added by Joy Zeng
    currentPageNumber = CGPDFPageGetPageNumber(page);
    
    //end added
    // Initialize font collection (per page)
	self.fontCollection = [self fontCollectionWithPage:page];
    
	CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(page);
	CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, self.operatorTable, self);
    
	CGPDFScannerScan(scanner);
    
	CGPDFScannerRelease(scanner);
    scanner = nil;
    
	CGPDFContentStreamRelease(contentStream);
    contentStream = nil;
    
    
}

// add by Sencho Kong
//搜索当前一页 ，在原API scanDocumentPage上添加代理，停止方法，异步搜索

-(void)scanPageNumber:(NSUInteger)pageNumber{
    
    if (pageNumber<1)return;
    
    dispatch_queue_t searchQueue= dispatch_queue_create("search queue", NULL);
    
    dispatch_async(searchQueue, ^{
        [self.selections removeAllObjects];
        [self scanDocumentPage:pageNumber];
        if (self.selections) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addSelectionToList:self.selections];
                if (delegate && [delegate respondsToSelector:@selector(Scanner:DidScanFinishEbook:)]) {
                    [delegate Scanner:self DidScanFinishEbook:self.ebook];
                }

            });
            
        }
        
        isScanning=NO;
    });
    
    dispatch_release(searchQueue);
    
    
}


//从某一页开始搜索关键字
-(void)scanFromPageNumber:(NSInteger)pageNumber{
    isStop=NO;
    if (pageNumber<1)return;
      
    NSURL* url=nil ;
    Chapter* aChapter=nil;
//    if (self.ebook.chapters.count>0) {
    if (false) {
        //从最后一个结果中取chapterId生成PDF URL
       
        for (aChapter in self.ebook.chapters ) {
            if ([aChapter.chapterId isEqualToString:[self.ebook.selections.lastObject chapterId] ]) {
                  url=[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", aChapter.chapterId ]isDirectory:NO];
                
            }
            
            
        }
        //如果ebook selections为空即没有搜索纪录的，是直接由章节进入的，就取新一个章节的URL
        if (self.ebook.selections.count==0||self.ebook.selections==nil) {
            aChapter=[[self.ebook.chapters allObjects] objectAtIndex:0];
            url=[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", aChapter.chapterId ]isDirectory:NO];
        }
        
        self.chapter=aChapter;

//        int totalPage=CGPDFDocumentGetNumberOfPages([self pdfDocument]);
//        if (pageNumber==totalPage) return;
//        
//        if (pageNumber>totalPage) {
//            
//            NSInteger index=[[self.ebook.chapters allObjects] indexOfObject:self.chapter];
//            
//            if (index+1<=self.ebook.chapters.count) {
//                aChapter=[[self.ebook.chapters allObjects] objectAtIndex:index+1];
//                url=[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", aChapter.chapterId ]isDirectory:NO];
//                self.documentURL=url;
//                totalPage=CGPDFDocumentGetNumberOfPages([self pdfDocument]);
//                pageNumber=1;
//            }
//            
//            
//        }

        
    }else{
        //如果没有章节就直接取bookId
        url=[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", self.ebook.bookId ]isDirectory:NO];
    }

    self.documentURL=url;

    
    int totalPage=CGPDFDocumentGetNumberOfPages([self pdfDocument]);
    
    
        
    dispatch_queue_t searchQueue= dispatch_queue_create("search queue", NULL);
    
    dispatch_async(searchQueue, ^{
        
        for (int i=pageNumber; i<totalPage+1; i++) {
            @autoreleasepool {
                
                if (isStop){
                    isStop=NO;
                    break;
                    
                }
                
                [self scanDocumentPage:i];
                
                if (self.selections.count>0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addSelectionToList:self.selections];
                        [self.selections removeAllObjects];
                    });
                }
                
                
                // self.selections ;
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate && [delegate respondsToSelector:@selector(Scanner:DidScanFinishEbook:)]) {
                [delegate Scanner:self DidScanFinishEbook:self.ebook];
            }

        });
        isScanning=NO;
    });
    
    
    dispatch_release(searchQueue);
    
    
}



//多文件搜索关键字 add by Sencho Kong
- (void) scanFilesWithNames:(NSArray *)names urls:(NSDictionary *)urls
{
    scanAllFilesFlag = YES;
    scanAllPagesFlag = NO;
    
    if (fileOfSelections) {
        [fileOfSelections removeAllObjects];
    }
    
    //多个文件搜索关键字
    for(int j=0;j<names.count;j++){
        
        if (isStop){
            
            break;
        }
        NSString* eachFile=[names objectAtIndex:j];
        self.currentFileName = eachFile;
        self.documentURL = [urls objectForKey:eachFile];
        
        pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)self.documentURL);
        
        size_t numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDocument);
        for (int i = 1; i <= numberOfPages; i++) {
            
            @autoreleasepool {
                
                if (isStop){
                    break;
                }
                
                [self scanDocumentPage:i];
                // 若已在当前页找到关键字，则跳出，进行下一个文件的搜索
                if ([self.selections count] > 0) {
                    
                    
                    if (!fileOfSelections) {
                        fileOfSelections = [[NSMutableDictionary alloc] init ];
                    }
                    
                    if (self.documentURL!=nil) {
                        [self.fileOfSelections setObject:self.documentURL forKey:self.currentFileName];
                    }
                    
                    
                    [self.selections removeAllObjects];
                    break;
                }
            }
            
        }
        
    }
    isStop=NO;
    isScanning=NO;
    
    if (delegate && [delegate respondsToSelector:@selector(Scanner:DidScanFinishEbook:)]) {
        [delegate Scanner:self DidScanFinishEbook:self.ebook];
    }

}

-(void)stopScan{
    isStop=YES;
    isScanning=NO;
    
}


-(void)scanEbooks:(NSArray*)ebookArray{
    
    if (ebookArray.count==0||ebookArray==nil) {
        return;
    }
    
 
    //创建队列
    dispatch_group_t group=dispatch_group_create();
    
    for (Ebook* abook in ebookArray) {
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            
            [self scanEbook:abook];
        });
    }
    
     
    //完成所有的扫描后告诉代理
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        
        if (delegate && [delegate respondsToSelector:@selector(Scanner:DidScanFinishEbook:)]) {
            [delegate Scanner:self DidScanFinishEbook:self.ebook];
        }

       
    });
    
    dispatch_release(group);
    
}

//一本电子书全文包括章节搜
-(void)scanEbook:(Ebook*)book{
    
//    
    isStop=NO;
    self.ebook=book;
   
    self.ebook.selections =[NSMutableArray array];
    
//    if (self.ebook.chapters.count>0) { //有章节情况下
    if (false) { //有章节情况下
        
        for (int j = 0; j < self.ebook.chapters.count; j++) {
            @autoreleasepool {
                
                if (isStop)break;
                self.chapter=[[self.ebook.chapters allObjects] objectAtIndex:j];
                
                NSURL* url=[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", self.chapter.chapterId ]isDirectory:NO];
                
                self.documentURL = url;
                
                if (pdfDocument) {
                    CGPDFDocumentRelease(pdfDocument);
                    pdfDocument=CGPDFDocumentCreateWithURL((CFURLRef)self.documentURL);
                }
                if ([self pdfDocument]==nil) {
                    break;
                }
                
                size_t numberOfPages = CGPDFDocumentGetNumberOfPages([self pdfDocument]);
                
                for (int i = 0; i < numberOfPages; i++) {
                    @autoreleasepool {
                        
                        if (isStop){
                            break;
                        }

                        isScanning=YES;
                        
                          dispatch_async(  dispatch_get_main_queue(), ^{
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"scanningScanner" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:numberOfPages],@"numberOfPage",[NSNumber numberWithInt:j],@"chapterNumber", nil]];
                          });
                        [self scanDocumentPage:i+1];
                        
                       
                        
                        if (self.selections.count>0) {
                            
                             dispatch_async(  dispatch_get_main_queue(), ^{
                                [self.ebook.selections addObjectsFromArray:self.selections];
                                [self addSelectionToList:self.selections];
                                if (delegate && [delegate respondsToSelector:@selector(Scanner:DidFinishScanEbook:chapter:atPageNumber:selections: )]) {
                                    [delegate Scanner:self DidFinishScanEbook:self.ebook chapter:self.chapter atPageNumber:i+1 selections:self.selections];
                                }
                                
                                [self.selections removeAllObjects];
                            });
                              
                        }
                        
                        
                    }
                    
                }
            }
            
        }
        
    }
    else{//无章节情况下
    
        self.chapter=nil;
        
        NSURL* url=[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", self.ebook.bookId ]isDirectory:NO];
        
        self.documentURL = url;
        
        if (pdfDocument) {
            CGPDFDocumentRelease(pdfDocument);
            pdfDocument=CGPDFDocumentCreateWithURL((CFURLRef)self.documentURL);
        }
        if ([self pdfDocument]==nil) {
            
            //完成一个ebook扫描后告诉代理
            dispatch_async(  dispatch_get_main_queue(), ^{
                isStop=NO;
                isScanning=NO;
                
                if (delegate && [delegate respondsToSelector:@selector(Scanner:DidScanFinishEbook:)]) {
                    [delegate Scanner:self DidScanFinishEbook:self.ebook];
                }
                

            });

            return;
        }
        size_t numberOfPages = CGPDFDocumentGetNumberOfPages([self pdfDocument]);
        
        for (int i = 0; i < numberOfPages; i++) {
            @autoreleasepool {
                
                if (isStop){
                    break;
                }
                
                isScanning=YES;
                //扫描完一页之后反馈结果给代理，结果队列selections清空
                  dispatch_async(  dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"scanningScanner" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:numberOfPages],@"numberOfPage",[NSNumber numberWithInt:0],@"chapterNumber", nil]];
                  });
                [self scanDocumentPage:i+1];
                if (self.selections.count>0) {
                   
                    dispatch_async(  dispatch_get_main_queue(), ^{
                        
                        [self.ebook.selections addObjectsFromArray:self.selections];
                        [self addSelectionToList:self.selections];
                        
                        if (delegate && [delegate respondsToSelector:@selector(Scanner:DidFinishScanEbook:chapter:atPageNumber:selections: )]) {
                            [delegate Scanner:self DidFinishScanEbook:self.ebook chapter:self.chapter atPageNumber:i+1 selections:self.selections];
                        }
                        [self.selections removeAllObjects];
                    });
                    
                    
                    
                }
                
            }
            
        }
        
        
    }
    
    //完成一个ebook扫描后告诉代理
    dispatch_async(  dispatch_get_main_queue(), ^{
        isStop=NO;
        isScanning=NO;
        
        if (delegate && [delegate respondsToSelector:@selector(Scanner:DidScanFinishEbook:)]) {
            [delegate Scanner:self DidScanFinishEbook:self.ebook];
        }
        
        
    });
    
  
 
}


#pragma mark - Notification


static const  NSUInteger kMaximumNumberOfSelectionsToSearch = 100;  //一次最大搜索数

- (void)addSelectionToList:(NSArray *)selection{
    
    assert([NSThread isMainThread]);
    
    //如果一页扫描的结果数量大于kMaximumNumberOfSelectionsToSearch个就传送
    if (selection.count>=kMaximumNumberOfSelectionsToSearch) {
        
        if (delegate && [delegate respondsToSelector:@selector(Scanner:DidScanFinishEbook:)]) {
            [delegate Scanner:self DidScanFinishEbook:self.ebook];
        }
        
        [self stopScan];
        selectionCount=0;
        
    }else{
        
        selectionCount+=selection.count;
        //如果数量大于最大值就停止,
        if (selectionCount>=kMaximumNumberOfSelectionsToSearch){
            
            if (delegate && [delegate respondsToSelector:@selector(Scanner:DidScanFinishEbook:)]) {
                [delegate Scanner:self DidScanFinishEbook:self.ebook];
            }
            [self stopScan];
            selectionCount=0;
        }
        
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDataNotif"
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:selection
                                                                                           forKey:@"AddDataNotif"]];
    
    
}



#pragma mark StringDetectorDelegate

- (void)detector:(StringDetector *)detector didScanCharacter:(unichar)character
{
    
    
	RenderingState *state = [self currentRenderingState];
    
    if (!state) {
        
    }
    
	CGFloat width = [self.currentFont widthOfCharacter:character withFontSize:state.fontSize];
    
    //added by Joy Zeng 2012/10/24
    //字符串由中英文混合组成时，部分字符宽度无法找到则返回默认值1000
    if (width == 1000) {
        //判断是否ascii字符，若是，将宽度除以2.避免将其当成中文字符计算宽度。
        if (isascii(character)) {
            width /= 2;
        }
    }
    //end added
    
	width /= 1000;
	width += state.characterSpacing;
	if (character == 32)
	{
		width += state.wordSpacing;
	}
	[state translateTextPosition:CGSizeMake(width, 0)];
}

- (void)detector:(StringDetector *)detector didStartMatchingString:(NSString *)string
{
	Selection *selection = [[Selection alloc] initWithStartState:self.currentRenderingState];
	self.currentSelection = selection;
	[selection release];
}

- (void)detector:(StringDetector *)detector foundString:(NSString *)needle
{
	RenderingState *state = [[self renderingStateStack] topRenderingState];
    
	[self.currentSelection finalizeWithState:state];
    
	if (self.currentSelection)
	{
        self.currentSelection.pageNumber=currentPageNumber;
        
        self.currentSelection.unicodeContent=needle;
        
        self.currentSelection.ebook=self.ebook;
        
        self.currentSelection.chapter=self.chapter;
        
		[self.selections addObject:self.currentSelection];
        
        self.currentSelection = nil;
        
        
	}
    //added by Joy Zeng 2012/9/12
    //单文件搜索，保存keyword所在页码
    if (scanAllPagesFlag == YES) {
        if (!pageNumberOfSelections) {
            pageNumberOfSelections =  [[NSMutableArray alloc] init ];
        }
        [self.pageNumberOfSelections addObject:[NSNumber numberWithInt: currentPageNumber]];
    }
    //end added
}

#pragma mark - Scanner callbacks

void BT(CGPDFScannerRef scanner, void *info)
{
    /* The identity transform: [ 1 0 0 1 0 0 ]. */
    
	[[(Scanner *)info currentRenderingState] setTextMatrix:CGAffineTransformIdentity replaceLineMatrix:YES];
}

/* Pops the requested number of values, and returns the number of values popped */
// !!!: Make sure this is correct, then use it
int popIntegers(CGPDFScannerRef scanner, CGPDFInteger *buffer, size_t length)
{
    bzero(buffer, length);
    CGPDFInteger value;
    int i = 0;
    while (i < length)
    {
        if (!CGPDFScannerPopInteger(scanner, &value)) break;
        buffer[i] = value;
        i++;
    }
    return i;
}

#pragma mark Text showing operators

//value 为扫描到的字符宽度
void didScanSpace(float value, Scanner *scanner)
{
    float width = [scanner.currentRenderingState convertToUserSpace:value];
    [scanner.currentRenderingState translateTextPosition:CGSizeMake(-width, 0)];
    //如果value的绝对值大于等于当前字体的空格宽度，重置匹配器
    if (abs(value) >= [scanner.currentRenderingState.font widthOfSpace])
    {
        [scanner.stringDetector reset];
    }
}

/* Called any time the scanner scans a string */
void didScanString(CGPDFStringRef pdfString, Scanner *scanner)
{
    [[scanner stringDetector] appendPDFString:pdfString withFont:[scanner currentFont]];
	//[[scanner content] appendString:string];
    
    // float xxxx= [scanner currentRenderingState].textMatrix.tx;
}

/* Show a string */
void Tj(CGPDFScannerRef scanner, void *info)
{
	CGPDFStringRef pdfString = nil;
	if (!CGPDFScannerPopString(scanner, &pdfString)) return;
	didScanString(pdfString, info);
    
}

/* Equivalent to operator sequence [T*, Tj] */
void quot(CGPDFScannerRef scanner, void *info)
{
	TStar(scanner, info);
	Tj(scanner, info);
}

/* Equivalent to the operator sequence [Tw, Tc, '] */
void doubleQuot(CGPDFScannerRef scanner, void *info)
{
	Tw(scanner, info);
	Tc(scanner, info);
	quot(scanner, info);
}

/* Array of strings and spacings ,sample:AWAY again , [ (A) 120 (W) 120 (A) 95 (Y again) ] TJ    ，括号内的数据是字符宽度 */
void TJ(CGPDFScannerRef scanner, void *info)
{
	CGPDFArrayRef array = nil;
	CGPDFScannerPopArray(scanner, &array);
    size_t count = CGPDFArrayGetCount(array);
	for (int i = 0; i < count; i++)
	{
		CGPDFObjectRef object = nil;
		CGPDFArrayGetObject(array, i, &object);
		CGPDFObjectType type = CGPDFObjectGetType(object);
        switch (type)
        {
                //如果是字符类型，取字符
            case kCGPDFObjectTypeString:
            {
                CGPDFStringRef pdfString;
                if (CGPDFObjectGetValue(object, kCGPDFObjectTypeString, &pdfString))
                {
                    didScanString(pdfString, info);
                }
                break;
            }
            case kCGPDFObjectTypeReal:
            {
                CGPDFReal tx;
                if (CGPDFObjectGetValue(object, kCGPDFObjectTypeReal, &tx))
                {
                    didScanSpace(tx, info);
                }
                break;
            }
            case kCGPDFObjectTypeInteger:
            {
                CGPDFInteger tx;
                if (CGPDFObjectGetValue(object, kCGPDFObjectTypeInteger, &tx))
                {
                    didScanSpace(tx, info);
                }
                break;
            }
            default:
                NSLog(@"Scanner: TJ: Unsupported type: %d", type);
                break;
        }
	}
}

#pragma mark Text positioning operators

/* Move to start of next line */
void Td(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal tx = 0, ty = 0;
	CGPDFScannerPopNumber(scanner, &ty);
	CGPDFScannerPopNumber(scanner, &tx);
	[[(Scanner *)info currentRenderingState] newLineWithLeading:-ty indent:tx save:NO];
}

/* Move to start of next line, and set leading */
void TD(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal tx, ty;
	if (!CGPDFScannerPopNumber(scanner, &ty)) return;
	if (!CGPDFScannerPopNumber(scanner, &tx)) return;
	[[(Scanner *)info currentRenderingState] newLineWithLeading:-ty indent:tx save:YES];
}

/* 转换矩阵 Set line and text matrixes */
void Tm(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal a, b, c, d, tx, ty;
	if (!CGPDFScannerPopNumber(scanner, &ty)) return;
	if (!CGPDFScannerPopNumber(scanner, &tx)) return;
	if (!CGPDFScannerPopNumber(scanner, &d)) return;
	if (!CGPDFScannerPopNumber(scanner, &c)) return;
	if (!CGPDFScannerPopNumber(scanner, &b)) return;
	if (!CGPDFScannerPopNumber(scanner, &a)) return;
	CGAffineTransform t = CGAffineTransformMake(a, b, c, d, tx, ty);
	[[(Scanner *)info currentRenderingState] setTextMatrix:t replaceLineMatrix:YES];
}

/*开始扫描新一行 Go to start of new line, using stored text leading */
void TStar(CGPDFScannerRef scanner, void *info)
{
	[[(Scanner *)info currentRenderingState] newLine];
}

#pragma mark Text State operators

/* 字内字母间距离 Set character spacing */
void Tc(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal charSpace;
	if (!CGPDFScannerPopNumber(scanner, &charSpace)) return;
	[[(Scanner *)info currentRenderingState] setCharacterSpacing:charSpace];
}

/* 字间距 Set word spacing */
void Tw(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal wordSpace;
	if (!CGPDFScannerPopNumber(scanner, &wordSpace)) return;
	[[(Scanner *)info currentRenderingState] setWordSpacing:wordSpace];
}

/* Set horizontal scale factor */
void Tz(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal hScale;
	if (!CGPDFScannerPopNumber(scanner, &hScale)) return;
	[[(Scanner *)info currentRenderingState] setHorizontalScaling:hScale];
}

/* 本行字的底部到上行字的底部的间距 Set text leading */
void TL(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal leading;
	if (!CGPDFScannerPopNumber(scanner, &leading)) return;
	[[(Scanner *)info currentRenderingState] setLeadning:leading];
}

/* 字体大小 Font and font size */

void Tf(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal fontSize;
	const char *fontName;
	if (!CGPDFScannerPopNumber(scanner, &fontSize)) return;
	if (!CGPDFScannerPopName(scanner, &fontName)) return;
	
	RenderingState *state = [(Scanner *)info currentRenderingState];
    
    
    //通过字体名称从当前页的字体集中取出字体对象
	Font *font = [[(Scanner *)info fontCollection] fontNamed:[NSString stringWithUTF8String:fontName]];
	[state setFont:font];
	[state setFontSize:fontSize];
    
}

/*  字体高 Set text rise */
void Ts(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal rise;
	if (!CGPDFScannerPopNumber(scanner, &rise)) return;
	[[(Scanner *)info currentRenderingState] setTextRise:rise];
}


#pragma mark Graphics state operators

/* Push a copy of current rendering state */
void q(CGPDFScannerRef scanner, void *info)
{
	RenderingStateStack *stack = [(Scanner *)info renderingStateStack];
	RenderingState *state = [[(Scanner *)info currentRenderingState] copy];
	[stack pushRenderingState:state];
	[state release];
}

/* Pop current rendering state */
void Quite(CGPDFScannerRef scanner, void *info)
{
	[[(Scanner *)info renderingStateStack] popRenderingState];
}

/* Update CTM */
void cm(CGPDFScannerRef scanner, void *info)
{
	CGPDFReal a, b, c, d, tx, ty;
	if (!CGPDFScannerPopNumber(scanner, &ty)) return;
	if (!CGPDFScannerPopNumber(scanner, &tx)) return;
	if (!CGPDFScannerPopNumber(scanner, &d)) return;
	if (!CGPDFScannerPopNumber(scanner, &c)) return;
	if (!CGPDFScannerPopNumber(scanner, &b)) return;
	if (!CGPDFScannerPopNumber(scanner, &a)) return;
	
	RenderingState *state = [(Scanner *)info currentRenderingState];
	CGAffineTransform t = CGAffineTransformMake(a, b, c, d, tx, ty);
	state.ctm = CGAffineTransformConcat(state.ctm, t);
}


#pragma mark -
#pragma mark Memory management

- (RenderingStateStack *)renderingStateStack
{
	if (!renderingStateStack)
	{
		renderingStateStack = [[RenderingStateStack alloc] init];
	}
	return renderingStateStack;
}

- (StringDetector *)stringDetector
{
	if (!stringDetector)
	{
		stringDetector = [[StringDetector alloc] initWithKeyword:self.keyword];
		stringDetector.delegate = self;
	}
	return stringDetector;
}

- (NSMutableArray *)selections
{
	if (!selections)
	{
		selections = [[NSMutableArray alloc] init];
	}
	return selections;
}

- (void)dealloc
{
    //added by Joy Zeng 2012/9/13
    [pageNumberOfSelections release];
    [fileOfSelections release];
    [currentFileName release];
    //end added
	CGPDFOperatorTableRelease(operatorTable);
	[currentSelection release];
	[fontCollection release];
    
	[renderingStateStack release];
    
	[keyword release];
    keyword = nil;
    
	[stringDetector release];
    
	[documentURL release];
    documentURL = nil;
    
	CGPDFDocumentRelease(pdfDocument);
    pdfDocument = nil;
    
	[content release];
    
    [selections release];
    
    [selectionsBatch release];
    
    [ebook release];
    [chapter release];
    delegate=nil;
    
    [self stopScan];
    
    
    
	[super dealloc];
}


@end
