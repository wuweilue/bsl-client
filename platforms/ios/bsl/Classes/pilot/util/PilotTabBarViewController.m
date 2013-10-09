//
//  PilotTabBarViewController.m
//  pilot
//
//  Created by leichunfeng on 13-1-15.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "PilotTabBarViewController.h"

@interface PilotTabBarViewController ()

@end

@implementation PilotTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// 支持iOS6旋转
- (NSUInteger)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

@end
