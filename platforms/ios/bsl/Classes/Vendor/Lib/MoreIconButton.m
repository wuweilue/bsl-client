//
//  MoreIconButton.m
//  Cube-iOS
//
//  Created by Mr.幸 on 13-1-7.
//
//

#import "MoreIconButton.h"

@implementation MoreIconButton
@synthesize moreButton = _moreButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MoreIconButton" owner:self options:nil]objectAtIndex:0];
    }
    return self;
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
