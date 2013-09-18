//
//  FunctionDetailScrollViewWrapper.m
//  Cube-iOS
//
//  Created by Pepper's mpro on 1/24/13.
//
//

#import "FunctionDetailScrollViewWrapper.h"

@implementation FunctionDetailScrollViewWrapper

@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
	[_scrollView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIView methods

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
		return _scrollView;
	}
	return nil;
}

@end
