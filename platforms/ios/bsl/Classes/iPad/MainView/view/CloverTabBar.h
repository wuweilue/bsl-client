//
//  CloverTabBar.h
//  CloverTab
//  custom draw
//
//  Created by Justin Yip on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloverTabBar : UITabBar <UITableViewDataSource, UITableViewDelegate>

@end

@interface CloverTabBarItem : UITabBarItem
@property(nonatomic, strong)UIImage *highlightedImage;

-(id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage tag:(NSInteger)tag;

@end

@interface CloverTabBarTableCell : UITableViewCell
@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UILabel *iconLabel;

@end