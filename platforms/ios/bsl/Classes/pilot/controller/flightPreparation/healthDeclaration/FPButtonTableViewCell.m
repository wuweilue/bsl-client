//
//  FPButtonTableViewCell.m
//  HelloWorld
//
//  Created by leichunfeng on 12-11-22.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "FPButtonTableViewCell.h"

@implementation FPButtonTableViewCell

@synthesize customButton;

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
    [customButton release];
    [super dealloc];
}

+ (FPButtonTableViewCell *)getInstance {
    return [[[NSBundle mainBundle] loadNibNamed:@"FPButtonTableViewCell" owner:nil options:nil] objectAtIndex:0];
}

@end
