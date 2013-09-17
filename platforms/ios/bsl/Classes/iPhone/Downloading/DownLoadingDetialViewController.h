//
//  DownLoadingDetialViewController.h
//  cube-ios
//
//  Created by 东 on 3/5/13.
//
//


typedef enum
{
    EBTNINSTALL,
    EBTNUPDATE,
    EBTNDELETE,
    EBTNSYN
}curConfigTitletatus;

#import <UIKit/UIKit.h>
#import "CubeModule.h"
#import "AsyncImageView.h"
#import "DownloadingTableViewCell.h"
#import "NativePageControl.h"
#import "InstallButton.h"
#import "JSONKit.h"


@interface DownLoadingDetialViewController : UIViewController<UIAlertViewDelegate,UIScrollViewDelegate>{
   BOOL firstEnter;

}

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) CubeModule *curCubeModlue;
@property (strong, nonatomic) IconButton *iconImage;
@property (assign, nonatomic) curConfigTitletatus curTitle;
@property (strong, nonatomic) IBOutlet UIImageView *scorllImageView;

@property (strong, nonatomic) NativePageControl* pageControl;

@property (strong, nonatomic) IBOutlet UILabel *functionName;
@property (strong, nonatomic) IBOutlet UITextView *describeText;
@property (strong, nonatomic) IBOutlet UILabel *newestVersion;
@property (strong, nonatomic) IBOutlet InstallButton *configButton;
@property (assign, nonatomic) enum InstallButtonStatus buttonStatus;
@property (weak, nonatomic) id<DownloadCellDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *iconUrlArr;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (IBAction)clickConfigButton:(id)sender;
- (void)enableDetialInfoNotification;
- (void)disableDetialInfoNotification;


@end
