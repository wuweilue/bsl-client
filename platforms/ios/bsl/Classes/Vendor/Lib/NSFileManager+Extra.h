//
//  NSFileManager+Extra.h
//  MobileBrick
//
//  Created by Justin Yip on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FS [NSFileManager defaultManager]

@interface NSFileManager (Extra)

+ (NSURL *)applicationDocumentsDirectory;
+ (NSURL *)wwwRuntimeDirectory;
+ (NSURL *)preInstallModelsDirectory;
+ (NSURL *)wwwBundleDirectory;

- (BOOL)copyFolderAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError **)error;
- (BOOL)copyFolderAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error;
//- (BOOL)removeFolderAtPath:(NSString *)srcPath error:(NSError **)aError;

@end
