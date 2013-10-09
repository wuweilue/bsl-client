//
//  PilotSplitViewController.m
//  pilot
//
//  Created by leichunfeng on 13-1-15.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "PilotSplitViewController.h"

@interface PilotSplitViewController ()

@end

@implementation PilotSplitViewController

@synthesize shouldAutorotateToInterfaceOrientation = _shouldAutorotateToInterfaceOrientation;

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
    self.shouldAutorotateToInterfaceOrientation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    if (_shouldAutorotateToInterfaceOrientation) {
        return YES;
    } else {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    if (_shouldAutorotateToInterfaceOrientation) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
