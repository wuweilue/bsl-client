//
//  AudioView.h
//  cube-ios
//
//  Created by hibad(Alfredo) on 13/6/13.
//
//

#import <UIKit/UIKit.h>

@interface AudioView : UIView

@property (strong,nonatomic) UIImageView *levelImageView;
@property (strong,nonatomic) NSMutableArray *images;

+(AudioView *) sharedView;
+(void)dismiss;

-(void)drawPowerView;
-(void)changeLevel:(NSInteger) level;
@end
