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

@interface SettingMainViewController : UIViewController{
    CubeWebViewController *cubeWebViewController;
    NSArray* titleArray;
    
    UpdateChecker *uc;
}

@property (weak,nonatomic) id<SettingMainViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
- (IBAction)exitBtn:(id)sender;
@property(strong, nonatomic)NSString *selectedModule;

@end
