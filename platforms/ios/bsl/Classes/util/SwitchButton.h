//
//  SwitchButton.h
//  Cube-iOS
//
//  Created by 陈 晶多 on 13-1-22.
//
//

#import <UIKit/UIKit.h>

#if NS_BLOCKS_AVAILABLE

#endif


@interface SwitchButton : UIView{

}
@property (nonatomic,assign) BOOL rightOpen;
@property (nonatomic,strong) UIButton *segOneCombineButton;
@property (nonatomic,strong) UIButton *segTwoCombineButton;
@property (nonatomic,weak) id delegate;

-(void)patch;
@end
