//
//  VVMessageCell.h
//  IMDemo
//
//  Created by Justin Yip on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VVMessageCell;

@protocol VVMessageCellDelegate <NSObject>

@optional

-(void)playRecorder:(NSURL *)theRecordedFile isUser:(BOOL)userOrnot;

@end

@interface VVMessageCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *userLabel;
@property (retain, nonatomic) IBOutlet UIButton *playButton;
@property (retain, nonatomic) IBOutlet UIView *playView;

@property (nonatomic, retain) id<VVMessageCellDelegate>delegate;
@property (nonatomic, retain) NSURL* recordedFile;
@property (nonatomic, assign) BOOL isUser;

- (IBAction)play:(id)sender;
-(void)alignLeft;
-(void)alignRight;

@end
