//
//  FPTaskTableViewCell.m
//  pilot
//
//  Created by Sencho Kong on 12-11-6.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPTaskTableViewCell.h"

@implementation FPTaskTableViewCell

@synthesize teamMemberButton = _teamMemberButton;
@synthesize filghtNoLabel = _filghtNoLabel;
@synthesize leaderNoLabel = _leaderNoLabel;
@synthesize taskTypeLabel = _taskTypeLabel;
@synthesize depPortLabel = _depPortLabel;
@synthesize arrPortLabel = _arrPortLabel;
@synthesize depTimeLabel = _depTimeLabel;
@synthesize arrTimeLabel = _arrTimeLabel;
@synthesize planeLabel = _planeLabel;
@synthesize tailNumLabel = _tailNumLabel;
@synthesize taskCodeLabel = _taskCodeLabel;
@synthesize beginTimeLabel = _beginTimeLabel;
@synthesize endTimeLabel = _endTimeLabel;
@synthesize readyFlag=_readyFlag;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(FPTaskTableViewCell *)getInstance{
    
           return  [[[NSBundle mainBundle]loadNibNamed:@"FPTaskTableViewCell" owner:self options:nil]objectAtIndex:0];
}


+(FPTaskTableViewCell *)getOtherTaskInstance{
    
    return  [[[NSBundle mainBundle]loadNibNamed:@"FPTaskTableViewCell" owner:self options:nil]objectAtIndex:1];    
}

/*
 航班号: 0319
 确认领导: 无
 类型：飞行
 始发站：ＣＡＮ
 到达站：ＰＥＲ
 起飞时刻: 2012/05/03 00:01
 到达时刻: 2012/05/03 00:01
 机型：333
 飞行号：－－
 机组成员
 */
- (void)dealloc {
   
    [_teamMemberButton release];
    [_filghtNoLabel release];
    [_leaderNoLabel release];
    [_taskTypeLabel release];
    [_depPortLabel release];
    [_arrPortLabel release];
    [_depTimeLabel release];
    [_arrTimeLabel release];
    [_planeLabel release];
    [_tailNumLabel release];
    [_taskCodeLabel release];
    [_beginTimeLabel release];
    [_endTimeLabel release];
    [_readyFlag release];
    [super dealloc];
}
@end
