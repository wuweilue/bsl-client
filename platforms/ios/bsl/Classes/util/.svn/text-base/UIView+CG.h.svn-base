//
//  UIView+CG.h
//  Scent
//
//  Created by Justin Yip on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (UIView_CG)

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setSize:(CGSize)size;

//水平移动--Add By Ease
- (void)moveX:(CGFloat)x;

- (void)setOrigin:(CGPoint)aOrigin;

//两个view之间中间对齐
- (void)centerAlignToView:(UIView*)parent;
- (void)centerAlignToSuperview;

- (UILabel*)labelWithTag:(NSInteger)tag;
- (UIButton*)buttonWithTag:(NSInteger)tag;

- (UIView*)findFirstResponder;
- (UIView*)findParentScrollView;
- (void)scrollToVisible;
- (void)scrollToVisibleSpecialView;
- (UIView*)findParentScrollViewOrderNum:(int)aNum;
@end

//UILabel的frame如果有浮点数，则会导致文字模糊，使用此函数代替CGRectMake可以解决
CG_INLINE CGRect
CGRectMakeInt(int x, int y, int width, int height)
{
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size.width = width; rect.size.height = height;
    return rect;
}