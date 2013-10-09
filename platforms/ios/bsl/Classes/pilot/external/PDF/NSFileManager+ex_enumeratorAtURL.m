//
//  NSFileManager+ex_enumeratorAtURL.m
//  Mcs
//
//  Created by zhengyang xiao on 12-3-12.
//  Copyright (c) 2012年 RYTong. All rights reserved.
//

#import "NSFileManager+ex_enumeratorAtURL.h"

@interface CBlockEnumerator : NSEnumerator
@property (readwrite, nonatomic, copy) id (^block)(void);
@end

@implementation NSFileManager (ex_enumeratorAtURL)
- (NSEnumerator *)ex_enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *url, NSError *error))handler;
{
    NSAssert(mask == 0, @"We don't handle masks");
    NSAssert(keys == NULL, @"We don't handle non-null keys");
    
    NSDirectoryEnumerator *theInnerEnumerator = [self enumeratorAtPath:[url path]];
    
    CBlockEnumerator *theEnumerator = [[[CBlockEnumerator alloc] init] autorelease];
    theEnumerator.block = ^id(void) {
        NSString *thePath = [theInnerEnumerator nextObject];
        if (thePath != NULL)
        {
            return([url URLByAppendingPathComponent:thePath]);
        }
        else
        {
            return(NULL);
        }
    };
    
    return(theEnumerator);
}
@end

@implementation CBlockEnumerator

@synthesize block;

- (void)dealloc
{
    [block release];
    block = NULL;
    //
    [super dealloc];
}

- (id)nextObject
{
    id theObject = self.block();
    return(theObject);
}

@end