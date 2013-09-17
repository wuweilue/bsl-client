//
//  RecordingView.m
//  cube-ios
//
//  Created by apple2310 on 13-9-9.
//
//

#import "RecordingView.h"

#import <QuartzCore/QuartzCore.h>

@implementation RecordingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:2];
        for(int i=1;i<11;i++){
            UIImage* img=[UIImage imageNamed:[NSString stringWithFormat:@"VoiceSearchLoading%03d.png",i]];
            [array addObject:img];
        }
        

        backView=[[UIView alloc] init];
        backView.backgroundColor=[UIColor blackColor];
        backView.alpha=0.8f;
        backView.layer.cornerRadius=5.0f;
        [self addSubview:backView];
        
        recordView=[[UIImageView alloc] init];
        recordView.animationImages=array;
        recordView.animationDuration=3.0f;
        recordView.animationRepeatCount=0;
        [self addSubview:recordView];
        
        
        voices = [[NSMutableArray alloc] init];
        for (int i = 0; i < 11; i++) {
            NSString *imageName = [NSString stringWithFormat:@"amp_land_%d.png",i+1];
            UIImage *image = [UIImage imageNamed:imageName];
            [voices addObject:image];
        }
        
        voiceView=[[UIImageView alloc] initWithImage:[voices objectAtIndex:0]];
        [self addSubview:voiceView];
        
        
        CGRect rect;
        rect.size=((UIImage*)[array objectAtIndex:0]).size;
        
        float width=rect.size.width +2.0f+voiceView.frame.size.width;
        
        rect.origin.x=(frame.size.width-width)*0.5f;
        rect.origin.y=(frame.size.height-rect.size.height)*0.5f;
        recordView.frame=rect;
        
        rect=voiceView.frame;
        rect.origin.x=CGRectGetMaxX(recordView.frame)+5.0f;
        rect.origin.y=CGRectGetMaxY(recordView.frame)-rect.size.height;
        voiceView.frame=rect;
        
        rect=backView.frame;
        rect.origin.x=CGRectGetMinX(recordView.frame)-15.0f;
        rect.origin.y=CGRectGetMinY(recordView.frame)-15.0f;
        rect.size.width=width+30.0f;
        rect.size.height=recordView.frame.size.height+30.0f;
        backView.frame=rect;
        
    }
    
    return self;
}


-(void)startAnimation{
    [recordView startAnimating];
    self.alpha=0.0f;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha=1.0f;
    } completion:^(BOOL finish){
    }];
}

-(void)stopAnimation{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha=0.0f;
    } completion:^(BOOL finish){
        [recordView stopAnimating];
        [self removeFromSuperview];
    }];
}

-(void)changeLevel:(NSInteger) level{
    voiceView.image = [voices objectAtIndex:level-1];
}


@end
