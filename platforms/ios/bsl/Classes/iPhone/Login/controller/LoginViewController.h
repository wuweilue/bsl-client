//
//  ViewController.h
//  Mobile_Application_Platform
//
//  Created by Mr.幸 on 12-12-6.
//  Copyright (c) 2012年 Mr.幸. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>{
    int prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
    float prewMoveY; //编辑的时候移动的高度
}
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UISwitch *save;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *LoginView;
- (IBAction)login:(id)sender;
- (IBAction)savePassword:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *loginBackgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *radioImage;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@property (strong, nonatomic) IBOutlet UISwitch *offLineSwitch;
@end
