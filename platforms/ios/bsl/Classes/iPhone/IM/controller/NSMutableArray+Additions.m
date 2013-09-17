//
//  GroupManagerControllerViewController.m
//  cube-ios
//
//  Created by Mr Right on 13-8-13.
//
//

#import "NSMutableArray+Additions.h"


@implementation NSMutableArray (NSMutableArray_Additions)

- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex > self.count || toIndex > self.count || toIndex == fromIndex)
    {
        return;
    }
    
    id movedObj = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    
    if (toIndex > self.count)
    {
        [self addObject:movedObj];
    }
    else
    {
        [self insertObject:movedObj atIndex:toIndex];
    }
    
    
}


@end
