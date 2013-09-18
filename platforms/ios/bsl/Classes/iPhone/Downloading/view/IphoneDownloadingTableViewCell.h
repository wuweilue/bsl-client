//
//  IphoneDownloadingTableViewCell.h
//  Cube-iOS
//
//  Created by Pepper's mpro on 12/21/12.
//
//
#import <UIKit/UIKit.h>
#import "CubeModule.h"
#import "IconButton.h"
#import "DownloadingTableViewCell.h"
#import "InstallButton.h"
#import "SearchDataSource.h"

@interface IphoneDownloadingTableViewCell : UITableViewCell<IconButtonDelegate>{
    
}

@property(weak,nonatomic) NSString *moduleIdentifier;
@property(weak,nonatomic) id<DownloadCellDelegate> delegate;
@property (strong,nonatomic) UIAlertView* alertMessageView;
@property (strong, nonatomic) IBOutlet IconButton *iconButton;
-(void)configWithModule:(CubeModule *)module andConfig:(cellConfig)curConfig;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet InstallButton *downloadButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel; //用于首页列表
- (IBAction)download:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *releasenoteLabel;

@end
