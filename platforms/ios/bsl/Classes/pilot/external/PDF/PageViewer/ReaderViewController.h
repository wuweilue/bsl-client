//
//	ReaderViewController.h
//	Reader v2.5.4
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2012 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "ReaderDocument.h"
#import "ReaderContentView.h"
#import "ReaderMainToolbar.h"
#import "ReaderMainPagebar.h"
#import "ThumbsViewController.h"
#import "Ebook.h"
#import "Chapter.h"
//added by Joy Zeng 2012/9/18
#import "Scanner.h"
#import "SearchResultListViewController.h"

@class ReaderViewController;
@class ReaderMainToolbar;

@protocol ReaderViewControllerDelegate <NSObject>

@optional // Delegate protocols

- (void)dismissReaderViewController:(ReaderViewController *)viewController;


@end

@interface ReaderViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate,
													ReaderMainToolbarDelegate, ReaderMainPagebarDelegate, ReaderContentViewDelegate,
													ThumbsViewControllerDelegate,SearchResultListViewControllerDelegate,ReaderViewControllerDelegate, UIDocumentInteractionControllerDelegate>
{
@private // Instance variables

	ReaderDocument *document;

	UIScrollView *theScrollView;

	ReaderMainToolbar *mainToolbar;

	ReaderMainPagebar *mainPagebar;

	NSMutableDictionary *contentViews;

	UIPrintInteractionController *printInteraction;

	NSInteger currentPage;

	CGSize lastAppearSize;

	NSDate *lastHideTime;

	BOOL isVisible;
    
   
    
    
}

@property (nonatomic, assign, readwrite) id <ReaderViewControllerDelegate> delegate;
@property (nonatomic,retain) NSString* keyword;
@property (nonatomic,retain)NSArray* cachePages;   //关键字结果页码缓存
@property (nonatomic,assign)NSUInteger _page;
@property (nonatomic,retain)id ebook;              //类型为id因为不确定传入的是Ebook对象还是Chapter对象
@property(retain,nonatomic)SearchResultListViewController *searchResultListViewController;
//added by Joy Zeng 2012/9/14

@property (nonatomic,retain) NSMutableArray *pageNumberOfSelections;    // keyword出现的页码，且已去除了重复页码
@property (nonatomic,retain) Scanner *scanner;
@property (nonatomic,assign) BOOL searchButton;
- (void)showDocumentPage:(NSInteger)page;
//end added

// add by leichunfeng
@property (nonatomic,retain) UIDocumentInteractionController *documentInteractionController;
// end add

- (id)initWithReaderDocument:(ReaderDocument *)object;

//删除缓存内的页面,//解决当前几页关键字没有高亮的问题
-(void)removeCacheContentViews;

@end
