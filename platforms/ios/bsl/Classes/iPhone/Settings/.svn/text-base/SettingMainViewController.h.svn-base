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
    id<SettingMainViewControllerDelegate> delegate;
    CubeWebViewController *cubeWebViewController;
    
    NSArray* titleArray;
}

@property (assign,nonatomic) id<SettingMainViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITableView *settingTableView;
@property (retain, nonatomic) UpdateChecker *uc;
- (IBAction)exitBtn:(id)sender;
@property(retain, nonatomic)NSString *selectedModule;

@end
