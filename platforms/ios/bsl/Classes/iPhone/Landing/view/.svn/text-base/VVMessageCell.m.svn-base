//
//  VVMessageCell.m
//  IMDemo
//
//  Created by Justin Yip on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VVMessageCell.h"

@implementation VVMessageCell
@synthesize avatarImageView;
@synthesize timeLabel;
@synthesize userLabel;
@synthesize playButton;
@synthesize playView;
@synthesize recordedFile;
@synthesize delegate;
@synthesize isUser;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [timeLabel release];
    [avatarImageView release];
    [userLabel release];
    [playButton release];
    [playView release];
    [super dealloc];
}

- (IBAction)play:(id)sender {
    [delegate playRecorder:recordedFile isUser:isUser];
}

-(void)alignLeft{
    avatarImageView.image = [UIImage imageNamed:@"local_icon"];
    [playButton setBackgroundImage:[[UIImage imageNamed:@"voice_server_btn"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    userLabel.text = @"客服";
    
}

-(void)alignRight{
    avatarImageView.image = [UIImage imageNamed:@"avatar_msg"];
    avatarImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 5, avatarImageView.frame.size.width,avatarImageView.frame.size.height);
    playView.frame = CGRectMake(avatarImageView.frame.origin.x  -playView.frame.size.width, 5, playView.frame.size.width,playView.frame.size.height );
    [playButton setBackgroundImage:[[UIImage imageNamed:@"voice_local_btn"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
//#ifdef Device_Pad
//    userLabel.frame = CGRectMake(avatarImageView.frame.origin.x + 11, 71, userLabel.frame.size.width, userLabel.frame.size.height);
//#else
//    userLabel.frame = CGRectMake(avatarImageView.frame.origin.x - 2 , 41, userLabel.frame.size.width, userLabel.frame.size.height);
//#endif
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone) {
       userLabel.frame = CGRectMake(avatarImageView.frame.origin.x - 2 , 41, userLabel.frame.size.width, userLabel.frame.size.height);
    }else{
        userLabel.frame = CGRectMake(avatarImageView.frame.origin.x + 11, 71, userLabel.frame.size.width, userLabel.frame.size.height);
    }
    userLabel.text = @"用户";
}


@end
