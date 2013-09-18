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

@property(assign,nonatomic) NSString *moduleIdentifier;
@property(assign,nonatomic) id<DownloadCellDelegate> delegate;

@property (retain, nonatomic) IBOutlet IconButton *iconButton;

-(void)configWithModule:(CubeModule *)module;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;
@property (retain, nonatomic) IBOutlet UIButton *downloadButton;
- (IBAction)download:(id)sender;

@end
