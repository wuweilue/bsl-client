//
//  CameraPanel.h
//  cube-ios
//
//  Created by apple2310 on 13-9-7.
//
//

#import <UIKit/UIKit.h>

typedef enum{
    CameraPanelClickTypeCamera=0,
    CameraPanelClickTypePhone
}CameraPanelClickType;

@class CameraPanel;

@protocol CameraPanelDelegate <NSObject>

@optional
-(void)cameraPanelDidClick:(CameraPanel*)cameraPanel clickType:(CameraPanelClickType)cameraPanelClickType;

@end

@interface CameraPanel : UIView{
    UIButton* cameraButton;
    UIButton* phoneButton;
}

@property(nonatomic,assign)id<CameraPanelDelegate> delegate;

@end
