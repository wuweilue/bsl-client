//
//  PilotNavigationViewController.m
//  pilot
//
//  Created by leichunfeng on 12-12-12.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "PilotNavigationViewController.h"

@interface PilotNavigationViewController ()

@end

@implementation PilotNavigationViewController

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
-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

@end
