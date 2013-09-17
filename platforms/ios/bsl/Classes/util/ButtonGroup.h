//
//  ButtonGroup.h
//  Cube-iOS
//
//  Created by hibad(Alfredo) on 13/1/29.
//
//

#import <UIKit/UIKit.h>

@interface ButtonGroup : UIControl

@property (strong,nonatomic) NSArray *buttonTitles;
@property (strong,nonatomic) NSArray *imageNames;
@property (strong,nonatomic) NSArray *activeImageNames;
@property (weak,nonatomic) id delegate;

-(id)initWithFrame:(CGRect) frame ButtonTitle:(NSArray *) titles andBackground:(NSArray *) imageNames andActiveBackground:(NSArray *) activeImageNames;
@end
