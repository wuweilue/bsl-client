//
//  UINavigationController+TitleExtention.m
//  pilot
//
//  Created by Sencho Kong on 12-10-19.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "UIViewController+TitleExtention.h"

@implementation UIViewController (TitleExtention)


-(void)setTitle:(NSString *)title{
           
        if (self.navigationItem) {
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:20.0];
            label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            label.textAlignment = UITextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.text=title;
            self.navigationItem.titleView = label;
            [label sizeToFit];
 
        }
        
}




@end
