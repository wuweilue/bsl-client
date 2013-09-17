//
//  DownloadingTableViewCell.h
//  Cube-iOS
//
//  Created by chen shaomou on 12/9/12.
//
//

#import <UIKit/UIKit.h>
#import "CubeModule.h"
#import "IconButton.h"

@protocol DownloadCellDelegate <NSObject>
@optional
- (void)downloadAtModuleIdentifier:(NSString *)identifier  andCategory:(NSString *)category;;
- (void)deleteAtModuleIdentifier:(NSString *)identifier;
- (void)clickItemWithIndex:(int)aIndex andIdentifier:(NSString*)aStr;
- (void)inStalledModuleIdentifierr:(NSString *)identifier;
@end

@interface DownloadingTableViewCell : UITableViewCell<IconButtonDelegate>

@property(weak,nonatomic) NSString *moduleIdentifier;
@property(weak,nonatomic) id<DownloadCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet IconButton *iconButton;

-(void)configWithModule:(CubeModule *)module;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
- (IBAction)download:(id)sender;

@end
