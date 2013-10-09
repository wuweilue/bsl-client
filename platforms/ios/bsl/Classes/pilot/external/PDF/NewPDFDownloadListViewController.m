//
//  NewPDFDownloadListViewController.m
//  pilot
//
//  Created by wuzheng on 13-3-14.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "NewPDFDownloadListViewController.h"
#import "MBProgressController.h"
#import "NetworkConfig.h"

@interface NewPDFDownloadListViewController ()

@end

@implementation NewPDFDownloadListViewController
@synthesize bookType;
@synthesize displayBookList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    [refreshButton addTarget:self action:@selector(getBookList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    [self.myTableView setBackgroundColor:[UIColor clearColor]];
    [self.myTableView setBackgroundView:[[[UIView alloc] init] autorelease]];
    
    if (!ebookService) {
        ebookService = [NewEbookQuery sharedNewEbookQuery];
    }
  
    [self getBookList];
    self.myTableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDone:) name:PDF_DOWNLOAD_FINISH_NOTIFICATION object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    if (device_Type == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            self.bgImageView.image=[UIImage imageNamed:@"Background_1024X768.png"];
        }else{
            self.bgImageView.image=[UIImage imageNamed:@"Background_768X1024.png"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myTableView release];
    [bookType release];
    [displayBookList release];
    [_bgImageView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [self setBgImageView:nil];
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PDF_DOWNLOAD_FINISH_NOTIFICATION object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    }else{
        return interfaceOrientation == UIImageOrientationDown;
    }
}

#pragma mark - UITableView delegate
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [displayBookList count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PDFDownloadViewCell";
    
    NewPDFDownloadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ([[ebookService requestDic] objectForKey:cell.aBook.bookId]) {
        [ebookService disconnectDelegateWithBookID:cell.aBook.bookId];
    }
    if (cell == nil) {
        if (device_Type == UIUserInterfaceIdiomPad) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewPDFDownloadViewCell_Pad" owner:nil options:nil] objectAtIndex:0];
        }else if(device_Type == UIUserInterfaceIdiomPhone){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NewPDFDownloadViewCell_Phone" owner:nil options:nil] objectAtIndex:0];
        }
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    Ebook *aBook = [displayBookList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [aBook.bookName stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.groupView.hidden = YES;
    cell.aBook = aBook;
    // 不再按章节手动拆分电子书
//    if (aBook.chapters && [aBook.chapters count] > 0) {
    if (false) {
        cell.fileType = @"zip";
    }else{
        cell.fileType = @"pdf";
    }
    
    if (aBook.bookId) {
        ASIHTTPRequest *bookRequest = [[ebookService requestDic] objectForKey:aBook.bookId];
        if (bookRequest) {
            //正在下载状态
            [cell configDownloadingStatus];
            
            if (![bookRequest isCancelled]){
                [cell.startBottun setTitle:@"S" forState:UIControlStateNormal];
                [cell.startBottun setImage:[UIImage imageNamed:@"button-pause"] forState:UIControlStateNormal];
                [ebookService connectDelegateWithBookID:cell.aBook.bookId object:cell];
            }else if([bookRequest isCancelled]) {
                cell.speedLabel.text = @"";
            }
            
        }else if(aBook.url){
            //下载完成状态
            cell.groupView.hidden = YES;
            cell.titleLabel.textColor = [UIColor grayColor];
            cell.flagImg.image = [UIImage imageNamed:@"downloaded"];
        }else if (bookRequest == nil && [[NSUserDefaults standardUserDefaults] objectForKey:aBook.bookId]) {
            //退出应用前有暂停任务状态
            //如果退出应用前有正在暂停的任务，则获取之前任务的状态并显示
            [cell configDownloadingStatus];
            cell.speedLabel.text = @"";
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)getBookList{
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController setSafeConnet];
    [MBProgressController startQueryProcess];
    
    [ebookService synchronousBookListWithType:bookType completion:^(NSMutableArray *booklist) {
        
        [MBProgressController dismiss];
        if(displayBookList){
            [displayBookList release];
        }
        displayBookList = [booklist mutableCopy];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bookName" ascending:YES];
        
        [displayBookList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        
        [self.myTableView reloadData];
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
    } failed:^(NSString *failedStr) {
        
        [MBProgressController dismiss];
        NSLog(@"-----------%@-------",failedStr);

    }];

}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)downloadDone:(NSNotification *)notification{
    
    Ebook *book = (Ebook *)[notification object];
    
    [displayBookList removeObject:book];
    
    [[self myTableView] reloadData];
}

#pragma mark - DownloadCell delegate
//下载、暂停和取消操作
- (void)didClickedButtonInCellWithBookID:(NSString *)bookID andCell:(NewPDFDownloadViewCell *)cell andTag:(NSInteger)tag{
    
    if ([cell.downLoadStatus isEqualToString:PDF_DOWNLOAD_START]) {
        
        //注意：cell.aBook和cell进入block后会有一个对象快照，当block外cell释放后会有问题出现；
         [ebookService downLoadBookWithBook:cell.aBook withCell:cell completion:^(Ebook *book) {
            //下载完成后做相应的通知和清除处理
            [[NSNotificationCenter defaultCenter] postNotificationName:PDF_DOWNLOAD_FINISH_NOTIFICATION object:book];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:bookID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } failed:^(NSString *result) {
            
            NSString *alertMSG=@"下载失败，请重新下载";;
            if ([@"FAILED" isEqualToString:result]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:bookID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [cell finishDownLoadAnimations];
               
            }            
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMSG delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
            
        }];
        
    }else if ([cell.downLoadStatus isEqualToString:PDF_DOWNLOAD_CANCEL]) {
        [ebookService cancelBookRequestWithBookID:bookID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:bookID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //取消下载时删除临时文件
        [self removeTemporaryFileWithBookID:bookID];
        
    }else if([cell.downLoadStatus isEqualToString:PDF_DOWNLOAD_PAUSE]){
        [ebookService pauseBookRequestWithBookID:bookID];
    }
}



//删除下载的临时文件
- (void)removeTemporaryFileWithBookID:(NSString *)bookID{
    NSString *tmpFileDirectory = [ebookService getDownloadDirectory];
    NSString *pdfTmpFilePath = [NSString stringWithFormat:@"%@/%@%@",tmpFileDirectory,bookID,@".pdf.download"];
//    NSString *zipTmpFilePath = [NSString stringWithFormat:@"%@/%@%@",tmpFileDirectory,bookID,@".zip.download"];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:pdfTmpFilePath error:&error];
//    [[NSFileManager defaultManager] removeItemAtPath:zipTmpFilePath error:&error];
}

@end
