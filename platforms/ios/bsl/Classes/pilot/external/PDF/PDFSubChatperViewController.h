//
//  PDFSubChatperViewController.h
//  pilot
//
//  Created by wuzheng on 13-4-1.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "Ebook.h"

@interface PDFSubChatperViewController : UITableViewController<ReaderViewControllerDelegate>

@property(nonatomic,retain)Ebook* ebook;

@property (nonatomic, retain) NSString *outLinesFlag;

@property (nonatomic, retain) NSMutableArray *outLinesArray;

@end
