
#import "Scanner.h"
#import "PDFDocumentsViewController.h"
#import "PDFDownloadListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PrettyTableViewCell.h"
#import "Ebook.h"
#import "MBProgressHUD.h"
#import "Chapter.h"
#import "PDFChatperViewController.h"
#import "PDFOutlineUtil.h"

#import "NewPDFDownloadListViewController.h"



@interface PDFDocumentsViewController (){
    
   
    int selectedSegmentIndex;
    
    
    NSIndexPath* selectedCellIndex;      //选中行的行号
    NSMutableArray* selectedCellIndexes;  //选中行的行号数组
    NSMutableArray* resultCellIndexes;    //多文件搜索文件名结果行号数组
    BOOL isFoundFile;                     //多文件搜索结果标识
    MBProgressHUD* HUD; 
    NSString *bookType;
    BOOL isScanning;                      //扫描状态标识
    Scanner* scanner;
    BOOL stopScan;
}

@property (nonatomic,retain)UISearchDisplayController* searchDisplayController;
@property (nonatomic,retain)NSMutableArray* searchDocmentsList;            //将要全文搜索的文件名列表
@property (nonatomic,retain)UISearchBar* searchBar;;
@property (nonatomic,retain)NSMutableDictionary* searchResultCacheDic;     //全文检索结果缓存 ，key是关键字，value是结果数组（找到的关键字页码）
@property (nonatomic,retain)NSMutableArray* foundedFiles;                  //多文件检索结果数据源
@property (nonatomic,retain)NSMutableDictionary* foundedFilesResultDic;    //多文件检索结果字典，值为找到关键字的第一页，key为书名
@property (nonatomic,retain)NSMutableArray* scannerList;                   //扫描器队列
@property (nonatomic,retain)NSString* keyword;
@property (nonatomic,retain)NSMutableArray* chapterScannerArray;           //章节扫器队列
@property (nonatomic,retain) SearchResultListViewController* searchResultListViewController;
@end


@implementation PDFDocumentsViewController

@synthesize delegate;

@synthesize searchDisplayController;
@synthesize filteredListContent;
@synthesize savedSearchTerm;
@synthesize savedScopeButtonIndex;
@synthesize searchWasActive;
@synthesize searchDocmentsList;
@synthesize searchBar;
@synthesize searchResultCacheDic;
@synthesize foundedFiles;
@synthesize foundedFilesResultDic;
@synthesize scannerList;
@synthesize chapterScannerArray;
@synthesize searchResultListViewController;
@synthesize keyword;

//added by Joy Zeng 2012/9/13
@synthesize documents;
@synthesize urlsByName;
@synthesize bookType;
//end added

-(id) initWithStyle:(UITableViewStyle)style
{
    if (self==[super initWithStyle:style]) {


        self.searchDocmentsList=[NSMutableArray array];
        self.searchResultCacheDic=[NSMutableDictionary dictionary];
        self.scannerList=[NSMutableArray array];
        self.foundedFiles=[NSMutableArray array];
        self.foundedFilesResultDic=[NSMutableDictionary dictionary];
        self.chapterScannerArray=[NSMutableArray array];
        
        UISearchBar* asearchBar=[[UISearchBar alloc]init];
        [asearchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"书名检索",@"全文检索", nil]];
        asearchBar.delegate=self;
        
        //更改键盘式样
        for (UIView *searchBarSubview in [asearchBar subviews]) {
            if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
                @try {
                    // set style of keyboard
                    [(UITextField *)searchBarSubview setEnablesReturnKeyAutomatically:YES];
                    
                }
                @catch (NSException * e) {
                    // ignore exception
                }
            }
        }
        
        
        //添加阴影
        CGRect shadowRect = asearchBar.bounds;
        shadowRect.origin.y += 44;//shadowRect.size.height;
        shadowRect.size.height = 4.0f;
        UIXToolbarShadow *shadowView = [[UIXToolbarShadow alloc] initWithFrame:shadowRect];
        [asearchBar addSubview:shadowView];
        [shadowView release];
        self.searchBar=asearchBar;
        [asearchBar release];
        
        
        UISearchDisplayController* aSearchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:[self searchBar] contentsController:self];
        
        [aSearchDisplayController setValue:[NSNumber numberWithInt:UITableViewStyleGrouped]
                                   forKey:@"_searchResultsTableViewStyle"];
        //searchDisplayController.searchBar.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        aSearchDisplayController.delegate=self;
        aSearchDisplayController.searchResultsDataSource=self;
        aSearchDisplayController.searchResultsDelegate=self;

        self.searchDisplayController=aSearchDisplayController;
        [aSearchDisplayController release];
        
        
        
        SearchResultListViewController* aController=[[SearchResultListViewController alloc]init];
        aController.delegate=self;
        self.searchResultListViewController=aController;
        [aController release];
        
    }
    return self;
    
}






