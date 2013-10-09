//
//  PDFOutlineUtil.h
//  pilot
//
//  Created by wuzheng on 13-3-26.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFOutlineUtil : NSObject

+(PDFOutlineUtil *)sharedPDFOutlineUtil;

- (NSMutableArray *)getOutlinesWithBookID:(NSString *)bookID;

@end
