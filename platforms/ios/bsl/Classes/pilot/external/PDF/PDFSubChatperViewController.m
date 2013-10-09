//
//  PDFSubChatperViewController.m
//  pilot
//
//  Created by wuzheng on 13-4-1.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "PDFSubChatperViewController.h"

@interface PDFSubChatperViewController ()

@end

@implementation PDFSubChatperViewController
@synthesize ebook;
@synthesize outLinesArray;

-(void)dealloc{
    [ebook release];
    [outLinesArray release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"目    录";

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
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    UIImageView* imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }else{
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [outLinesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *title = [[outLinesArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.text = [title stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"错误" message:@"由于网络问题，文件已损坏，请从书库中重新下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease];
    
    NSURL *bookURL = ebook.bookURL;
    
    ReaderDocument *pdfDocument;
    @try {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[bookURL path]]) {
            [ alert show];
            return;
        }
        
        CGPDFDocumentRef pdf=  CGPDFDocumentCreateWithURL((CFURLRef)bookURL);
        if (pdf==nil) {
            [ alert show];
            CGPDFDocumentRelease(pdf);
            return;
        }else{
            CGPDFDocumentRelease(pdf);
        }
        
        
        pdfDocument = [ReaderDocument withDocumentFilePath:[bookURL path] password:nil];
        
        if (pdfDocument != nil) {
            
            ReaderViewController *readerViewController = [[ReaderViewController alloc]initWithReaderDocument:pdfDocument];
            readerViewController.delegate = self;
            readerViewController.ebook=self.ebook;
            readerViewController.searchButton=YES;
            
            readerViewController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:readerViewController animated:YES];
            
            if (outLinesArray && [outLinesArray count] > 0) {
                NSDictionary *outLineDic = [outLinesArray objectAtIndex:indexPath.row];
                NSString *pageStr = [outLineDic objectForKey:@"link"];
                NSInteger page = [pageStr integerValue];
                [readerViewController showDocumentPage:page];
            }
            
            readerViewController.hidesBottomBarWhenPushed = NO;//保证pop之后能显示出来
            [readerViewController release];
            
            
            
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


#pragma mark ReaderViewController Delegate

- (void)dismissReaderViewController:(ReaderViewController *)viewController{
    
    if (viewController.navigationController) {
        [viewController.navigationController popViewControllerAnimated:YES];
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
}

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
        
        readerViewController.hidesBottomBarWhenPushed = YES;
        
        
        [self.navigationController pushViewController:readerViewController animated:YES];
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        readerViewController.keyword=akeyword;
        
        if (selection.pageNumber>0) {
            [readerViewController showDocumentPage:selection.pageNumber];
        }
        
        readerViewController.hidesBottomBarWhenPushed = NO;//保证pop之后能显示出来
        [readerViewController release];
        
        
        
        
    } else {
        
        [alert show];
        return;
    }
    
    
}

@end
