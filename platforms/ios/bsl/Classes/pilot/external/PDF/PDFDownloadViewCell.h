//
//  PDFDownloadViewCell.h
//  pilot
//
//  Created by chen shaomou on 9/20/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EbookQuery.h"
#import "EbookDownloadProgressDelegate.h"


@interface PDFDownloadViewCell : UITableViewCell <EbookDownloadProgressDelegate>

@property (nonatomic,retain) IBOutlet UILabel *titleLable;
@property (nonatomic,retain) IBOutlet UIProgressView *progressView;
@property (nonatomic,retain) IBOutlet UILabel *speedLable;
@property (nonatomic,retain) IBOutlet UIButton *controlButton;
@property (nonatomic,assign) BOOL isReload;

+(PDFDownloadViewCell *)getInstance;

@end
