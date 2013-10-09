//
//  NSString+ClassName.m
//  pilot
//
//  Created by chen shaomou on 11/8/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "NSString+ClassName.h"

@implementation NSString (ClassName)

-(NSString *)upperClassName{
    
    //将首字母转成大写，以便反射成对应的类
    NSString *s = [self substringToIndex:1];
    s = [s uppercaseString];
    return [NSString stringWithFormat:@"%@%@",s,[self substringFromIndex:1]];
}

-(NSString *)arrayClassName{

     return [[self substringToIndex:[self length] - 1] upperClassName];
}

-(NSString *)attrClassName{

    int len = [self length];
    
    //截取最后一个大写字母起后的字符串
    for(int index = 0 ; index < len ; index ++){
        
        if([self characterAtIndex:index] >= 65 && [self characterAtIndex:index] <= 90 ){
        
            return [self substringFromIndex:index];
        }
    
    }
    //全部为小写
    return [self upperClassName];
}

@end
