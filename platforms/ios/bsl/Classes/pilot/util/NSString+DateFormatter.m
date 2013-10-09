//
//  NSString+DateFormatter.m
//  pilot
//
//  Created by wuzheng on 9/4/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "NSString+DateFormatter.h"

@implementation NSString (DateFormatter)

- (NSDate *)stringToDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([self length] == 10) {
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }else if([self length] == 19){
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    NSDate *date = [formatter dateFromString:self];
    [formatter release];
    return date;
}

@end
