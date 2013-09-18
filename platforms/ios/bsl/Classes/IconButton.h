//
//  IconButton.h
//  Cube-iOS
//
//  Created by chen shaomou on 12/7/12.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "JSBadgeView.h"
#import "CubeModule.h"

typedef  enum {
    IconAppComplete=0,
    IconAppAdd,
    IconAppUpdate
}IconLeftStatus;

enum IconStauts {
    //现在可以用
    IconButtonStautsUseable = 0 ,
    //需要升级
    IconButtonStautsNeedUpdate = 1,
    //添加
    IconButtonStautsAdd = 2,
    //可以下载
    IconButtonStautsDownloadEnable = 3,
    //固件
    IconButtonStautsFirmware = 4,
    //正在下载
    IconButtonStautsDownloading = 5,
    //可删除状态
    IconButtonStautsDelete = 6
    };

@protocol IconButtonDelegate <NSObject>
@optional

- (void)launch:(int)index identifier:(NSString *)identifier;
- (void)download:(id)sender identifier:(NSString *)identifier;
- (void)removeFromSpringboard:(int)index;
- (void)removeEnuseableModuleFromSpringboard:(NSString *)identifier index:(int)index;
- (void)enableEditingMode;
@end

@interface IconButton : UIView<UIAlertViewDelegate>{
     BOOL deletable;//是否可以删除
}
- (IBAction)didClickActionButton:(id)sender;
- (IBAction)didClickRemoveButton:(id)sender;
- (IBAction)pressActionButtonLong:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *removeButton;
@property int stauts;
@property (strong, nonatomic) IBOutlet UIView *downloadMaskView;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet UILabel *iconLabel;
@property (strong, nonatomic) IBOutlet UIImageView *updateableImageView;
@property (strong, nonatomic) IBOutlet AsyncImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (copy, nonatomic) NSString *category;
@property (weak, nonatomic) id <IconButtonDelegate> delegate;
@property (copy, nonatomic) NSString *identifier;
@property (strong, nonatomic) UIImageView *leftImageView;
@property(nonatomic,copy) void (^callbackAction)(IconButton*);
@property (nonatomic, assign) int tag;
@property BOOL isRemovable;
@property BOOL isInEditingMode;
@property BOOL isShowMode;

@property (strong, nonatomic) JSBadgeView *badgeView;
@property BOOL hidden;


- (id)initWithIdentifier:(NSString *)identifier iconName:(NSString *)iconName IconImageUrl:(NSString *)iconImageUrl iconStauts:(int)staut delegate:(id<IconButtonDelegate>)delegate;

-(id)initWithModule:(CubeModule *)module stauts:(int)staut delegate:(id<IconButtonDelegate>)delegate_;

- (void) checkDetial:(id)sender;
- (void) enableEditing;
- (void) disableEditing;
- (void) transformWithWidth:(NSInteger)aWidth andHeight:(NSInteger)aHeight;
- (void) updateTag:(int) newTag;
-(void)observerDownload:(id)observedObj;
- (void)transformFixIcon:(IconLeftStatus)curStatus;
- (void)defaultSet;

-(void)addBadgeWithModuleIdentifier:(NSString *)moduleName;
-(void)addBadge;
-(void)removeBadge;
-(void)removeNotification;

@end


