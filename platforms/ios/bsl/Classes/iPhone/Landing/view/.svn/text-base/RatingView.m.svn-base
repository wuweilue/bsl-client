//
//  RatingView.m
//  Cube-iOS
//
//  Created by Pepper's mpro on 12/10/12.
//
//

#import "RatingView.h"

#define MAX_RATING 5

@implementation RatingView
@synthesize rating;



-(void) commonInit
{
    backgroundRatingView = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"StarsBackground.png"]];
    backgroundRatingView.contentMode = UIViewContentModeLeft;
    [self addSubview:backgroundRatingView];
    foregroundRatingView = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"StarsForeground.png"]];
    foregroundRatingView.contentMode = UIViewContentModeLeft;
    foregroundRatingView.clipsToBounds = YES;
    [self addSubview:foregroundRatingView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self commonInit];
    }
    
    return self;
}



- (void)setRating:(float)value{
    rating = value;
    foregroundRatingView.frame = CGRectMake(0.0, 0.0, backgroundRatingView.frame.size.width * (rating / MAX_RATING), foregroundRatingView.bounds.size.height);
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