- (void)loadDocuments
{
     //取Bundle下pdf文件URL
//	NSArray *bundledResources = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"pdf" subdirectory:nil];
//     
    NSMutableArray *names = [NSMutableArray array];

    NSArray *allBooks = nil;
    
    if(bookType){
        
        allBooks = [Ebook findByType:bookType];
    
    }else{
        allBooks  = [Ebook findAll];
    }
    
    NSMutableArray* books=[NSMutableArray array];
    
    for (Ebook* book in allBooks) {
        
        
        if (book.url) {
            [names addObject:[book.bookName stringByDeletingPathExtension]];
            
           //生成电子书相对路径
            NSURL *bookURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf",book.bookId] isDirectory:NO];
            book.bookURL=bookURL;
            
            [books addObject:book];
            
        }
    }
    
  
    self.documents=books;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
     
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,50, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonForBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = buttonForBack;
    [buttonForBack release];
    
 
    
    UIImage *eBookImage = [UIImage imageNamed: @"RightButtonItem"];
    UIButton *eBookButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,42, 28) ];
    [eBookButton setBackgroundImage:eBookImage forState:UIControlStateNormal];
    [eBookButton setTitle:@"书库" forState:UIControlStateNormal];
    [eBookButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [eBookButton.titleLabel setShadowColor:[UIColor grayColor]];
    [eBookButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [eBookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [eBookButton addTarget:self action:@selector(bookStore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *eBookItem = [[UIBarButtonItem alloc] initWithCustomView:eBookButton];
    [eBookButton release];
    self.navigationItem.rightBarButtonItem = eBookItem;
    [eBookItem release];
    
    
    [[self searchBar] setFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView=[self searchBar];
    
    [self loadDocuments];
    
    
    // create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[documents count]];
    [ self.tableView reloadData];
    
	self.tableView.scrollEnabled = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addDatas:)
                                                 name:@"AddDataNotif"
                                               object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadEbookDone:) name:PDF_DOWNLOAD_DONE_NOTIFICATION object:nil];
  
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddDataNotif" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PDF_DOWNLOAD_DONE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scanningScanner" object:nil];
}

-(void)downloadEbookDone:(NSNotification *) notification{
    
    [self loadDocuments];
    [self.tableView reloadData];
}

-(void)scanningScanner:(NSNotification*)notification{
    if ( self.searchDisplayController.searchBar.selectedScopeButtonIndex==1){
        Scanner* aScanner= [ notification object];
        NSInteger index =[searchDocmentsList indexOfObject:aScanner.ebook];
        PDFDocumentsCheckBoxCell* cell=(PDFDocumentsCheckBoxCell*)[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        
        int currentPageNumber=0;
        int totalPageNumber=0;
        
        int totalChapterNumber=0;
        int currentChapterNumber=0;
        
        if ([self.searchDocmentsList containsObject:aScanner.ebook]) {
            
            
//            if (aScanner.ebook.chapters.count>0) {
            if (false) {
                currentPageNumber=aScanner.currentPageNumber;
                totalPageNumber=[[notification.userInfo objectForKey:@"numberOfPage"] intValue];
            
                totalChapterNumber=aScanner.ebook.chapters.count;
                currentChapterNumber=[[notification.userInfo objectForKey:@"chapterNumber"] intValue];
            }else{
            
                currentPageNumber=aScanner.currentPageNumber;
                totalPageNumber=[[notification.userInfo objectForKey:@"numberOfPage"] intValue];
                
                totalChapterNumber=aScanner.ebook.chapters.count;
                currentChapterNumber=[[notification.userInfo objectForKey:@"chapterNumber"] intValue];
            
            }
        
            cell.progressLabel.text=[NSString stringWithFormat:@"正在搜索...    %i/%i页",currentPageNumber,totalPageNumber];
            
        }
    }
   
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanningScanner:) name:@"scanningScanner" object:nil];
     
    [self loadDocuments];
    
    UIImageView* imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        } else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    }else{
        imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    self.tableView.backgroundView = imageView;
    [imageView release];
  
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    UIImageView* imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }else{
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }
        self.tableView.backgroundView = imageView;
        [imageView release];
        return YES;
    }else{
        imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
        self.tableView.backgroundView = imageView;
        [imageView release];
        return NO;
    }
}

