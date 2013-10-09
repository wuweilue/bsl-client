//
//  QueryTableCell.m
//  pilot
//
//  Created by wuzheng on 13-6-25.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "QueryTableCell.h"

@implementation QueryTableCell

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
    [_tilteLabel release];
    [_myTextField release];
    [_valueLabel release];
    [super dealloc];
}
@end
