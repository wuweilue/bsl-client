//
//  FPButtonTableViewCell.h
//  HelloWorld
//
//  Created by leichunfeng on 12-11-22.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPButtonTableViewCell : UITableViewCell

// 自定义的cell，包含一个UIButton
@property (retain, nonatomic) IBOutlet UIButton *customButton;

// 类方法，可获取实例
+ (FPButtonTableViewCell *)getInstance;

@end
