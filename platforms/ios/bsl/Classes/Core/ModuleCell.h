//
//  ModuleCell.h
//  Cube
//
//  Created by Justin Yip on 10/14/12.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ModuleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet AsyncImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *actionImageView;

@end
