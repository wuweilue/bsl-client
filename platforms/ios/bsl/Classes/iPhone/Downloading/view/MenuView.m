//
//  MenuView.m
//  Cube-iOS
//
//  Created by Mr.幸 on 12-12-14.
//
//

#import "MenuView.h"

@implementation MenuView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil] objectAtIndex:0];
        
        _refreshButton.tag = MenuViewRefreshButton;
        _feelbackButton.tag = MenuViewFeedbackButton;
        _helpButton.tag = MenuViewHelpButton;
        _aboutButton.tag = MenuViewAboutButton;
        _settingButton.tag = MenuViewSettingButton;
    }
    return self;
}


-(void)click:(id)sender{
    UIButton* button = sender;
    NSInteger tag = button.tag;
    switch (tag) {
        case MenuViewRefreshButton:
            [delegate clickedButton:MenuViewRefreshButton];
            break;
            
        case MenuViewFeedbackButton:
            [delegate clickedButton:MenuViewFeedbackButton];
            break;
            
        case MenuViewHelpButton:
            [delegate clickedButton:MenuViewHelpButton];
            break;
            
        case MenuViewAboutButton:
            [delegate clickedButton:MenuViewAboutButton];
            break;
            
        case MenuViewSettingButton:
            [delegate clickedButton:MenuViewSettingButton];
            break;
            
        default:
            break;
    }
}


@end
