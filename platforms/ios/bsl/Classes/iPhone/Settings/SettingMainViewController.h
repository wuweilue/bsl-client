//
//  SettingMainViewController.h
//  cube-ios
//
//  Created by 东 on 13-3-20.
//
//

#import <UIKit/UIKit.h>
#import "UpdateChecker.h"
#import "CubeWebViewController.h"

@protocol SettingMainViewControllerDelegate<NSObject>
@optional
-(void)ExitLogin;
- (void)launch:(int)index identifier:(NSString *)identifier;
@end

@interface SettingMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CheckUpdateDelegate,UIAlertViewDelegate>{
    id<SettingMainViewControllerDelegate> __weak delegate;
    CubeWebViewController *cubeWebViewController;
    
    NSArray* titleArray;
}

@property (weak,nonatomic) id<SettingMainViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
@property (strong, nonatomic) UpdateChecker *uc;
- (IBAction)exitBtn:(id)sender;
@property(strong, nonatomic)NSString *selectedModule;

@end
