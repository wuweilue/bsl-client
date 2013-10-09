//
//  LoginViewController.h
//  pilot
//
//  Created by chen shaomou on 8/23/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserQuery.h"

@interface PilotLoginViewController : UIViewController<UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>{
    UITextField *passwordTextField_;
    UITextField *usernameTextField_;
    UIButton    *rememberBtn;
    BOOL showRegisterFlag;;
}

@property (nonatomic, retain) UIButton *rememberBtn;

@property (retain, nonatomic) IBOutlet UIImageView *loginBGImageView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (retain, nonatomic) IBOutlet UIView *maskView;
@property (retain, nonatomic) IBOutlet UILabel *messageLabel;

@property (retain, nonatomic) IBOutlet UITableView *loginTable;

// 保持住，防止在回调取消请求的方法前被释放
@property (retain, nonatomic) UserQuery *userQuery;

- (IBAction)savePassword:(id)sender;

- (IBAction)didClickLoginButton:(id)sender;
- (IBAction)speedTest:(id)sender;
- (IBAction)helpCenter:(id)sender;

- (void)showVersionUpdateAlertWithStatus:(NSString *)status description:(NSString *)description;

@end
