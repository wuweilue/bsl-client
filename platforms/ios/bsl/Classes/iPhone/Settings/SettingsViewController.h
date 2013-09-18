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
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceIDLabel;
@property (strong, nonatomic) UpdateChecker *uc;
@property (strong, nonatomic) IBOutlet UILabel *isConnectLabel;
- (IBAction)didPressCheckUpdate:(id)sender;

@end
