//
//  UIViewController+NIB.m
//  pilot
//
//  Created by chen shaomou on 8/23/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "UIViewController+NIB.h"
#import "UIViewController+UserInterfaceIdiom.h"

@implementation UIViewController (NIB)

- (id)initWithNib{
    NSString *className = NSStringFromClass([self class]);
    NSString *nibName;
    if([self isUserInterfaceIdiomPad]){
        nibName= [NSString stringWithFormat:@"%@_Pad",className];
    }else{
        nibName= [NSString stringWithFormat:@"%@_Phone",className];
    }
    
    return [self initWithNibName:nibName bundle:nil];
}

@end
