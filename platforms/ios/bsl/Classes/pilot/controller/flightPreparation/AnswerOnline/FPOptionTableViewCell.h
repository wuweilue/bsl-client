//
//  FPOptionTableViewCell.h
//  pilot
//
//  Created by leichunfeng on 12-11-23.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPOptionTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *optionStateImageView;
@property (retain, nonatomic) IBOutlet UILabel *optionLabel;

+ (FPOptionTableViewCell *)geInstance;

@end
