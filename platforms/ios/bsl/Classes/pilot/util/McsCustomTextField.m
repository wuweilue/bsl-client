//
//  McsCustomTextField.m
//  Mcs
//
//  Created by Ma Cunzhang on 12-7-2.
//  Copyright (c) 2012年 RYTong. All rights reserved.
//

#import "McsCustomTextField.h"

@implementation McsCustomTextField
@synthesize mcsCustomTextFieldDelegate = mcsCustomTextFieldDelegate_;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mcsCustomTextFieldDelegate_ = nil;
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
    if (mcsCustomTextFieldDelegate_ && [mcsCustomTextFieldDelegate_ respondsToSelector:@selector(mcsCustomTextFieldDidFinish:)]) {
        [mcsCustomTextFieldDelegate_ performSelector:@selector(mcsCustomTextFieldDidFinish) withObject:self];
    }
}
@end
