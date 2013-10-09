//
//  NSDictionary+ObjectExtensions.m
//  pilot
//
//  Created by chen shaomou on 8/31/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "NSDictionary+ObjectExtensions.h"
#import "NSObject+propertyList.h"
#import "NSManagedObject+Repository.h"
#import "NSString+ClassName.h"
#import "Ebook.h"

@interface NSDictionary (private)

-(NSObject *)dictionary2Object:(NSString *) objetName;

@end

@implementation NSDictionary (ObjectExtensions)

-(NSObject *)dictionary2Object{
    
    NSString *className = [[self allKeys] objectAtIndex:0];
    
    NSObject *paramObj = [self objectForKey:[[self allKeys] objectAtIndex:0]];
    
    if ([paramObj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *paramDict = (NSDictionary *)paramObj;
        
        return [paramDict dictionary2Object:[className upperClassName]];
    
    }else if([paramObj isKindOfClass:[NSArray class]]){
        
        return [self dictionary2Array:[className arrayClassName]];
        
    }
    else{
        return nil;
    }
    
}

-(NSArray *)dictionary2Array{
    
    NSString *arrayName = [[self allKeys] objectAtIndex:0];
    
    return [self dictionary2Array:[arrayName arrayClassName]];
}



- (id)transforObjectToClass:(Class)objClass {
    NSArray *attrs;
    id obj;
    obj = [[[objClass alloc] init] autorelease];
    
    attrs = [obj getPropertyList];
    
    for(NSString *eachAttr in attrs){
        
        NSObject *eachParam = nil;
        
        NSObject *eachObj = [self objectForKey:eachAttr];
        
        if ([eachObj isKindOfClass:[NSNumber class]]) {
            
            eachParam = [(NSNumber*)eachObj stringValue];
        }
        else if([eachObj isKindOfClass:[NSString class]]){
            
            eachParam = [self objectForKey:eachAttr];
            
        }else if([eachObj isKindOfClass:[NSDictionary class]]){
            //                eachParam = [(NSDictionary *)eachObj dictionary2Object:[eachAttr attrClassName]];
            
            
            NSDictionary *dic = (NSDictionary *)eachObj;
            NSArray *array = [NSArray arrayWithObject:dic];
            NSMutableArray *paramArray =  [NSMutableArray arrayWithCapacity:1];
            for(NSObject *eachElm in array){
                
                if([eachElm isKindOfClass:[NSDictionary class]]){
                    [paramArray addObject:[(NSDictionary *)eachElm dictionary2Object:[eachAttr arrayClassName]]];
                }else if([eachElm isKindOfClass:[NSString class]]){
                    [paramArray addObject:eachElm];
                }else if([eachElm isKindOfClass:[NSNumber class]]){
                    [paramArray addObject:[(NSNumber*)eachElm stringValue]];
                }
            }
            
            eachParam = paramArray;
            
        }else if([eachObj isKindOfClass:[NSArray class]]){
            
            NSMutableArray *paramArray =  [NSMutableArray arrayWithCapacity:[(NSArray *)eachObj count]];
            
            for(NSObject *eachElm in (NSArray *)eachObj){
                
                if([eachElm isKindOfClass:[NSDictionary class]]){
                    [paramArray addObject:[(NSDictionary *)eachElm dictionary2Object:[eachAttr arrayClassName]]];
                }else if([eachElm isKindOfClass:[NSString class]]){
                    [paramArray addObject:eachElm];
                }else if([eachElm isKindOfClass:[NSNumber class]]){
                    [paramArray addObject:[(NSNumber*)eachElm stringValue]];
                }
            }
            
            eachParam = paramArray;
            
        }
        
        if(eachParam){
            
            [obj setValue:eachParam forKey:eachAttr];
            
        }
    }
    return obj;
}

-(NSObject *)dictionary2Object:(NSString *) objectName{

    Class objClass = NSClassFromString(objectName);
    
    id obj = nil;
    
  

    if([objClass isSubclassOfClass:[NSManagedObject class]]){
        
        obj = [objClass insert];
      
       //针对Ebook对象有一个chapters关系属性做的处理，对于关系对象不可以用setValuesForKeysWithDictionary:方法去写入NSManagedObject对象
        //edit by Sencho Kong 2013 1 30
        if ([objectName isEqualToString:@"Ebook"]) {
          
            NSArray* allValues= [self allValues];
            for ( int i=0 ;i<allValues.count;i++ ) {
                id value=[allValues objectAtIndex:i];
                
                //防止值是数字时崩溃，把数字转换成字符
                if ([value isKindOfClass:[NSNumber class]]) {
                    value=[value stringValue];
                }
                
                NSString* key= [[self allKeys] objectAtIndex:i];
                //如果Ebook对象的属性是数组的话表示包括了chapter对象
                if ([value isKindOfClass:[NSArray class]]) {
                    //生成一个以chapter为key ，值为chapter的属性的字典
                    NSDictionary* dic=[NSDictionary dictionaryWithObject:value forKey:key];
                    if (dic.count>0) {
                        //字典转chapter对象数组
                        NSArray* objects=[dic dictionary2Array:[key arrayClassName ]];
                        //coredata关系中的默认添加关系对象的方法，写入Ebook.chapters关系属性中
                        [(Ebook*)obj addChapters:[NSSet setWithArray:objects]];
        
                    }
    
                }else{
                    
                                       
                    [(NSManagedObject *)obj setValue:value forKey:key];
                }
            
            }
           
        // 完成处理
        //end edit            
        }else{
        
            [(NSManagedObject *)obj setValuesForKeysWithDictionary:self];
            
        }
    
       
               
    }else{
        
        obj = [self transforObjectToClass:objClass];
    }
    
    return obj;
}

-(NSArray *)dictionary2Array:(NSString *)className{
    
    NSString *arrayName = [[self allKeys] objectAtIndex:0];

    NSArray *tmpArray = [self objectForKey:arrayName];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:[tmpArray count]];
    
    for(NSDictionary *each in tmpArray){
        
        NSObject *eachObj = nil;
        
        if([each isKindOfClass:[NSDictionary class]]){
            eachObj = [each dictionary2Object:className];
        }else{
            eachObj = each;
        }
        
        [returnArray addObject:eachObj];
    }
    
    return [returnArray autorelease];
    
}

@end
