//
//  FPHealthDeclarationTableViewCell.m
//  pilot
//
//  Created by lei chunfeng on 12-11-9.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPHealthDeclarationTableViewCell.h"

@implementation FPHealthDeclarationTableViewCell

@synthesize unHealthyCountDescriptionLabel;
@synthesize unHealthyCountLabel;
@synthesize staffNumLabel;
@synthesize nameLabel;
@synthesize taskFlightLabel;
@synthesize aircraftModelLabel;
@synthesize declarationTimeLabel;

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
    [unHealthyCountDescriptionLabel release];
    [unHealthyCountLabel release];
    [staffNumLabel release];
    [nameLabel release];
    [taskFlightLabel release];
    [aircraftModelLabel release];
    [declarationTimeLabel release];
    [super dealloc];
}

+ (FPHealthDeclarationTableViewCell *)getInstance {
    return [[[NSBundle mainBundle]loadNibNamed:@"FPHealthDeclarationTableViewCell" owner:nil options:nil] objectAtIndex:0];
}

@end
