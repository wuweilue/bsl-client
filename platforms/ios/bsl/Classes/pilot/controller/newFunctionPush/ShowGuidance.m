//
//  ShowGuidance.m
//  CSMBP
//
//  Created by Ease on 12-3-5.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import "ShowGuidance.h"
#import "GuidingScrollView.h"

#define kPageControlHeight 58
#define kPageCount [guidingScrollView imagesCount]

@implementation ShowGuidance
@synthesize guidingScrollView;
@synthesize pageControl;
@synthesize delegate;
@synthesize contentFileName = _contentFileName;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect;
    if (device_Type == UIUserInterfaceIdiomPad) {
         rect = CGRectMake(0.0, 0.0, 768, 1024);
    } else {
        rect = CGRectMake(0.0, 0.0, 320, 480);
    }
    UIView *viewTemp = [[UIView alloc] initWithFrame:rect];
    self.view = viewTemp;
    [viewTemp release];
    // 装载页面
    [self loadGuidingViewWithFileName:_contentFileName];
}

-(void)viewWillAppear:(BOOL)animated {
    if (device_Type == UIUserInterfaceIdiomPad) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    }
}

-(void)setGuidanceContent:(NSString *)aName {
    if (device_Type == UIUserInterfaceIdiomPad) {
        self.contentFileName = [aName stringByAppendingFormat:@"_iPad.xml"];
    } else {
        self.contentFileName = [aName stringByAppendingFormat:@"_iPhone.xml"];
    }
}

- (BOOL)loadGuidingViewWithFileName:(NSString *)aFileName {
    NSArray *array = [aFileName componentsSeparatedByString:@"."];
    if ([[array objectAtIndex:1] isEqualToString:@"xml"]) {
        guidingScrollView = [[GuidingScrollView alloc] initWithXMLDataFileName:[array objectAtIndex:0]];
    } else if ([[array objectAtIndex:1] isEqualToString:@"plist"]) {
            guidingScrollView = [[GuidingScrollView alloc] initWithPlistName:[array objectAtIndex:0]];
    }
    guidingScrollView.showGuidance = self;
    if (guidingScrollView.imagesData == nil) {
        return NO;
    }
    guidingScrollView.delegate = self;
    [self.view addSubview:guidingScrollView];
    CGSize aSize = [[UIScreen mainScreen] bounds].size;
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, aSize.height-kPageControlHeight, aSize.width, kPageControlHeight)];
    [pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    pageControl.numberOfPages = kPageCount;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    return YES;
}

- (void)dealloc {
    [super dealloc];
    [guidingScrollView release];
    [pageControl release];
}

- (void)pageChanged:(UIPageControl *)sender {
    NSInteger currentPage = sender.currentPage;
    CGRect frame = guidingScrollView.frame;
    frame.origin.x = guidingScrollView.frame.size.width * currentPage;
    [guidingScrollView scrollRectToVisible:frame animated:YES];    
}

#pragma mark － ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [guidingScrollView tilePages];
    CGFloat pageWidth = guidingScrollView.bounds.size.width;
    NSInteger currentPage = ceil((guidingScrollView.contentOffset.x - pageWidth/2)/pageWidth);
    pageControl.currentPage = currentPage;
    if (currentPage == kPageCount - 1 && device_Type == UIUserInterfaceIdiomPhone) {
        pageControl.hidden = YES;
    } else {
        pageControl.hidden = NO;
    }
    NSInteger num = kPageCount - 1;
    if (currentPage == num && (ceil((guidingScrollView.contentOffset.x - pageWidth/3)/pageWidth) > num)) {
        [self.view removeFromSuperview];
        if(delegate && [delegate respondsToSelector:@selector(scrollViewDidFinished)]){
            [delegate scrollViewDidFinished];
        }
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}
@end
