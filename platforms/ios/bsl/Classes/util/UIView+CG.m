//
//  UIView+CG.m
//  Scent
//
//  Created by Justin Yip on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+CG.h"

@implementation UIView (UIView_CG)
static int parantScorllView=0;
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)moveX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x += x;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)aOrigin{
    CGRect frame = self.frame;
    frame.origin = aOrigin;
    self.frame = frame;
}

- (void)centerAlignToView:(UIView*)parent {
    CGRect frame = self.frame;
    frame.origin = [parent center];
    CGRectOffset(frame, - CGRectGetWidth(frame), CGRectGetHeight(frame));
    self.frame = frame;
}

- (void)centerAlignToSuperview {
    CGRect frame = self.frame;
    CGRect parentFrame = self.superview.frame;
    
    frame.origin = CGPointMake(CGRectGetWidth(parentFrame) / 2 - CGRectGetWidth(frame) / 2,
                               CGRectGetHeight(parentFrame) / 2 - CGRectGetHeight(frame) / 2);
    self.frame = frame;
}

- (UILabel*)labelWithTag:(NSInteger)tag
{
    return (UILabel*)[self viewWithTag:tag];
}

- (UIButton*)buttonWithTag:(NSInteger)tag
{
    return (UIButton*)[self viewWithTag:tag];
}

- (UIView*)findFirstResponder {
    if (self.isFirstResponder) {        
        return self;     
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

- (UIView*)findParentScrollView {
    if ([self isKindOfClass:[UIScrollView class]]) { 
        return self;
    }
    
    UIView *superview = self.superview;
    if (superview == nil) {
        return nil;
    } else {
        return [superview findParentScrollView];
    }
}

- (UIView*)findParentScrollViewOrderNum:(int)aNum
{
    if ([self isKindOfClass:[UIScrollView class]]&&parantScorllView==1) {
        return self;
    }
    if ([self isKindOfClass:[UIScrollView class]]) { 
        parantScorllView++;
    }
   
    UIView *superview = self.superview;
    if (superview == nil) {
        return nil;
    } else {
        
        return [superview findParentScrollViewOrderNum:aNum];
    }
}

- (void)scrollToVisible {
    UIView *scroll = [self findParentScrollView];
    if (scroll != nil) {
        
        //优化，逐层转化坐标，（递归实现）
        CGRect rect = [scroll convertRect:self.frame fromView:self];
        
        
//        CGRect rect2 = [self.superview convertRect:self.frame toView:scroll];
        CGSize size = [(UIScrollView*)scroll contentSize];
        //TODO: reset y
        if (CGRectGetMaxY(rect) >= size.height) {
            rect.origin.y = size.height - 10;
            rect.size.height = 10;
        }
        if (size.width <= rect.origin.x) {
            rect.origin.x = size.width - 10;
            rect.size.width = 10;
        }
        //TODO: reset ?
        [(UIScrollView*)scroll scrollRectToVisible:rect animated:YES];
    }
}

- (void)scrollToVisibleSpecialView
{
    parantScorllView=0;
    UIView *scroll = [self findParentScrollViewOrderNum:1];
    if (scroll != nil) {
        CGRect rect = [scroll convertRect:self.frame fromView:self];
        //        CGRect rect2 = [self.superview convertRect:self.frame toView:scroll];
        [(UIScrollView*)scroll scrollRectToVisible:rect animated:YES];
    }
}
@end
