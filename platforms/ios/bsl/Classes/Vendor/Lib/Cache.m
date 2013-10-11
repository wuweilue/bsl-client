//
//  Cache.m
//  Cube-iOS
//
//  Created by Justin Yip on 10/28/12.
//
//

#import "Cache.h"
#import "Base64.h"
#import "NSFileManager+Extra.h"

@implementation Cache

+(id)instance
{
    static Cache *instance;
    @synchronized(self) {
        if (nil == instance) {
            instance = [[Cache alloc] init];
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *cacheURL = [[NSFileManager applicationDocumentsDirectory]
         URLByAppendingPathComponent:@"Cache"];
        NSError *error = nil;
        if(![FS createDirectoryAtURL:cacheURL withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"创建目录失败，%@", error);
        }
    }
    return self;
}

static inline NSURL* cacheURLForKey(NSString* key){
    NSString* path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSURL* nsUrl=[NSURL URLWithString:key];
    path=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",[nsUrl host],[[nsUrl path] stringByReplacingOccurrencesOfString:@"/" withString:@""] ]  ];

    
//    NSString *encodedKey = [Base64 stringByEncodingData:[key dataUsingEncoding:NSUTF8StringEncoding]];
    return [NSURL fileURLWithPath:path];
}

-(void)setData:(NSData*)aData forKey:(NSString*)aKey{
    NSError *error = nil;
    if(![aData writeToURL:cacheURLForKey(aKey) options:NSDataWritingAtomic error:&error])
    {
        NSLog(@"写缓存失败，%@", error);
    }
}


-(NSData*)dataForKey:(NSString*)aKey{
    NSURL *cacheURL = cacheURLForKey(aKey);
    
    return [[NSData alloc] initWithContentsOfURL:cacheURL];
}

@end
