//
//  PDFDownloadListViewController.h
//  pilot
//
//  Created by chen shaomou on 9/20/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFDownloadViewCell.h"


static NSString *PDF_DOWNLOAD_DONE_NOTIFICATION = @"pdf_download_done_notification";

@interface PDFDownloadListViewController : UITableViewController{

    NSMutableArray *displayBookList;
    NSMutableDictionary *cellDict;
    NSString *type;
}

@property(nonatomic,retain)  NSMutableArray *displayBookList;
@property(nonatomic,retain)  NSMutableDictionary *cellDict;
@property(nonatomic,retain)  NSString *type;

@end
