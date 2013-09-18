//
//  XMPPShowImageViewController.h
//  cube-ios
//
//  Created by zhoujun on 13-6-9.
//
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"
@interface XMPPShowImageViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIImage *__weak image;
    
    CGFloat lastDistance;
	
	CGFloat imgStartWidth;
	CGFloat imgStartHeight;
	
}
@property (nonatomic, strong) UIImageView *imageView;
@property(nonatomic,readwrite,weak)UIImage *image;
@property (nonatomic, strong) MRZoomScrollView  *zoomScrollView;
@end
