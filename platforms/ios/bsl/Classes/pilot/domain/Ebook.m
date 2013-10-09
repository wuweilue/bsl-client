//
//  Ebook.m
//  pilot
//
//  Created by Sencho Kong on 13-1-29.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "Ebook.h"
#import "Chapter.h"


@implementation Ebook

@dynamic bookId;
@dynamic bookName;
@dynamic bookType;
@dynamic upTime;
@dynamic url;
@dynamic chapters;
@synthesize bookURL;
@synthesize selections;





+(NSArray *)findByType:(NSString *)type{
    
    return [Ebook find:@"bookType = %@",type];
}

+(NSArray *)findByBookID:(NSString *)bookId{
    
    return [Ebook find:@"bookId = %@",bookId];
}

// 从本地删除该电子书
-(BOOL)removeEbookFromDefaultManager {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.bookName];
    // 从数据库删除该对象
    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    BOOL result = [defaultFileManager removeItemAtPath:self.url error:&error];
    if (!result || error) {
        NSLog(@"delete ebook fail, %@", error);
    }
    

    if (false) {
        NSError *error = nil;
        for (Chapter* chapter in self.chapters) {
            BOOL result = [defaultFileManager removeItemAtURL:chapter.bookURL error:&error];
            if (!result || error) {
                NSLog(@"delete ebook chapters fail, %@", error);
            }

        }
    }

    [self remove];
    return result;
    
}

-(void)remove {
    

	[[self managedObjectContext] deleteObject:self];
   
}



-(void)dealloc{
    [bookURL release];
    [selections release];
    [super dealloc];
}


@end
