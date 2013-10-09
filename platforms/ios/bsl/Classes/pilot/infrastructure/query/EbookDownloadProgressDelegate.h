//
//  EbookDownloadProgressDelegate.h
//  pilot
//
//  Created by chen shaomou on 10/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIProgressDelegate.h"

@protocol EbookDownloadProgressDelegate <ASIProgressDelegate>

-(void)downloadSuccess;

-(void)downloadFailed;

-(void)downloadCancel;

@end
