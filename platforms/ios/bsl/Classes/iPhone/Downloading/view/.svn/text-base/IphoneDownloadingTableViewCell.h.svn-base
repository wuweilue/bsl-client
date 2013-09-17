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

@property(assign,nonatomic) NSString *moduleIdentifier;
@property(assign,nonatomic) id<DownloadCellDelegate> delegate;
@property (retain,nonatomic) UIAlertView* alertMessageView;
@property (retain, nonatomic) IBOutlet IconButton *iconButton;
-(void)configWithModule:(CubeModule *)module andConfig:(cellConfig)curConfig;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;
@property (retain, nonatomic) IBOutlet InstallButton *downloadButton;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel; //用于首页列表
- (IBAction)download:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *releasenoteLabel;

@end
