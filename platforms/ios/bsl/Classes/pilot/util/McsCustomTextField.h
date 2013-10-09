//
//  McsCustomTextField.h
//  Mcs
//
//  Created by Ma Cunzhang on 12-7-2.
//  Copyright (c) 2012年 RYTong. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义TextField的代理，
@protocol McsCustomTextFieldDelegate <NSObject>

@optional
//当点击键盘完成按钮时可以调用此函数
- (void)mcsCustomTextFieldDidFinish:(id)sender;
@end

//自定义TextField
@interface McsCustomTextField : UITextField{
    id<McsCustomTextFieldDelegate> mcsCustomTextFieldDelegate_;
}

@property (nonatomic, assign) id<McsCustomTextFieldDelegate> mcsCustomTextFieldDelegate;

@end