-(void)segmentAction:(id)sender{
    
    selectedSegmentIndex=[(UISegmentedControl*)sender selectedSegmentIndex];
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//跳转到书库
-(void)bookStore:(id)sender{
        
    NewPDFDownloadListViewController *downloadController = [[NewPDFDownloadListViewController alloc] initWithNib];
    downloadController.bookType = bookType;
    [self.navigationController pushViewController:downloadController animated:YES];
    [downloadController release];
}


#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
     return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        
        if (self.searchDisplayController.searchBar.selectedScopeButtonIndex==1) {
            
           if(foundedFiles.count>0){
                return [foundedFiles count];
            }else{
               return [documents count]; 
            }
            
        }else{
            
            if (self.filteredListContent.count>0) {
                return self.filteredListContent.count;
            }else{
                return self.documents.count;
            }
            
           
        
        }
        
    }
	else
	{
        return [documents count];
    }
    
    return 0;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
    static NSString *CheckBoxCellIdentifier = @"CheckBoxCellIdentifier";
    
     NSString *title=nil;
    //全文搜索状态下
    if (tableView == self.searchDisplayController.searchResultsTableView&&self.searchDisplayController.searchBar.selectedScopeButtonIndex==1)    {
        
        PDFDocumentsCheckBoxCell *cell = (PDFDocumentsCheckBoxCell*)[tableView dequeueReusableCellWithIdentifier:CheckBoxCellIdentifier];
        if (cell == nil) {
            cell = [[[PDFDocumentsCheckBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CheckBoxCellIdentifier] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.delegate=self;
        }
        
        cell.isChecked=NO;
        
        Ebook* aBook = [documents objectAtIndex:indexPath.row];
        cell.aEbook=aBook;
        //多文件搜索有结果的行状态
        if (foundedFiles.count>0 ) {
            Ebook* aBook = [foundedFiles objectAtIndex:indexPath.row];
            title=[aBook.bookName stringByDeletingPathExtension];
            
            if ([[foundedFilesResultDic allKeys] containsObject:aBook.bookId]) {
                cell.isFound=YES;
            }else{
                cell.isNotFound=YES;
            }
            
            
        }else{
        //未开始多文件搜索时行的状态
        
        
        title=aBook.bookName;
        cell.isChecked=NO;
        cell.isFound=NO;        
        
    }
    
     cell.bookTitleLabel.text = title;

    
    //added by Joy Zeng 2012/9/25
    //读取文件对应的标记,若标记非空，表示已读，设置已读图片
    NSString *readFlag = [[NSUserDefaults standardUserDefaults] valueForKey:title];
    UIImage* cellimage;
    if ([readFlag isEqualToString:@"YES"]) {
        cellimage = [UIImage imageNamed:@"Icon_ReadedBook"];
    }
    //若标记为空，设置未读图片
    else {
        cellimage = [UIImage imageNamed:@"Icon_NewBook"];
    }
    
    // [cell prepareForTableView:tableView indexPath:indexPath];
    // cell.cornerRadius = 10;
    

    cell.bookImageView.image=cellimage;
    

    
    return cell;
    
    }
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            
        }
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell.textLabel setTextColor:[UIColor colorWithRed:27.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.0]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        
        
        if (tableView == self.searchDisplayController.searchResultsTableView&&self.searchDisplayController.searchBar.selectedScopeButtonIndex==0 ){
            
            
            if (self.filteredListContent.count>0) {
                Ebook* aBook  = [self.filteredListContent objectAtIndex:indexPath.row];
                title=aBook.bookName;

            }else{
                Ebook* aBook  = [self.documents objectAtIndex:indexPath.row];
                title=aBook.bookName;

            }

                         
            
        }else{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
             Ebook* aBook = [documents objectAtIndex:indexPath.row];

            title=aBook.bookName;
        }

        
        cell.textLabel.text = title;
        // cell.detailTextLabel.text = [[urlsByName objectForKey:title] relativePath];
        
        //added by Joy Zeng 2012/9/25
        //读取文件对应的标记,若标记非空，表示已读，设置已读图片
        NSString *readFlag = [[NSUserDefaults standardUserDefaults] valueForKey:title];
        UIImage* cellimage;
        if ([readFlag isEqualToString:@"YES"]) {
            cellimage = [UIImage imageNamed:@"Icon_ReadedBook"];
        }
        //若标记为空，设置未读图片
        else {
            cellimage = [UIImage imageNamed:@"Icon_NewBook"];
        }
        
        // [cell prepareForTableView:tableView indexPath:indexPath];
        // cell.cornerRadius = 10;
        
        CGSize itemSize = CGSizeMake(53 , 40);
        UIGraphicsBeginImageContext(itemSize);
        [cellimage drawInRect:CGRectMake(17,0,33,40 )];
        cellimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.imageView.image=cellimage;
        
        
        //end added
        
        return cell;
         
    }
        
     
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title=nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView )
	{
             
        if (self.searchDisplayController.searchBar.selectedScopeButtonIndex==0) {
            
             Ebook* aBook ;
            if (filteredListContent.count>0) {
                aBook = [filteredListContent objectAtIndex:indexPath.row];
                
            }else{
                aBook = [documents objectAtIndex:indexPath.row];
              
            }
            
            
            [self readedFlagWithTitle:aBook.bookName];

            if (false) {
                
                PDFChatperViewController* aPDFChatperViewController=[[PDFChatperViewController alloc]initWithStyle:UITableViewStyleGrouped];
                
                aPDFChatperViewController.ebook=aBook;
                
                [self.navigationController pushViewController:aPDFChatperViewController animated:YES];
                
                [aPDFChatperViewController release];
                
                
            }else{
                 [self didSelectEbook:aBook showPage:0 keyWord:@""];
            }
        
            
        }else{
            
            PDFDocumentsCheckBoxCell* cell=(PDFDocumentsCheckBoxCell*)[tableView cellForRowAtIndexPath:indexPath];
           
            //以cell.accessoryType类型判断是否多文件搜索结果列表
            if (cell.isFound) {
                
               [self stopScan];
                
                Ebook* abook = [foundedFiles objectAtIndex:indexPath.row];
                title=abook.bookName;
                //标识已读，换图标
                [self readedFlagWithTitle:title];
                
                SearchResultListViewController* aController=[[SearchResultListViewController alloc]init];
                aController.delegate=self;
                self.searchResultListViewController=aController;
                [aController release];
                
                self.searchResultListViewController.eBook=abook;
                self.searchResultListViewController.searchBar.text=self.searchDisplayController.searchBar.text;
                self.searchResultListViewController.title=title;
                //取首次出现关键字的页码
     
                [self.navigationController pushViewController:self.searchResultListViewController animated:YES];
                
                NSInteger  page=[(Selection*)[abook.selections lastObject] pageNumber];
                [self.searchResultListViewController startScanFromPage:page WithKeyWord:self.searchDisplayController.searchBar.text];

                
                
            }else{
                
              
            }
            
            
        }
        
        
        
    }
    else{
        
        Ebook* aBook = [documents objectAtIndex:indexPath.row];
        //标识已打开过
        [self readedFlagWithTitle:aBook.bookName];
         
        //wood
        PDFChatperViewController* aPDFChatperViewController=[[PDFChatperViewController alloc]initWithStyle:UITableViewStyleGrouped];
        NSMutableArray *outLines = [[PDFOutlineUtil sharedPDFOutlineUtil] getOutlinesWithBookID:aBook.bookId];
        if ((outLines && [outLines count] > 0)) {

            if (false) {
                aPDFChatperViewController.outLinesFlag = @"none";
            }else if(outLines && [outLines count] > 0){
                aPDFChatperViewController.outLinesFlag = @"first";
                aPDFChatperViewController.outLinesArray = outLines;
            }
            aPDFChatperViewController.ebook=aBook;
            [self.navigationController pushViewController:aPDFChatperViewController animated:YES];
            
        }else{
            [self didSelectEbook:aBook showPage:0 keyWord:@""];
        }
        
        [aPDFChatperViewController release];
        
    }
	
    
	
    
    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48.0;
}

