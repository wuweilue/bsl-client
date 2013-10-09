//
//  NewLoginViewCell.m
//  Mcs
//
//  Created by shaomou chen on 6/11/12.
//  Copyright (c) 2012 RYTong. All rights reserved.
//

#import "LoginViewCell.h"

@implementation LoginViewCell
@synthesize valueTextField;
@synthesize keyLabel;
@synthesize rememberBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)configure:(NSString *)key value:(NSString *)value secure:(BOOL)secure{

    self.keyLabel.text = key;
    self.valueTextField.placeholder = value;
    [self.valueTextField setSecureTextEntry:secure];
    //eidt by SenchoKong 2012 06 14
    [self.valueTextField setBorderStyle:UITextBorderStyleNone];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [valueTextField release];
    [keyLabel release];
    [rememberBtn release];
    [super dealloc];
}
@end
