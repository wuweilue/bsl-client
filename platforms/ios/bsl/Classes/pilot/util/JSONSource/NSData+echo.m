//
//  NSData+echo.m
//  pilot
//
//  Created by chen shaomou on 9/7/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "NSData+echo.h"

@implementation NSData (echo)

- (void)echo{
    
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",string);
    
    [string release];
}

@end