// 横向滑动删除已下载电子书功能
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView!=self.searchDisplayController.searchResultsTableView) {
        return UITableViewCellEditingStyleDelete;
    }
	return UITableViewCellEditingStyleNone;
}

// 点击删除按钮后, 会触发如下事件. 在该事件中做响应动作就可以了
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    
    Ebook *ebook = [documents objectAtIndex:indexPath.row];
    [self removeEBook:ebook];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:ebook.url error:&error];
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:ebook.bookName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadDocuments];
    [self.tableView reloadData];
}

- (void)removeEBook:(Ebook *)ebook{
    
    NSString *basePath = [[NewEbookQuery sharedNewEbookQuery] getDownloadDirectory];
    
    NSError *error = nil;
    NSArray *array = [Ebook findByBookID:ebook.bookId];
    if (array && [array count] > 0) {
        Ebook *book = [array objectAtIndex:0];

        if (false) {
            for (Chapter *chapter in book.chapters) {
                NSString *chapterPath = [NSString stringWithFormat:@"%@/%@.%@",basePath,chapter.chapterId,@"pdf"];
                [[NSFileManager defaultManager] removeItemAtPath:chapterPath error:&error];
            }
        }else{
            [[NSFileManager defaultManager] removeItemAtPath:ebook.url error:&error];
        }
    }
    
    [ebook remove];
    
    //删除缓存
    NSString* libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* asPath = [libPath stringByAppendingFormat:@"/Application Support/%@.plist",ebook.bookId];
    [[NSFileManager defaultManager] removeItemAtPath:asPath error:&error];


}


