//
//  ThreadTask.h
//  
//
//  Created by fanty on 13-5-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ThredTaskBlock)(void);

/*!
 @abstract:NSThread async class
 */
@interface ThreadTask : NSObject{
    BOOL skipFinish;
}

@property(nonatomic,strong) id result;

/*!
 @abstract:cancel the nsthread
 */
-(void)cancel;

/*!
 @abstract:check the nsthread is cancel
 */
-(BOOL)isCancel;

+(ThreadTask*)asyncStart:(ThredTaskBlock)start end:(ThredTaskBlock)finish;

-(void)start:(ThredTaskBlock)start end:(ThredTaskBlock)finish;

@end
