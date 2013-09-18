//
//  FunctionDetialInfoViewController.h
//  Cube-iOS
//
//  Created by 陈 晶多 on 13-1-15.
//
//

typedef enum
{
    EBTNINSTALL1,
    EBTNUPDATE1,
    EBTNDELETE1,
    EBTNSYN1
}curConfigTitletatus1;

#import <UIKit/UIKit.h>
#import "CubeModule.h"
#import "AsyncImageView.h"
#import "DownloadingTableViewCell.h"
#import "NativePageControl.h"
#import "FunctionDetailScrollView.h"
#import "FunctionDetailScrollViewWrapper.h"
#import "InstallButton.h"
#import "JSONKit.h"


@interface FunctionDetialInfoViewController : UIViewController<UIScrollViewDelegate,FunctionDetailScrollViewDataSource,UIAlertViewDelegate>
{
    BOOL firstEnter;
}
@property (copy, nonatomic) NSString *identifier;
@property (strong, nonatomic) CubeModule *curCubeModlue;
@property (strong, nonatomic) IconButton *iconImage;
@property (assign, nonatomic) curConfigTitletatus1 curTitle;

@property (strong, nonatomic) IBOutlet UILabel *functionName;
@property (strong, nonatomic) IBOutlet UITextView *describeText;
@property (strong, nonatomic) IBOutlet UILabel *newestVersion;
@property (strong, nonatomic) IBOutlet InstallButton *configButton;
@property (assign, nonatomic) enum InstallButtonStatus buttonStatus;
@property (weak, nonatomic) id<DownloadCellDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *iconUrlArr;
@property (strong, nonatomic) IBOutlet NativePageControl *pageControl;
@property (strong, nonatomic) IBOutlet FunctionDetailScrollView *dispayScrollView;
@property (strong, nonatomic) IBOutlet FunctionDetailScrollViewWrapper *wrapper;
- (IBAction)clickConfigButton:(id)sender;
- (IBAction)pageChange:(id)sender;
- (void)enableDetialInfoNotification;
- (void)disableDetialInfoNotification;
@end
