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
@property (retain, nonatomic) IBOutlet UILabel *lastDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (retain,nonatomic) IBOutlet UIImageView *collectedImageView;
@property (retain,nonatomic) UserInfo *user;

@end
