//
//  UIInstallButton.h
//  Cube-iOS
//
//  Created by 甄健鹏(Alfredo) on 1/23/13.
//
//

#import <UIKit/UIKit.h>
#import "CubeModule.h"

enum InstallButtonStatus{
    InstallButtonStateUninstall  = 0,
    InstallButtonStateInstalling = 1,
    InstallButtonStateInstalled  = 2,
    InstallButtonStateUpdatable  = 3,
    InstallButtonStateUpdating   = 4,
    InstallButtonStateDeleting   = 5,
    InstallButtonStateSynFailed  = 6,
    InstallButtonStateSyn
};

@interface InstallButton : UIButton

@property (readwrite,nonatomic) enum InstallButtonStatus btnStatus;

-(void)observerOperation:(id)observedObj;
-(void)removeSelfFromObserverObj;
@end
