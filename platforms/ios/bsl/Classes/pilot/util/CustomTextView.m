//
//  CustomTextView.m
//  pilot
//
//  Created by wuzheng on 9/21/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView*)inputAccessoryView{
    CGRect accessFrame =  CGRectMake(0.0f, 0.0f, 320, 30.0f);
    UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:accessFrame] autorelease];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonFinish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(didFinish:)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar setItems:[NSArray arrayWithObjects:space, buttonFinish, nil]];
    [space release];
    [buttonFinish release];
    return toolbar;
}
- (void)didFinish:(id)sender{
    [self resignFirstResponder];
}

@end
