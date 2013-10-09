//
//  NewPDFDownloadListViewController.h
//  pilot
//
//  Created by wuzheng on 13-3-14.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewEbookQuery.h"
#import "NewPDFDownloadViewCell.h"
#import "Ebook.h"

static NSString *PDF_DOWNLOAD_FINISH_NOTIFICATION = @"pdf_download_done_notification";

@interface NewPDFDownloadListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PDFDownloadViewCellDelegate>{
    NSString                            *bookType;
    NSMutableArray                      *displayBookList;
    NewEbookQuery                       *ebookService;
}

@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) NSString *bookType;
@property (nonatomic, retain) NSMutableArray *displayBookList;

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@end