-(void)readedFlagWithTitle:(NSString*)title{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"YES" forKey:title];
    [defaults synchronize];
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}


- (void)didSelectEbook:(Ebook *)ebook showPage:(NSUInteger)page keyWord:(NSString*)aKeyWord;
{
    
    
    //以下是没有章节的文档直接打开
    
     UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"错误" message:@"由于网络问题，文件已损坏，请从书库中重新下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease];
    
    
    ReaderDocument *pdfDocument;
    @try {
        
        NSURL* url=nil;
//        if (ebook.chapters.count >0){
        if (false){
            
          
            Chapter* chapter= [[ebook.selections lastObject] chapter];
                    url =[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", chapter.chapterId ]isDirectory:NO];
                    pdfDocument = [ReaderDocument withDocumentFilePath:[url path ]password:nil];
            pdfDocument.PDFName = chapter.bookName;
            
            
            
        }else{
            url=ebook.bookURL;
           pdfDocument = [ReaderDocument withDocumentFilePath:[url path] password:nil];
            pdfDocument.PDFName = ebook.bookName;
        }
    
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [ alert show];
            return;
        }
        
        CGPDFDocumentRef pdf=  CGPDFDocumentCreateWithURL((CFURLRef)url);
        if (pdf==nil) {
            [ alert show];
            CGPDFDocumentRelease(pdf);
            return;
        }else{
             CGPDFDocumentRelease(pdf);
        }
        
        if (pdfDocument != nil) {
            ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:pdfDocument];
            readerViewController.delegate = self;
            readerViewController.ebook=ebook;
            readerViewController.hidesBottomBarWhenPushed = YES;
            readerViewController.searchButton=YES;
            if ([searchDisplayController isActive]) {
                [searchDisplayController setActive:NO animated:NO];
            }
            
            [self.navigationController pushViewController:readerViewController animated:YES];
            
            
            readerViewController.keyword=aKeyWord;
            
            if (page>0) {
                [readerViewController showDocumentPage:page];
            }
            
            readerViewController.hidesBottomBarWhenPushed = NO;//保证pop之后能显示出来
            [readerViewController release];
            
            [self stopScan];
            
        } else {
            
            [alert show];
            return;
        }
        
       
    }
    @catch (NSException *exception) {
       
        [alert show];
        return;
    }
    @finally {
        
    }
    
    
}








