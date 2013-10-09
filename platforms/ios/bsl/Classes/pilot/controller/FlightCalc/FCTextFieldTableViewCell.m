//
//  FCTextFieldTableViewCell.m
//  pilot
//
//  Created by leichunfeng on 13-2-4.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "FCTextFieldTableViewCell.h"

@implementation FCTextFieldTableViewCell

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

+ (FCTextFieldTableViewCell *)getInstance {
    return [[[NSBundle mainBundle] loadNibNamed:@"FCTextFieldTableViewCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)dealloc {
    [_customLabel release];
    [_customTextField release];
    [super dealloc];
}
@end
