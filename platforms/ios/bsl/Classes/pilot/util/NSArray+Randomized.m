//
//  NSArray+Randomized.m
//  pilot
//
//  Created by leichunfeng on 12-11-23.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "NSArray+Randomized.h"

@implementation NSArray (Randomized)

// 实现数组随机排序
- (NSArray *)randomizedArray {
    NSMutableArray *results = [NSMutableArray arrayWithArray:self];
    
    int i = [results count];
    while (--i > 0) {
        int j = rand() % (i+1);
        [results exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:results];
}

@end
