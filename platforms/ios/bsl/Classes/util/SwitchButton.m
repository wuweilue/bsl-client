//
//  SwitchButton.m
//  Cube-iOS
//
//  Created by 陈 晶多 on 13-1-22.
//
//

#import "SwitchButton.h"

@implementation SwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)patch
{
    _segOneCombineButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0, (float)self.frame.size.width/2, self.frame.size.height)];
    _segTwoCombineButton=[[UIButton alloc] initWithFrame:CGRectMake((float)self.frame.size.width/2,0, (float)self.frame.size.width/2, self.frame.size.height)];
    
    [_segOneCombineButton addTarget:self action:@selector(changeViewSight:) forControlEvents:UIControlEventTouchUpInside];
    [_segTwoCombineButton addTarget:self action:@selector(changeViewSight:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_segOneCombineButton];
    [self addSubview:_segTwoCombineButton];
    
    if (!_rightOpen) {
        [_segOneCombineButton setBackgroundImage:[UIImage imageNamed:@"switch_btn_left_active@2x.png"] forState:UIControlStateNormal];
        [_segTwoCombineButton setBackgroundImage:[UIImage imageNamed:@"switch_btn_right@2x.png"] forState:UIControlStateNormal];
    }else
    {
        [_segOneCombineButton setBackgroundImage:[UIImage imageNamed:@"switch_btn_left@2x.png"] forState:UIControlStateNormal];
        [_segTwoCombineButton setBackgroundImage:[UIImage imageNamed:@"switch_btn_right_active@2x.png"] forState:UIControlStateNormal];
    }
    
}

-(void)changeViewSight:(id)sender
{
    UIButton *currentButton=(UIButton*)sender;
    if (currentButton==_segOneCombineButton) {
        [_segOneCombineButton setBackgroundImage:[UIImage imageNamed:@"switch_btn_left_active@2x.png"] forState:UIControlStateNormal];
        [_segTwoCombineButton setBackgroundImage:[UIImage imageNamed:@"switch_btn_right@2x.png"] forState:UIControlStateNormal];
    }else
    {
        [_segOneCombineButton setBackgroundImage:[UIImage imageNamed:@"switch_btn_left@2x.png"] forState:UIControlStateNormal];
        [_segTwoCombineButton setBackgroundImage:[UIImage imageNamed:@"switch_btn_right_active@2x.png"] forState:UIControlStateNormal];
    }
    if ((!_rightOpen&&currentButton==_segTwoCombineButton)||(_rightOpen&&currentButton==_segOneCombineButton)) {

        if(_delegate && [_delegate respondsToSelector:@selector(didClickSwitchButton)]){
        
            [_delegate performSelector:@selector(didClickSwitchButton)];
        }
        _rightOpen=!_rightOpen;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
