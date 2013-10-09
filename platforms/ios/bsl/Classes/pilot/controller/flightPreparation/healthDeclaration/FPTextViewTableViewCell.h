//
//  FPTextViewTableViewCell.h
//  iOSTrain
//
//  Created by leichunfeng on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPTextViewTableViewCell : UITableViewCell

// 自定义的cell，包含一个UITextView
@property (retain, nonatomic) IBOutlet UITextView *customTextView;

// 类方法，可获取实例
+ (FPTextViewTableViewCell *)getInstance;

@end
