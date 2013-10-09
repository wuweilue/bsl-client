//
//  ManifestTableViewCell.m
//  pilot
//
//  Created by wuzheng on 9/19/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "ManifestTableViewCell.h"

@implementation ManifestTableViewCell
@synthesize titleLabel;
@synthesize valueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [titleLabel release];
    [valueLabel release];
    [super dealloc];
}
@end
