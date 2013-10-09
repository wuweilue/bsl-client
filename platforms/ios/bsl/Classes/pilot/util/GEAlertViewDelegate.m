//
//  GEAlertViewDelegate.m
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "GEAlertViewDelegate.h"

@implementation GEAlertViewDelegate

+(GEAlertViewDelegate *)defaultDelegate{

    return [[self alloc] init];
}

-(void)dealloc{
    [confirmBlock_ release];
    [cancelBlock_ release];
    [super dealloc];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle confirmBlock:(void(^)(void))confirmBlock cancelBlock:(void(^)(void))cancelBlock{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
    
    [confirmBlock_ release];
    confirmBlock_ = [confirmBlock copy];
    
    [cancelBlock_ release];
    cancelBlock_ = [cancelBlock copy];
    
    [alert show];
    
    [alert release];
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    int count = [alertView numberOfButtons];
    if (count == 1) {
        if (confirmBlock_) {
            confirmBlock_();
        }
    }else{
        if (buttonIndex == 1) {
            //确定
            if (confirmBlock_) {
                confirmBlock_();
            }
        }else if(buttonIndex == 0){
            //取消
            if (cancelBlock_) {
                cancelBlock_();
            }
        }
    }
    
    [self dealloc];
}


@end
