//
//  AnnouncementTableViewCell.h
//  Cube-iOS
//
//  Created by chen shaomou on 2/5/13.
//
//

#import <UIKit/UIKit.h>
#import "Announcement.h"

@interface AnnouncementTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *isReadLabel;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIImageView *timeImage;

@property (strong, nonatomic) IBOutlet UIView *line1;

-(void)configoure:(Announcement *)announcement isEdit:(BOOL) edit;

-(void)moveView;

-(void)initView:(BOOL)edit;

@end
