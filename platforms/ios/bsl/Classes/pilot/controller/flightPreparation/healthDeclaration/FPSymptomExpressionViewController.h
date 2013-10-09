//
//  FPSymptomExpressionViewController.h
//  pilot
//
//  Created by lei chunfeng on 12-11-9.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "FPHealthDeclarationViewController.h"

@interface FPSymptomExpressionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *symptomExpressionTableView;

// 所有可供选择的症状表现
@property (retain, nonatomic) NSArray *symptomExpressionArray;

// 保存用户选择的症状表现
@property (retain, nonatomic) NSMutableArray *selectedsymptomExpressionArray;

// 航医的手机号
@property (retain, nonatomic) NSArray *airMedicalPhoneNumberArray;

@property (retain, nonatomic) FPHealthDeclarationViewController *fpHealthDeclarationViewController;

// 保存用户输入的手机号
@property (retain, nonatomic) NSString *userPhoneNumber;

// 保存用户输入的其他需要申报的内容
@property (retain, nonatomic) NSString *otherDeclarationContent;

// 自定义iPhone数字键盘的Done键
@property (retain, nonatomic) UIButton *doneInKeyboardButton;

@end
