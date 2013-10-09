//
//  GEAlertViewDelegate.h
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ConfirmBlock)(void);
typedef void (^CancelBlock)(void);

@interface GEAlertViewDelegate : NSObject<UIAlertViewDelegate>{

    ConfirmBlock confirmBlock_;
    CancelBlock cancelBlock_;
}

+(GEAlertViewDelegate *)defaultDelegate;

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle confirmBlock:(void(^)(void))confirmBlock cancelBlock:(void(^)(void))cancelBlock;

@end
