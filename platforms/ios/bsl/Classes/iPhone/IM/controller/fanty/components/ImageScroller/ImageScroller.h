//
//  ImageScroller.h
//  cube-ios
//
//  Created by apple2310 on 13-9-10.
//
//

#import <UIKit/UIKit.h>
@class AsyncImageView;
@interface ImageScroller : UIView{
    AsyncImageView* imageView;
}

-(void)showImage:(NSString*)imageFile;

-(void)showInView:(UIView*)view;

@end
