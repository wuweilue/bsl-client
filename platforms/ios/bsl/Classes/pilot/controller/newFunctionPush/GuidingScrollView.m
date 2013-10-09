//
//  GuidingScrollView.m
//  CSMBP
//
//  Created by Ease on 12-3-5.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import "GuidingScrollView.h"
#import "GDataXMLNode.h"
#import "ShowGuidance.h"

#define kStatusBarHeight 20

@implementation GuidingScrollView
@synthesize imagesData = _imagesData;
@synthesize showGuidance = _showGuidance;

#pragma mark Button Methods

- (void)finishShow:(id)sender {
    UIView *aView = [self superview];
    CGPoint newCenter = aView.center;
    newCenter.x -= CGRectGetWidth(aView.frame);
    [UIView animateWithDuration:.3 animations:^{[aView setCenter:newCenter];}];
    [aView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.3];
    
    if(_showGuidance.delegate && [_showGuidance.delegate respondsToSelector:@selector(scrollViewDidFinished)]){
        [_showGuidance.delegate scrollViewDidFinished];
    }
}

- (void)didClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Clicked!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark initMethods
- (id)initWithPlistName:(NSString *)plistName {
    self = [super init];
    if (self != nil) {
        _imagesData = nil;
        // read the filenames/sizes out of a plist in the app bundle
        NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:path];
        NSString *aError;
        NSPropertyListFormat format;
        NSArray *array = [[NSPropertyListSerialization propertyListFromData:plistData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:&format
                                                           errorDescription:&aError]
                          retain];
        _imagesData = array;
        
        if (!_imagesData) {
            [aError release];
        } else{
            [self prepareToShow];
        }
    }
    return self;
}

- (id)initWithXMLDataFileName:(NSString *)aFileName{
    self = [super init];
    if (self != nil) {
        _imagesData = nil;      
        NSString *filePath = [[NSBundle mainBundle] pathForResource:aFileName ofType:@"xml"];
        NSData *xmlData = [[[NSData alloc] initWithContentsOfFile:filePath] autorelease];
        NSError *aError;
        GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData options:NSUTF8StringEncoding error:&aError] autorelease];
        if (doc == nil) {
            NSLog(@"Failed to read xmlData. Error: %@", aError);
        } else {
            NSMutableArray *pageArray = [[NSMutableArray alloc] init];
            NSArray *pageElementArray = [doc nodesForXPath:@"//frames/frame" error:nil];
            for (GDataXMLElement *pageElement in pageElementArray) {
                NSMutableDictionary *pageDict = [[NSMutableDictionary alloc] init];                
                [pageDict setValue:[pageElement attributeForName:@"index"].stringValue forKey:@"index"];
                [pageDict setValue:[pageElement attributeForName:@"image"].stringValue forKey:@"image"];
                [pageDict setObject:@"N" forKey:@"haveButton"];
                if ([pageElement childCount] > 0) {
                    NSMutableArray *butArray = [[NSMutableArray alloc] init];
                    for (GDataXMLElement *buttonElement in [pageElement children]) {
                        NSMutableDictionary *butDict = [[NSMutableDictionary alloc] init];
                        [butDict setObject:[buttonElement attributeForName:@"image"].stringValue forKey:@"image"];
                        [butDict setObject:[buttonElement attributeForName:@"x"].stringValue forKey:@"x"];
                        [butDict setObject:[buttonElement attributeForName:@"y"].stringValue forKey:@"y"];
                        if ([buttonElement attributeForName:@"width"] != nil)
                            [butDict setObject:[buttonElement attributeForName:@"width"].stringValue forKey:@"width"];
                        if ([buttonElement attributeForName:@"height"] != nil)
                            [butDict setObject:[buttonElement attributeForName:@"height"].stringValue forKey:@"height"];
                        [butDict setObject:[buttonElement attributeForName:@"action"].stringValue forKey:@"action"];
                        [butArray addObject:butDict];
                        [butDict release];
                    }
                    [pageDict setObject:butArray forKey:@"butArray"];
                    [pageDict setObject:@"Y" forKey:@"haveButton"];
                    [butArray release];
                }
                [pageArray addObject:pageDict];
                [pageDict release];

            }
            _imagesData = [pageArray retain];
            [pageArray release];
        }
        [self prepareToShow];
    }
    return self;
}


- (void)prepareToShow {
    // Step 1: make the outer paging scroll view
    self.frame = [self frameForPagingScrollView];
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = [self contentSizeForPagingScrollView];
    self.bounces = NO;
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
    [self tilePages];
}

