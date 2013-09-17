//
//  NativePageControl.h
//  CSMBP
//
//  Created by 晶多 陈 on 12-3-29.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NativePageControl : UIPageControl
{
    
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHightlighted;
}

- (id) initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UIImage *imagePageStateNormal;
@property (nonatomic, strong) UIImage *imagePageStateHightlighted;

@end
