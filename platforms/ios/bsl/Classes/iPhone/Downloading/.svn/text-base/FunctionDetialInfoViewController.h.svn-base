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
@property (retain, nonatomic) CubeModule *curCubeModlue;
@property (retain, nonatomic) IconButton *iconImage;
@property (assign, nonatomic) curConfigTitletatus1 curTitle;

@property (retain, nonatomic) IBOutlet UILabel *functionName;
@property (retain, nonatomic) IBOutlet UITextView *describeText;
@property (retain, nonatomic) IBOutlet UILabel *newestVersion;
@property (retain, nonatomic) IBOutlet InstallButton *configButton;
@property (assign, nonatomic) enum InstallButtonStatus buttonStatus;
@property (assign, nonatomic) id<DownloadCellDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *iconUrlArr;
@property (retain, nonatomic) IBOutlet NativePageControl *pageControl;
@property (retain, nonatomic) IBOutlet FunctionDetailScrollView *dispayScrollView;
@property (retain, nonatomic) IBOutlet FunctionDetailScrollViewWrapper *wrapper;
- (IBAction)clickConfigButton:(id)sender;
- (IBAction)pageChange:(id)sender;
- (void)enableDetialInfoNotification;
- (void)disableDetialInfoNotification;
@end
