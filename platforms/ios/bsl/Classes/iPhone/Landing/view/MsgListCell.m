//
//  TestCell.m
//  Cube-iOS
//
//  Created by Pepper's mpro on 12/10/12.
//
//

#import "MsgListCell.h"
#import "RatingView.h"

@interface MsgListCell ()

@end

@implementation MsgListCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rateView = [[RatingView alloc] initWithFrame:CGRectMake(100, 50, 100, 20)];
    }
    return self;
}

- (void)dealloc {
    [_headPhoto release];
    [_headText release];
    [_msgTitle release];
    [_msgContent release];
    [_receiveTime release];
    [_rateView release];
    [super dealloc];
}

@end
