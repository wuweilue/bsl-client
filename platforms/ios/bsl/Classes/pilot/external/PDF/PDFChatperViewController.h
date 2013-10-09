//
//  PDFChatperViewController.h
//  pilot
//
//  Created by Sencho Kong on 13-1-30.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "Ebook.h"

@interface PDFChatperViewController : UITableViewController<ReaderViewControllerDelegate>

@property(nonatomic,retain)Ebook* ebook;

@property (nonatomic, retain) NSString *outLinesFlag;

@property (nonatomic, retain) NSMutableArray *outLinesArray;

@end
