//
//  LandingViewController.h
//  pilot
//
//  Created by wuzheng on 8/27/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightTaskQuery.h"

@interface LandingViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (retain, nonatomic) IBOutlet UIView *groupView;
@property (retain, nonatomic) IBOutlet UIView *landscapeView;
@property (retain, nonatomic) IBOutlet UIView *portraitView;

// 保持住，防止在回调取消请求的方法前被释放
@property (retain, nonatomic) FlightTaskQuery *taskQuery;

- (IBAction)didClickEbook:(id)sender;
- (IBAction)didClickManifest:(id)sender;
- (IBAction)didClickFeeding:(id)sender;
- (IBAction)didClickHelpCenter:(id)sender;
- (IBAction)didClickFlightSchedule:(id)sender;
- (IBAction)didExit:(id)sender;
- (IBAction)didClickSettingCenter:(id)sender;
- (IBAction)didClickFligthPreparation:(id)sender;

- (void)reSetContentViewForIPadWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)backToHome;
- (IBAction)didClickRunEbook:(id)sender;
- (IBAction)didClickOptEbook:(id)sender;
- (IBAction)didClickFlightTask:(id)sender;
- (IBAction)didClickFlightCalc:(id)sender;
- (IBAction)didClickFlightPreparationDemo:(id)sender;
- (IBAction)didClickFlightTaskDemo:(id)sender;
- (IBAction)didClickTowFiles:(id)sender;

@end
