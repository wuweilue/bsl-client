//
//  UIViewController+UserInterfaceIdiom.m
//  pilot
//
//  Created by chen shaomou on 8/23/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "UIViewController+UserInterfaceIdiom.h"

@implementation UIViewController (UserInterfaceIdiom)

- (BOOL)isUserInterfaceIdiomPhone{

    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    
}

- (BOOL)isUserInterfaceIdiomPad{

    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

@end
