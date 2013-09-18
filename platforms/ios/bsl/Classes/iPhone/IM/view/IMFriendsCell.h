//
//  IMFriendsCell.h
//  cube-ios
//
//  Created by 东 on 13-3-12.
//
//

#import <UIKit/UIKit.h>

@interface IMFriendsCell : UITableViewCell{
}
@property (strong, nonatomic) IBOutlet UILabel *lastDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (strong,nonatomic) IBOutlet UIImageView *collectedImageView;
@property (strong,nonatomic) UserInfo *user;

@end
