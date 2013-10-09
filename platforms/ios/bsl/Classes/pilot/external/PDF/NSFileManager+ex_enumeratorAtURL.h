//
//  NSFileManager+ex_enumeratorAtURL.h
//  Mcs
//
//  Created by zhengyang xiao on 12-3-12.
//  Copyright (c) 2012年 RYTong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (ex_enumeratorAtURL){
    
}
- (NSEnumerator *)ex_enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *url, NSError *error))handler;
@end
