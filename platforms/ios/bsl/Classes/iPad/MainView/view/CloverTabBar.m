//
//  CloverTabBar.m
//  CloverTab
//
//  Created by Justin Yip on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CloverTabBar.h"

@interface CloverTabBar ()

@property(nonatomic,strong)UITableView *buttonTableView;
@property(nonatomic,strong)NSArray *tabBarItems;

@end

@implementation CloverTabBar
@synthesize buttonTableView;
@synthesize tabBarItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //remove background view
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //background view
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        bg.backgroundColor = [UIColor grayColor];
        bg.alpha = 0.3;
        [self addSubview:bg];

        
        buttonTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        buttonTableView.dataSource = self;
        buttonTableView.delegate = self;
        buttonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        buttonTableView.backgroundView = nil;
        buttonTableView.backgroundColor = [UIColor clearColor];
        buttonTableView.bounces = NO;
        buttonTableView.rowHeight = 50;
        
        [self addSubview:buttonTableView];
    }
    return self;
}

- (NSArray *)items
{
    return self.tabBarItems;
}

- (void)setItems:(NSArray *)items
{
    self.tabBarItems = items;
    [buttonTableView reloadData];
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tabBarItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CloverTabBarTableCell *cell = [[CloverTabBarTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    UITabBarItem *item = [self.tabBarItems objectAtIndex:indexPath.row];
    cell.iconImageView.image = item.image;
    
    //should hightlighted
    if (indexPath.row == [self.tabBarItems indexOfObject:self.selectedItem] &&
        [item respondsToSelector:@selector(highlightedImage)]) {
        UIImage *hl_image = [item performSelector:@selector(highlightedImage)];
        cell.imageView.image = hl_image;
    }
    
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    UITabBarItem *item = [self.tabBarItems objectAtIndex:selected.row];
    [tableView cellForRowAtIndexPath:selected].imageView.image = item.image;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITabBarItem *item = [self.tabBarItems objectAtIndex:indexPath.row];
    
    if ([item respondsToSelector:@selector(highlightedImage)]) {
        UIImage *hl_image = [item performSelector:@selector(highlightedImage)];
        [tableView cellForRowAtIndexPath:indexPath].imageView.image = hl_image;
    }

    [self.delegate tabBar:self didSelectItem:[self.tabBarItems objectAtIndex:indexPath.row]];
}

@end

@implementation CloverTabBarItem
@synthesize highlightedImage;

-(id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)hl tag:(NSInteger)tag
{
    self = [super initWithTitle:title image:image tag:tag];
    if (self) {
        self.highlightedImage = hl;
    }
    return self;
}


@end

@implementation CloverTabBarTableCell
@synthesize iconImageView;
@synthesize iconLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconImageView = [[UIImageView alloc] init];
        iconLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:iconImageView];
        [self.contentView addSubview:iconLabel];
    }
    return self;
}


-(void)layoutSubviews
{
    self.contentView.frame = self.bounds;
    self.iconImageView.contentMode = UIViewContentModeCenter;
    self.iconImageView.frame = CGRectMake(0, 0, 
                                          CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
    
}

@end