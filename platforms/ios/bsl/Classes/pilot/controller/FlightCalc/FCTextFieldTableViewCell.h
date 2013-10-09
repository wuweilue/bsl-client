//
//  FCTextFieldTableViewCell.h
//  pilot
//
//  Created by leichunfeng on 13-2-4.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCTextFieldTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *customLabel;

@property (retain, nonatomic) IBOutlet UITextField *customTextField;

+ (FCTextFieldTableViewCell *)getInstance;

@end
