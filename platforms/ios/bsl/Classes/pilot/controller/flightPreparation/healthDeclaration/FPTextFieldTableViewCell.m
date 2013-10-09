//
//  FPTextFieldTableViewCell.m
//  pilot
//
//  Created by lei chunfeng on 12-11-9.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPTextFieldTableViewCell.h"

@implementation FPTextFieldTableViewCell
@synthesize customTextField;

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

+ (FPTextFieldTableViewCell *)getInstance {
    return [[[NSBundle mainBundle]loadNibNamed:@"FPTextFieldTableViewCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)dealloc {
    [customTextField release];
    [super dealloc];
}

@end
