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
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UIButton *feelbackButton;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong, nonatomic) IBOutlet UIButton *settingButton;

@property (strong, nonatomic) id<MenuViewDelegate> delegate;


- (IBAction)click:(id)sender;

@end
