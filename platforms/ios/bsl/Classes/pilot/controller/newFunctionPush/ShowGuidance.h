//
//  ShowGuidance.h
//  CSMBP
//
//  Created by Ease on 12-3-5.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class GuidingScrollView;

@protocol ShowGuidanceDelegate <NSObject>

- (void)scrollViewDidFinished;

@end

@interface ShowGuidance : UIViewController<UIScrollViewDelegate>

@property (retain, nonatomic) GuidingScrollView *guidingScrollView;

@property (retain, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) id<ShowGuidanceDelegate> delegate;

@property (retain, nonatomic) NSString *contentFileName;

- (BOOL)loadGuidingViewWithFileName:(NSString *)aFileName;
- (void)pageChanged:(UIPageControl *)sender;

//设置指导内容，文件为xml文件,不需要加后缀名和版本后缀
- (void)setGuidanceContent:(NSString *)aName;

@end