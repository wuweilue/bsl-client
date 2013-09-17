//
//  AudioView.m
//  cube-ios
//
//  Created by hibad(Alfredo) on 13/6/13.
//
//

#import "AudioView.h"
#import <QuartzCore/QuartzCore.h>

#define AudioFrame iPhone5?CGRectMake(110,110+88,100,100):CGRectMake(110,110,100,100)
#define BackgroundFrame CGRectMake(0,0,100,100)
#define MicFrame CGRectMake(30,10,70,70)
#define LevelFrame CGRectMake(10, 10, 35, 70)


@implementation AudioView
@synthesize levelImageView;
@synthesize images;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 1;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

+(AudioView *) sharedView{
    static dispatch_once_t once;
    static AudioView *audioView;
    dispatch_once(&once,^{
        audioView = [[AudioView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        @autoreleasepool {
            for (int i = 0; i < 11; i++) {
                NSString *imageName = [NSString stringWithFormat:@"amp_land_%d.png",i+1];
                UIImage *image = [UIImage imageNamed:imageName];
                [images addObject:image];
            }
        }
        audioView.images = images;
        [audioView drawPowerView];
    });
    return audioView;
}


-(void)drawPowerView{
    UIView *powerView = [[UIView alloc] initWithFrame:AudioFrame];
    powerView.layer.cornerRadius = 5;
    powerView.layer.masksToBounds = YES;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"chat_voice_record_bg.png"];
    UIImage *micImage = [UIImage imageNamed:@"chatroom_voice_dialog.png"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:BackgroundFrame];
    backgroundView.image = backgroundImage;
    UIImageView *micView = [[UIImageView alloc] initWithFrame:MicFrame];
    micView.image = micImage;
    levelImageView = [[UIImageView alloc] initWithFrame:LevelFrame];
    [self changeLevel:1];
    [powerView addSubview:backgroundView];
    [powerView addSubview:micView];
    [powerView addSubview:levelImageView];
    
    [self addSubview:powerView];
}

+(void)dismiss{
    [[AudioView sharedView] removeFromSuperview];
}

-(void)changeLevel:(NSInteger) level{
    levelImageView.image = [images objectAtIndex:level-1];
}

@end
