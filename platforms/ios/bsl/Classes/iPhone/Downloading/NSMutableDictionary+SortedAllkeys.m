//
//  NSMutableDictionary+SortedAllkeys.m
//  cube-ios
//
//  Created by chen shaomou on 4/26/13.
//
//

#import "NSMutableDictionary+SortedAllkeys.h"

@implementation NSMutableDictionary (SortedAllkeys)


-(NSArray *)sortedAllkeys{


    return [[self allKeys] sortedArrayUsingFunction:intSort context:NULL];
}

NSInteger intSort(id num1, id num2, void *context)
{

    NSString *c1 = (NSString *)num1;
    
    NSString *c2 = (NSString *)num2;
    
    if([c1 isEqualToString:@"基本功能"]){
    
        return NSOrderedAscending;
    }
    
    if([c2 isEqualToString:@"基本功能"]){
        
        return NSOrderedDescending;
    }
    
     return NSOrderedSame;
}

-(NSArray *)sortedAllkeysBaseModuleEnd{


    return [[self allKeys] sortedArrayUsingFunction:intSortBaseModuleEnd context:NULL];
}

-(NSArray *)sortedAllkeysBaseModulePublicEnd{
    
    NSArray *array = [[self allKeys] sortedArrayUsingFunction:intSortBaseModuleEnd context:NULL];
    NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:0];
    [newArray addObjectsFromArray:array];
    NSArray *secArray = [newArray sortedArrayUsingFunction:publicSortBaseModuleEnd context:NULL];
    return secArray;
    
}
NSInteger intSortBaseModuleEnd(id num1, id num2, void *context)
{
    
    NSString *c1 = (NSString *)num1;
    
    NSString *c2 = (NSString *)num2;
    
    if([c1 isEqualToString:@"基本功能"]){
        
        return NSOrderedDescending;
    }
    
    if([c2 isEqualToString:@"基本功能"]){
        
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}


NSInteger publicSortBaseModuleEnd(id num1, id num2, void *context)
{
    
    NSString *c1 = (NSString *)num1;
    
    NSString *c2 = (NSString *)num2;
    if([c1 rangeOfString:@"公共"].location != NSNotFound)
    {
        return NSOrderedAscending;
    }
    if([c2 rangeOfString:@"公共"].location != NSNotFound)
    {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}


@end
