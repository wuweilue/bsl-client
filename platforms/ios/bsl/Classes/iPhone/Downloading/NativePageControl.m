//
//  NativePageControl.m
//  CSMBP
//
//  Created by 晶多 陈 on 12-3-29.
//  Copyright (c) 2012年 Forever OpenSource Software Inc. All rights reserved.
//

#import "NativePageControl.h"

@interface NativePageControl(private)

- (void) updateDots;

@end

@implementation NativePageControl (private)

- (void) updateDots
{
	if (imagePageStateNormal || imagePageStateHightlighted) {
		NSArray *subView = self.subviews;
		
		for (int i = 0; i < [subView count]; i++) {
			UIImageView *dot = [subView objectAtIndex:i];
			dot.image = (self.currentPage == i ? imagePageStateHightlighted : imagePageStateNormal);
		}
	}
}

@end

@implementation NativePageControl

@synthesize imagePageStateNormal,imagePageStateHightlighted;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void) setImagePageStateNormal:(UIImage *)image
{
	imagePageStateNormal = image;
	[self updateDots];
}

- (void) setImagePageStateHightlighted:(UIImage *)image
{
	imagePageStateHightlighted = image;
	[self updateDots];
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	[self updateDots];
}

- (void)dealloc {
	imagePageStateNormal = nil;
	imagePageStateHightlighted = nil;
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
