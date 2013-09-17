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

@property (retain, nonatomic) NSString *identifier;
@property (retain, nonatomic) CubeModule *curCubeModlue;
@property (retain, nonatomic) IconButton *iconImage;
@property (assign, nonatomic) curConfigTitletatus curTitle;
@property (retain, nonatomic) IBOutlet UIImageView *scorllImageView;

@property (retain, nonatomic) NativePageControl* pageControl;

@property (retain, nonatomic) IBOutlet UILabel *functionName;
@property (retain, nonatomic) IBOutlet UITextView *describeText;
@property (retain, nonatomic) IBOutlet UILabel *newestVersion;
@property (retain, nonatomic) IBOutlet InstallButton *configButton;
@property (assign, nonatomic) enum InstallButtonStatus buttonStatus;
@property (assign, nonatomic) id<DownloadCellDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *iconUrlArr;
@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (IBAction)clickConfigButton:(id)sender;
- (void)enableDetialInfoNotification;
- (void)disableDetialInfoNotification;


@end
