//
//  SettingsViewController.h
//  Cube-iOS
//
//  Created by Justin Yip on 2/5/13.
//
//

#import <UIKit/UIKit.h>
#import "UpdateChecker.h"

@interface SettingsViewController : UIViewController<CheckUpdateDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;
@property (retain, nonatomic) IBOutlet UILabel *deviceIDLabel;
@property (retain, nonatomic) UpdateChecker *uc;
@property (retain, nonatomic) IBOutlet UILabel *isConnectLabel;
- (IBAction)didPressCheckUpdate:(id)sender;

@end
