//
//  MenuView.h
//  Cube-iOS
//
//  Created by Mr.幸 on 12-12-14.
//
//

#import <UIKit/UIKit.h>

typedef enum{
    MenuViewRefreshButton = 0,
    MenuViewFeedbackButton,
    MenuViewHelpButton,
    MenuViewAboutButton,
    MenuViewSettingButton
}MeneViewButton;

@protocol MenuViewDelegate <NSObject>

-(void)clickedButton:(MeneViewButton)menuViewButton;

@end

@interface MenuView : UIView
@property (retain, nonatomic) IBOutlet UIButton *refreshButton;
@property (retain, nonatomic) IBOutlet UIButton *feelbackButton;
@property (retain, nonatomic) IBOutlet UIButton *helpButton;
@property (retain, nonatomic) IBOutlet UIButton *aboutButton;
@property (retain, nonatomic) IBOutlet UIButton *settingButton;

@property (retain, nonatomic) id<MenuViewDelegate> delegate;


- (IBAction)click:(id)sender;

@end
