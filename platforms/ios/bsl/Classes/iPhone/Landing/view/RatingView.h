//
//  RatingView.h
//  Cube-iOS
//
//  Created by Pepper's mpro on 12/10/12.
//
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView
{
    UIImageView *foregroundRatingView;
    UIImageView *backgroundRatingView;
}


@property (nonatomic,assign)float rating;

@end
