#import <Foundation/Foundation.h>
#import "StringDetector.h"
#import "FontCollection.h"
#import "RenderingState.h"
#import "Selection.h"
#import "RenderingStateStack.h"
#import "Ebook.h"
#import "Chapter.h"




@class Scanner;

@protocol ScannerDelegate <NSObject>

@optional
//完成一本书搜索
-(void)Scanner:(Scanner*)scanner DidScanFinishEbook:(Ebook*)ebook;

//搜索到某页
-(void)Scanner:(Scanner*)scanner DidFinishScanEbook:(Ebook*)ebook chapter:(Chapter*)chapter atPageNumber:(NSInteger)pageNumber selections:(NSArray*)selections;

@end


@interface Scanner : NSObject <StringDetectorDelegate> {
	NSURL *documentURL;
	NSString *keyword;
    
	CGPDFDocumentRef pdfDocument;
	CGPDFOperatorTableRef operatorTable;
    
	StringDetector *stringDetector;
	FontCollection *fontCollection;
	RenderingStateStack *renderingStateStack;
	Selection *currentSelection;
	NSMutableArray *selections;
	NSMutableString *content;
}


@property (nonatomic, retain) NSMutableArray *selections;
@property (nonatomic, retain) RenderingStateStack *renderingStateStack;
@property (nonatomic, retain) FontCollection *fontCollection;
@property (nonatomic, retain) StringDetector *stringDetector;
@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, retain) NSMutableString *content;
//added by Joy Zeng 2012/9/12
@property (nonatomic, retain) NSMutableDictionary *fileOfSelections;
@property (nonatomic, retain) NSString *currentFileName;
@property (nonatomic, retain) NSMutableArray *pageNumberOfSelections;
@property (nonatomic, readonly) NSInteger currentPageNumber;  //当前扫描页
//end added
@property (nonatomic) CGPDFDocumentRef pdfDocument;
@property (nonatomic, copy) NSURL *documentURL;
@property (assign)    BOOL scanAllFilesFlag;       //搜索多文件的标志；
@property (assign)    BOOL scanAllPagesFlag;       //搜索单文件的标志；
@property (readonly)  BOOL isScanning;
@property (assign, nonatomic) id <ScannerDelegate>delegate;
@property (nonatomic, assign) NSInteger tag;       //搜索器的标识，区分不同的搜索器；
//
@property (nonatomic,retain)Ebook* ebook;
@property (nonatomic,retain)Chapter* chapter;

//用eBook对象初始化
- (id)initWithEbook:(Ebook*)aEbook;

/* Initialize with a file path */
- (id)initWithContentsOfFile:(NSString *)path;

/* Initialize with a PDF document */
- (id)initWithDocument:(CGPDFDocumentRef)document;

/* Start scanning (synchronous) */
- (void)scanDocumentPage:(NSUInteger)pageNumber;

/* Start scanning a particular page */
- (void)scanPage:(CGPDFPageRef)page;

- (void)scanFromPageNumber:(NSInteger)pageNumber;

//added by Joy Zeng

//从当前页开始搜索单文件的上一页
- (void)scanLastPageOfSelectionsFromPage:(NSInteger)currentPage;
//从当前页开始搜索单文件的下一页
- (void)scanNextPageOfSelectionsFromPage:(NSInteger)currentPage;
// 搜索多文件
- (void) scanFilesWithNames:(NSArray *)names urls:(NSDictionary *) urls;

// 搜索单文件所有页
- (void) scanAllPagesWithFileUrl:(NSURL *)docUrl;

//搜索当前一页 ，在原API scanDocumentPage上添加代理，停止方法，异步搜索
-(void)scanPageNumber:(NSUInteger)pageNumber;

-(void)stopScan;
//end added

//多本电子书搜索
-(void)scanEbooks:(NSArray*)ebookArray;

//搜索单本书
-(void)scanEbook:(Ebook*)book;


@end
