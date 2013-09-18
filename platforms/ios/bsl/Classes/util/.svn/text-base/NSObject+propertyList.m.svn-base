//
//  NSObject+propertyList.m
//  Mcs
//
//  Created by chen shaomou on 8/23/12.
//  Copyright (c) 2012 RYTong. All rights reserved.
//

#import "NSObject+propertyList.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@implementation NSObject (propertyList)

- (NSArray *)getPropertyList{
    
    NSMutableArray *propertyList = [[NSMutableArray alloc] init];

    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *eachPropertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        [propertyList addObject:eachPropertyName];
        
        [eachPropertyName release];
    }
    
    free(properties);

    return [propertyList autorelease];
}

- (NSDictionary *)formDictory{

    NSArray *propertyList = [self getPropertyList];
    
    NSMutableDictionary *propertyDic = [[NSMutableDictionary alloc] initWithCapacity:[propertyList count]];
    
    for(NSString *eachProperty in propertyList){
        
        if([self valueForKey:eachProperty]){
        
            [propertyDic setObject:[self valueForKey:eachProperty] forKey:eachProperty];
            
        }
        
    }
    
    NSMutableDictionary *objectDic = [NSMutableDictionary dictionary];
    
    NSString *className = NSStringFromClass([self class]);
    
    [objectDic setObject:propertyDic forKey:className];
    
    return [propertyDic autorelease];
    
}

@end