#pragma mark Tiling and page configuration
- (void)tilePages {
    if (_imagesData == nil) {
        return;
    }
    // Calculate which page are visible
    CGRect visibleBounds = self.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imagesCount] - 1);
    // Recycle no-longer-visible pages 
    for (UIImageView *page in visiblePages) {
        if (page.tag < firstNeededPageIndex || page.tag > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            UIImageView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[UIImageView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [self addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

- (void)configurePage:(UIImageView *)page forIndex:(NSUInteger)index {
    //页面设置
    page.tag = index;        
    page.frame = [self frameForPageAtIndex:index];
    page.image = [self imageWithIndex:index];

    [self addSubview:page];
    
    //添加buttons   
    NSDictionary *dict = [_imagesData objectAtIndex:index];
    [self configureButtonOfPage:page forIndex:index withDict:dict];

}

- (void)configureButtonOfPage:(UIImageView *)page forIndex:(NSUInteger)index withDict:(NSDictionary *)aDict {
    for (UIView *aView in [page subviews]) {
        if ([aView isKindOfClass:[UIButton class]]) {
            [aView removeFromSuperview];
        }
    }
    if ([[aDict objectForKey:@"haveButton"] isEqualToString:@"Y"]) {
        NSArray *butArray = [aDict objectForKey:@"butArray"];
        for (NSDictionary *butDict in butArray) {
            UIImage *butImg = [self imageWithName:[butDict objectForKey:@"image"]];
            
            //大小+位置
            CGSize butSize = butImg.size;
            butSize.width = [butDict objectForKey:@"width"] ? [[butDict objectForKey:@"width"] floatValue] : butSize.width;
            butSize.height = [butDict objectForKey:@"height"] ? [[butDict objectForKey:@"height"] floatValue] : butSize.height;
            
            CGFloat x = [butDict objectForKey:@"x"] ? [[butDict objectForKey:@"x"] floatValue] : 0;
            CGFloat y = [butDict objectForKey:@"y"] ? [[butDict objectForKey:@"y"] floatValue] : 0;
            
            UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(x, y, butSize.width, butSize.height)] autorelease];
            NSString *action = [butDict objectForKey:@"action"];
            if ([self respondsToSelector:NSSelectorFromString(action)]) {
                [button addTarget:self action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
            }
            [button setImage:butImg forState:UIControlStateNormal];
            [page addSubview:button];
            page.userInteractionEnabled = YES;
        }
    }
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (UIImageView *page in visiblePages) {
        if (page.tag == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (UIImageView *)dequeueRecycledPage {
    UIImageView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

#pragma mark Methods About FrameSize
- (CGRect)frameForPagingScrollView {
    if (device_Type == UIUserInterfaceIdiomPad) {
        return CGRectMake(0.0, 0.0, 768, 1024);
    } else {
        return CGRectMake(0.0, 0.0, 320, 480);
    }
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = self.bounds;
    CGRect pageFrame = bounds;
    pageFrame.origin.x = (bounds.size.width * index);
    
    CGSize imageSize = [self imageWithIndex:index].size;
    pageFrame.size = [self reviseImageSize:imageSize];
    
    CGSize screenSize;
    if (device_Type == UIUserInterfaceIdiomPad) {
        screenSize = CGSizeMake(768, 1024);
    } else {
        screenSize = CGSizeMake(320, 480);
    }
    pageFrame.size = [self reviseImageSize:imageSize];
    if (pageFrame.size.width < screenSize.width){
        pageFrame.origin.x += (screenSize.width - pageFrame.size.width)/2; 
    } else if(pageFrame.size.height < screenSize.height){
        pageFrame.origin.y += (screenSize.height - pageFrame.size.height)/2;
    }
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    CGRect bounds = self.bounds;
    return CGSizeMake(bounds.size.width * [self imagesCount], bounds.size.height);
}


#pragma mark Methods About ImagesData
- (NSUInteger)imagesCount {
    NSUInteger __count = NSNotFound;  // only count the images once
    if (__count == NSNotFound) {
        __count = [[self imagesData] count];
    }
    return __count;
}

- (NSDictionary *)pageDictWithIndex:(NSUInteger)aIndex {
    for (NSDictionary *aDict in _imagesData) {
        if ([[aDict objectForKey:@"index"] intValue] == aIndex) {
            return aDict;
        }
    }
    return nil;
}

- (UIImage *)imageWithIndex:(NSUInteger)index {
    NSDictionary *pageDict = [self pageDictWithIndex:index];
    return [self imageWithName:[pageDict objectForKey:@"image"]];
}

- (UIImage *)imageWithName:(NSString *)aImage {
    NSArray *array = [aImage componentsSeparatedByString:@"."];
    if ([array count] != 2) {
//        NSLog(@"Error: Cannot Get Image");
        return nil;
    }else {
        NSString *path = [[NSBundle mainBundle] pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
        return [UIImage imageWithContentsOfFile:path];
    }
}

- (CGSize)reviseImageSize:(CGSize)aSize {
    if (device_Type == UIUserInterfaceIdiomPad) {
        return CGSizeMake(768, 1024);
    } else {
        return CGSizeMake(320, 480);
    }
}
@end
