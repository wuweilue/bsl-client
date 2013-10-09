//
//  FileOperation.h
//  pilot
//
//  Created by leichunfeng on 13-3-20.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOperation : NSObject

/**
 *	@brief	解压zip文件
 *
 *	@param 	zipFilePath 	zip文件的全路径
 *	@param 	filePath 	解压到的目录
 */
+ (void)decompressionDocument:(NSString *)zipFilePath UnzipFileTo:(NSString *)filePath;

/**
 *	@brief	删除文件
 *
 *	@param 	url 	文件的全路径
 */
+ (void)removeDocument:(NSString *)url;

@end
