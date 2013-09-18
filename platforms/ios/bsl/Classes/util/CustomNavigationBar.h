//
//  CustomNavigationBar.h
//  CSMBP
//
//  Created by Justin Yip on 3/8/12.
//  Copyright (c) 2012 Forever OpenSource Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomNavigationBar : UINavigationBar
{
    CGFloat backButtonCapWidth;
}
@property(weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property(strong, nonatomic)NSString *imageName;

-(UIButton*) backButtonWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth;

@end

@interface UIViewController (CustomNavigationBarSwizzle)

- (void)viewDidLoad_CustomNavigationBar;
- (void)customLoadView;

@end

//apply to all UIViewController
void swizzleAllUIViewController();