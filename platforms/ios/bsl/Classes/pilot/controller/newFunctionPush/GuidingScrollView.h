//
//  GuidingScrollView.h
//  CSMBP
//
//  Created by Ease on 12-3-5.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShowGuidance;

@interface GuidingScrollView : UIScrollView<UIScrollViewDelegate>{
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
}

@property (nonatomic, retain) NSArray *imagesData;

@property (nonatomic, retain) ShowGuidance *showGuidance;

- (id)initWithPlistName:(NSString *)plistName;
- (id)initWithXMLDataFileName:(NSString *)aFileName;
- (void)tilePages;
- (void)configurePage:(UIImageView *)page forIndex:(NSUInteger)index;
- (void)configureButtonOfPage:(UIImageView *)page forIndex:(NSUInteger)index withDict:(NSDictionary *)aDict;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (UIImageView *)dequeueRecycledPage;


- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (NSUInteger)imagesCount;
- (NSDictionary *)pageDictWithIndex:(NSUInteger)aIndex;
- (UIImage *)imageWithIndex:(NSUInteger)index;
- (UIImage *)imageWithName:(NSString *)aImage;
- (CGSize)reviseImageSize:(CGSize)aSize;
- (void)prepareToShow;
@end
