//
//  FPOptionTableViewCell.m
//  pilot
//
//  Created by leichunfeng on 12-11-23.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPOptionTableViewCell.h"

@implementation FPOptionTableViewCell

@synthesize optionStateImageView;
@synthesize optionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [optionStateImageView release];
    [optionLabel release];
    [super dealloc];
}

+ (FPOptionTableViewCell *)geInstance {
    return [[[NSBundle mainBundle] loadNibNamed:@"FPOptionTableViewCell" owner:nil options:nil] objectAtIndex:0];
}

@end
