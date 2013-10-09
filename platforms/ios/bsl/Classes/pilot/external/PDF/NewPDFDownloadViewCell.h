//
//  NewPDFDownloadViewCell.h
//  pilot
//
//  Created by wuzheng on 13-3-14.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ebook.h"
#import "ASIProgressDelegate.h"

@class NewPDFDownloadViewCell;
@protocol PDFDownloadViewCellDelegate <NSObject>

-(void)didClickedButtonInCellWithBookID:(NSString *)bookID andCell:(NewPDFDownloadViewCell *)cell andTag:(NSInteger)tag;

@end

@interface NewPDFDownloadViewCell : UITableViewCell<ASIProgressDelegate>{
    BOOL                                    changeFlag;
    NSString                                *downLoadStatus;
    id<PDFDownloadViewCellDelegate>         delegate;
    
    NSMutableDictionary                     *pdfStatus;
    NSString                                *fileType;
}

@property (nonatomic, retain) Ebook *aBook;
@property (nonatomic, assign) id<PDFDownloadViewCellDelegate> delegate;
@property (nonatomic, assign) long long totaleLength;
@property (nonatomic, retain) NSString *downLoadStatus;
@property (nonatomic) BOOL changeFlag;
@property (nonatomic, retain) NSString *fileType;

@property (retain, nonatomic) IBOutlet UIImageView *flagImg;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *sizeLabel;
@property (retain, nonatomic) IBOutlet UILabel *speedLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *myProgressView;
@property (retain, nonatomic) IBOutlet UIButton *startBottun;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIView *groupView;

- (IBAction)didStartClick:(id)sender;
- (IBAction)didCancelClick:(id)sender;

- (void)configDownloadingStatus;
- (void)finishDownLoadAnimations;

@end