#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods


- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    

    // add the tableview back in    
    UIImageView *imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }else{
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    }else{
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    
    self.searchDisplayController.searchResultsTableView.backgroundView = imageView;
    
    [imageView release];
}



- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    
}
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    
    // add the tableview back in
//    
    UIImageView *imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }else{
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    }else{
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    
    [self.view addSubview:self.searchDisplayController.searchResultsTableView];
   
    self.searchDisplayController.searchResultsTableView.backgroundView = imageView;
    [imageView release];
 
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self stopScan];
    //如果searchBar的文字有变化，并且是点选全文检索的状态下，停止全文检索
    if (controller.searchBar.selectedScopeButtonIndex==1 ) {
        
        
        
        if (searchString.length==0) {
            [searchDocmentsList removeAllObjects];
            [foundedFilesResultDic removeAllObjects];
            [foundedFiles removeAllObjects];
            return YES;
        }
      
        return NO;
    }else{
        [self filterContentForSearchText:searchString scope:
         [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        // Return YES to cause the search result table view to be reloaded.
        
               
        return YES;
    }
    
   
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self stopScan];

    
    if (searchOption==0) {
        [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
         [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
        
        for (Ebook* abook in searchDocmentsList) {
            NSInteger index =[searchDocmentsList indexOfObject:abook];
            PDFDocumentsCheckBoxCell* cell=(PDFDocumentsCheckBoxCell*)[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell spinnerStopAnimating];
            
            cell.progressLabel.text=@"";
        }

       
    }else{
        
       
        
        
    }
    return YES;
   
    
    
}

#pragma mark -
#pragma mark Content Filtering
//电子书名筛选
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredListContent removeAllObjects];
    
    if ([scope isEqualToString:@"书名检索"] && [searchText length] >0) {
        
        for (Ebook *aBook in documents)
        {
            
            //NSComparisonResult result = [name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            
            if ([aBook.bookName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [self.filteredListContent addObject:aBook];
            }
            
        }
    }
    
}


#pragma mark -
#pragma mark UISearchBar Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    
    [self stopScan];




}
- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar{
    
    [self stopScan];
    [searchDocmentsList removeAllObjects];
    [foundedFilesResultDic removeAllObjects];
    [selectedCellIndexes removeAllObjects];
    [foundedFiles removeAllObjects];
    
   
    
}

