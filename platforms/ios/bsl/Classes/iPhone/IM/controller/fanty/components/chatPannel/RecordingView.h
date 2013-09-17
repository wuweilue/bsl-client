//
//  RecordingView.h
//  cube-ios
//
//  Created by apple2310 on 13-9-9.
//
//

#import <UIKit/UIKit.h>

@interface RecordingView :UIView{
    
    UIView*  backView;
    UIImageView* recordView;
    UIImageView* voiceView;
    
    NSMutableArray* voices;
}

-(void)startAnimation;
-(void)stopAnimation;

-(void)changeLevel:(NSInteger) level;

@end
