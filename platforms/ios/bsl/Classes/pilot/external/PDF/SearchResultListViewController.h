//
//  SearchResultListViewController.h
//  pilot
//
//  Created by Sencho Kong on 12-9-26.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scanner.h"
#import "Ebook.h"

@protocol SearchResultListViewControllerDelegate <NSObject>

@optional
-(void)didSelectedSelection:(Selection*)selection Keyword:(NSString*)keyword;

-(void)willBeginScanEbook:(Ebook*)aEbook Page:(NSUInteger)page Keyword:(NSString*)keyword;

-(void)SearchResultListViewControllerDidFinishScanPage:(NSInteger)page;

@end

@interface SearchResultListViewController : UIViewController<UISearchBarDelegate,ScannerDelegate,UITableViewDataSource,UITableViewDelegate>


@property(retain,nonatomic)NSString* keyWord;
@property(retain,nonatomic)UISearchBar* searchBar;
@property(assign,nonatomic)NSInteger currentPage;    //要搜索的当前页码
@property(assign,nonatomic)id <SearchResultListViewControllerDelegate>delegate;
@property(retain,nonatomic)Ebook* eBook;
                      

-(void)startScanFromPage:(NSInteger)page WithKeyWord:(NSString*)keyWord;

-(void)stopScan;

@end