-(void)stopScan{
    
    stopScan=YES;
    for (Scanner *aScanner in self.scannerList) {
        [aScanner stopScan];
    }
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar{
    
    if (self.searchDisplayController.searchBar.selectedScopeButtonIndex==1) {
    
        if (searchDocmentsList.count==0) {
            
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"请选择搜索的PDF" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
            [alert show];
            [alert release];
            isFoundFile=NO;
            return;
        }
        
        if (isScanning) {
            
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"重复操作，请先取消当前搜索！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
            [alert show];
            [alert release];
            isFoundFile=NO;
            return;
            
        }
        
        

             
        self.keyword=asearchBar.text;
        [scannerList removeAllObjects];
        [foundedFiles  removeAllObjects];
        [foundedFilesResultDic removeAllObjects];
        [foundedFiles addObjectsFromArray:searchDocmentsList];
        [self.searchDisplayController.searchResultsTableView reloadData];
        
        NSArray* copySearchDocmentsList=[NSArray arrayWithArray: self.searchDocmentsList];
        
        for (Ebook* abook in copySearchDocmentsList) {
            NSInteger index =[searchDocmentsList indexOfObject:abook];
            PDFDocumentsCheckBoxCell* cell=(PDFDocumentsCheckBoxCell*)[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell spinnerStartAnimating];
            
            
        }
        
        __block NSMutableArray* scanList=self.scannerList;
        stopScan=NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
        dispatch_group_t group=dispatch_group_create();   
           
           
            dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            
                for (Ebook* abook in copySearchDocmentsList) {
                   
                    if (stopScan==YES) {
                        break;
                    }
                    Scanner* aScanner=[[Scanner alloc]init];
                    aScanner.delegate=self;
                    aScanner.keyword=self.keyword;
                    [scanList addObject:aScanner];
                    [aScanner scanEbook:abook]; 
                     [aScanner release];
                }
            
                });
        
        
        dispatch_release(group);
            
        });
       


    }

}

#pragma mark NSNotification Delegate

- (void)addDatas:(NSNotification *)notif {
    
    assert([NSThread isMainThread]);

    
}



#pragma mark ReaderViewController Delegate

- (void)dismissReaderViewController:(ReaderViewController *)viewController{
    
    if (viewController.navigationController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        [self.foundedFiles removeAllObjects];
        [self.searchDocmentsList removeAllObjects];
        [self.foundedFilesResultDic removeAllObjects];
        //[self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
}


#pragma mark  SearchResultListViewController Delegate

-(void)didSelectedSelection:(Selection*)selection Keyword:(NSString*)akeyword{
    
    //以下是没有章节的文档直接打开
    
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"错误" message:@"由于网络问题，文件已损坏，请从书库中重新下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease];
    
    
    ReaderDocument *pdfDocument;
    @try {
        
        if (selection.chapter){
            
            
                    NSURL* url=[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"download/%@.pdf", selection.chapter.chapterId ]isDirectory:NO];
                    pdfDocument = [ReaderDocument withDocumentFilePath:[url path ]password:nil];
                
            
            
        }else{
            pdfDocument = [ReaderDocument withDocumentFilePath:[selection.ebook.bookURL path] password:nil];
        }
        
        
    }
    @catch (NSException *exception) {
        
        [alert show];
        return;
    }
    @finally {
        
    }
    if (pdfDocument != nil) {
        
        ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:pdfDocument];
        readerViewController.delegate = self;
        readerViewController.ebook=selection.ebook;
        readerViewController.searchButton=NO;
        readerViewController.searchResultListViewController=nil;
        readerViewController.hidesBottomBarWhenPushed = YES;

        
        if ([searchDisplayController isActive]) {
            [searchDisplayController setActive:NO animated:NO];
        }
        
        [self.navigationController pushViewController:readerViewController animated:YES];
        
        
        readerViewController.keyword=akeyword;
        
        if (selection.pageNumber>0) {
            [readerViewController showDocumentPage:selection.pageNumber];
        }
        
        readerViewController.hidesBottomBarWhenPushed = NO;//保证pop之后能显示出来
        [readerViewController release];
        
        [self stopScan];

        
    } else {
        
        [alert show];
        return;
    }

      
}

