//
//  FPTextViewTableViewCell.m
//  iOSTrain
//
//  Created by leichunfeng on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FPTextViewTableViewCell.h"

@implementation FPTextViewTableViewCell

@synthesize customTextView = _customTextView;

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
    [_customTextView release];
    [super dealloc];
}

+ (FPTextViewTableViewCell *)getInstance {
    return [[[NSBundle mainBundle]loadNibNamed:@"FPTextViewTableViewCell" owner:nil options:nil] objectAtIndex:0];
}

@end
