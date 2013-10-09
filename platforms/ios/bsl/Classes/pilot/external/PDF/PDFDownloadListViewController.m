//
//  PDFDownloadListViewController.m
//  pilot
//
//  Created by chen shaomou on 9/20/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "PDFDownloadListViewController.h"
#import "EbookQuery.h"
#import "PDFDownloadListViewController.h"
#import "GEAlertViewDelegate.h"



@interface PDFDownloadListViewController ()

@end

@implementation PDFDownloadListViewController

@synthesize displayBookList;
@synthesize cellDict;
@synthesize type;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"书库";
    
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
    
    UIImage *image = [UIImage imageNamed:@"BarButtonItem_Refresh"];
    UIButton *refreshButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 30)] autorelease];
    [refreshButton setBackgroundImage:image forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    self.cellDict = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDone:) name:PDF_DOWNLOAD_DONE_NOTIFICATION object:nil];
    
    [self refreshList];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PDF_DOWNLOAD_DONE_NOTIFICATION object:nil];     
}


- (void)dealloc
{
    //移除delegate,避免向以释放对象发送消息
    for(Ebook *each in displayBookList){
        if([[EbookQuery shareInstance] isBookDownloading:each]){
            [[EbookQuery shareInstance] setEbookDownloadDelegate:each downloadProgressDelegate:nil];
        }
    }
    [[EbookQuery shareInstance] cancelAllDownload];
    [cellDict release];
    [type release];
    [displayBookList release];
    [super dealloc];
}

-(void)back:(id)sender{
    
    BOOL hasDownloading = NO;
    
    for(Ebook *each in displayBookList){
        if([[EbookQuery shareInstance] isBookDownloading:each]){
            hasDownloading = YES;
            break;
        }
    }
    
    if(hasDownloading){
        [[GEAlertViewDelegate defaultDelegate] showAlertViewWithTitle:@"" message:@"您有正在下载的电子书，是否后台继续下载" confirmButtonTitle:@"是" cancelButtonTitle:@"否" confirmBlock:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        
        } cancelBlock:^{
            
            [[EbookQuery shareInstance] cancelAllDownload];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        
    
    }else{
         [[EbookQuery shareInstance] cancelAllDownload];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//请求电电子书列表，数据请求完后按书名排序
- (void)refreshList{

    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    EbookQuery *query = [EbookQuery shareInstance];
    
    void (^completionBlock_)(NSMutableArray *) = ^(NSMutableArray *booklist){
    
        if(displayBookList)
            [displayBookList release];
        displayBookList = [booklist mutableCopy];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bookName" ascending:YES];
        
        [displayBookList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        [self orderDisplayBookList:nil];
        
        [[self tableView] reloadData];
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    };
    
    void (^failedBlock_)(NSData *) = ^(NSData *data){
    
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    };
    
    if(type){
        [query queryEbookListByType:type completion:completionBlock_ failed:failedBlock_];
    }else{
        [query queryEbookList:completionBlock_ failed:failedBlock_];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [displayBookList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Ebook *book = [displayBookList objectAtIndex:indexPath.row];
    
    PDFDownloadViewCell *cell = [cellDict objectForKey:book.bookId];
    
    if(cell == nil){
        cell = [PDFDownloadViewCell getInstance];
        [cellDict setValue:cell forKey:book.bookId];
    }
    
    // Configure the cell...

    cell.titleLable.text = [book bookName];
    
    [[EbookQuery shareInstance] setEbookDownloadDelegate:book downloadProgressDelegate:cell];
    
    if([[EbookQuery shareInstance] isBookDownloading:book]){
        
        [cell.controlButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        
        [cell.controlButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.controlButton setTitle:@"取消" forState:UIControlStateNormal];
        
        cell.progressView.hidden = NO;
    
    }else{
        
        [cell.controlButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        
        [cell.controlButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.controlButton setTitle:@"下载" forState:UIControlStateNormal];
        
        cell.progressView.hidden = YES;
        
        if (book.url) {
            cell.isReload=YES;
        }else{
            cell.isReload=NO;
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}

- (void)download:(id)sender {
    
    PDFDownloadViewCell *cell = (PDFDownloadViewCell *)[[sender superview] superview];

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [cell.controlButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    
    [cell.controlButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.progressView.hidden = NO;
    
    UIButton *senderButton = (UIButton *)sender;
    
    [senderButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [[EbookQuery shareInstance] downloadEbook:[displayBookList objectAtIndex:indexPath.row] downloadProgressDelegate:cell completion:^(Ebook *book) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PDF_DOWNLOAD_DONE_NOTIFICATION object:book];
        
    } failed:^(Ebook *book) {
        
        //下载失败,给点提示
        NSLog(@"下载失败 %@",book.bookName);
        
    }];
    
} 

-(void)downloadDone:(NSNotification *) notification{
    
    Ebook *book = (Ebook *)[notification object];
//
//    for(Ebook *each in displayBookList){
//        if([each.bookId isEqualToString:book.bookId]){
//            break;
//        }
//    }
    [self orderDisplayBookList:book];
    
    [[self tableView] reloadData];
}

- (void)cancel:(id)sender{
    
    PDFDownloadViewCell *cell = (PDFDownloadViewCell *)[[sender superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Ebook *book = [displayBookList objectAtIndex:indexPath.row];
    
    [cell.controlButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    
    [cell.controlButton addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    if (book.url) {
        [cell.controlButton setTitle:@"重载" forState:UIControlStateNormal];
    }else{
        [cell.controlButton setTitle:@"下载" forState:UIControlStateNormal];
    }
    
    cell.progressView.hidden = YES;
    
    [[EbookQuery shareInstance] cancelDownloadEbook:book];
//    [[EbookQuery shareInstance] cancelAllDownload];
}

- (void)orderDisplayBookList:(Ebook *)book{
    
    NSMutableArray *needDownLoad = [NSMutableArray array];
    NSMutableArray *downLoaded = [NSMutableArray array];
        
    NSMutableArray *bookListCopy = [NSMutableArray arrayWithArray:displayBookList];
    for(Ebook *each in bookListCopy){
        if ([each url] || (book && [[book bookId] isEqualToString:[each bookId]])) {
            [downLoaded addObject:each];
        }else{
            [needDownLoad addObject:each];
        }
    }
    
    [bookListCopy removeAllObjects];
    [bookListCopy addObjectsFromArray:needDownLoad];
    [bookListCopy addObjectsFromArray:downLoaded];
    displayBookList = [bookListCopy mutableCopy];
    
}

@end