#pragma mark -
#pragma mark CELL Delegate

-(void)didClickCheckBoxButton:(UIButton *)button bookTitle:(NSString *)title Check:(BOOL)isCheck{
 
     
}


-(void)didClickCheckBoxButton:(UIButton *)button ebook:(Ebook *)aEbook Check:(BOOL)isCheck{
    
    if (isCheck) {
        
        if (![searchDocmentsList containsObject:aEbook]) {
            
            [searchDocmentsList addObject:aEbook];
        }
        
    }else{
        [searchDocmentsList removeObject:aEbook];
    }
    

}

#pragma mark -
#pragma mark Scanner Delegate

-(void)Scanner:(Scanner *)scanner DidScanFinishEbook:(Ebook *)ebook{
    //如果全文搜完都没有结果
    
    
    if (ebook.selections.count==0&&self.searchDisplayController.searchBar.selectedScopeButtonIndex==1) {
        
        NSInteger index =[searchDocmentsList indexOfObject:ebook];
        PDFDocumentsCheckBoxCell*  cell=(PDFDocumentsCheckBoxCell*)[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell spinnerStopAnimating];
        cell.isNotFound=YES;
        cell.progressLabel.text=@"";

    }
    
     [HUD hide:YES];
   
    
}



-(void)Scanner:(Scanner *)aScanner DidFinishScanEbook:(Ebook *)ebook chapter:(Chapter *)chapter atPageNumber:(NSInteger)pageNumber selections:(NSArray *)selections{
    
    NSInteger index =[searchDocmentsList indexOfObject:ebook];
    PDFDocumentsCheckBoxCell*  cell=(PDFDocumentsCheckBoxCell*)[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];;
    [cell spinnerStopAnimating];
    if (ebook.selections.count>0) {
        cell.isFound=YES;
        [self.foundedFilesResultDic setObject:ebook forKey:ebook.bookId];
        cell.progressLabel.text=@"";
        
    }

    [aScanner stopScan];
}


#pragma mark -
#pragma mark MBProgressHUD methods

- (void)showWithLabelMixed:(id)sender {
    
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
     UIButton *cancelButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    [cancelButton setTitle:@"点击此处停止搜索" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15] ];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    HUD.customButton= cancelButton;
    [cancelButton release];

    HUD.dimBackground=YES;
    [self.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"正在搜索...";
	HUD.minSize = CGSizeMake(135.f, 135.f);
    [HUD show:YES];
  
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [HUD removeFromSuperview];
    
	HUD = nil;
}

-(void)cancel:(id)sender{
    
   // [scanner stopScan];
    HUD.hidden=YES;
    
}

#pragma mark Memory Management

- (void)dealloc
{
	[foundedFiles release];
    [foundedFilesResultDic release];
	[documents release];
    [urlsByName release];
    [filteredListContent release];
    [savedSearchTerm release];
    [searchDocmentsList release];
    [searchBar release];
    [searchResultCacheDic release];
    [scannerList release];
    [searchDisplayController release];
    [selectedCellIndexes release];
    [resultCellIndexes release];
    [chapterScannerArray release];
    [keyword release];
    [scanner release];
    [searchResultListViewController release];
	[super dealloc];
}


@end
