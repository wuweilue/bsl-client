//
//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "BaseViewController.h"

@implementation BaseViewController
@synthesize searchBar;
@synthesize curFliterStr;
@synthesize maskView;
@synthesize actionSelector;

-(void)dealloc{
    self.searchBar=nil;
    self.curFliterStr=nil;
    self.maskView=nil;
    self.actionSelector=nil;
    [super dealloc];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //xmpp重连
    if(![((AppDelegate *)[UIApplication sharedApplication].delegate).xmpp isConnected]){
        
        [((AppDelegate *)[UIApplication sharedApplication].delegate).xmpp connect];
    }
}
#pragma mark searchbar
-(UIView *)getSearchBarViewSwitchSelector:(SEL)selecter andIsRightBtnActive:(BOOL) isRightActive{
    UIView *searchBarView=[[[UIView alloc] initWithFrame:kSearchCombineBar] autorelease];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:searchBarView.frame];
    imageView.image=[UIImage imageNamed:@"bg_search_lightgray"];
    [searchBarView addSubview:imageView];
    
    UISearchBar *__searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(5, 0, 220, 40)] autorelease];
    [[__searchBar.subviews objectAtIndex:0]removeFromSuperview];
    __searchBar.delegate = self;
    __searchBar.placeholder = @"搜索";
    self.searchBar = __searchBar;
    [__searchBar release];
    
    SwitchButton *switchBtn=[[SwitchButton alloc]init];
    switchBtn.rightOpen = isRightActive;
    [switchBtn patch];
    
    switchBtn.frame=CGRectMake(230, 5, 80, 30);
    
    switchBtn.delegate = self;
    self.actionSelector = selecter;
    
    [switchBtn patch];
    
    [searchBarView addSubview:switchBtn];
    [searchBarView addSubview:searchBar];
    
    [imageView release];
    [switchBtn release];
    return searchBarView;
}

-(void)didClickSwitchButton{
    
    [self performSelector:self.actionSelector];
}


#pragma mark -- UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if(!self.maskView){
        UIView *__maskView = [[UIView alloc] initWithFrame:kIconContentViewFrame];
        __maskView.backgroundColor = [UIColor blackColor];
        __maskView.alpha = 0.7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMaskView)];
        self.maskView = __maskView;
        [self.maskView addGestureRecognizer:tap];
        [__maskView release];
    }
    [self.navigationController.topViewController.view addSubview:self.maskView];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.curFliterStr=searchText;
    [SearchDataSource filterTheDataSources:searchText forDelegate:self];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *) searchBar
{
    [SearchDataSource filterTheDataSources:self.curFliterStr forDelegate:self];
    [self hideMaskView];
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [self hideMaskView];
    return YES;
}

-(void)hideMaskView{
    [self.searchBar resignFirstResponder];
    [self.searchBar endEditing:YES];
    [self.maskView removeFromSuperview];
}


-(void)drawWithDataSource:(NSMutableDictionary*)tempDic{
    
}

-(NSMutableArray *)modulesToFilt{
    return nil;
}

-(void)saveCurrentIconDic:(NSMutableDictionary *)iconDic{
    
}

@end
