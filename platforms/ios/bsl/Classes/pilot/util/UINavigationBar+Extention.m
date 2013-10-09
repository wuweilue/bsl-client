//
//  UINavigationBar+Extention.m
//  pilot
//
//  Created by wuzheng on 9/28/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "UINavigationBar+Extention.h"

@implementation UINavigationBar (Extention)

- (void)drawRect:(CGRect)rect{
    //自定义图片
    UIImage *barImage = [UIImage imageNamed:@"NavigationBar_BackG.png"];
    [barImage drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
}



@end
