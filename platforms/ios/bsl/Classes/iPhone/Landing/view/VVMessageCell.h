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
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIView *playView;

@property (nonatomic, strong) id<VVMessageCellDelegate>delegate;
@property (nonatomic, strong) NSURL* recordedFile;
@property (nonatomic, assign) BOOL isUser;

- (IBAction)play:(id)sender;
-(void)alignLeft;
-(void)alignRight;

@end
