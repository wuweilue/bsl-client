//
//  FPTextFieldTableViewCell.h
//  pilot
//
//  Created by lei chunfeng on 12-11-9.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPTextFieldTableViewCell : UITableViewCell

// 自定义的cell，包含一个UITextField
@property (retain, nonatomic) IBOutlet UITextField *customTextField;

// 类方法，可获取实例
+ (FPTextFieldTableViewCell *)getInstance;

@end
