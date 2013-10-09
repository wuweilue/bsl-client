//
//  FPTaskTableViewCell.h
//  pilot
//
//  Created by Sencho Kong on 12-11-6.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPTaskTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *teamMemberButton;

@property (retain, nonatomic) IBOutlet UILabel *filghtNoLabel;
@property (retain, nonatomic) IBOutlet UILabel *leaderNoLabel;
@property (retain, nonatomic) IBOutlet UILabel *taskTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *depPortLabel;
@property (retain, nonatomic) IBOutlet UILabel *arrPortLabel;
@property (retain, nonatomic) IBOutlet UILabel *depTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *arrTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *planeLabel;
@property (retain, nonatomic) IBOutlet UILabel *tailNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *taskCodeLabel;
@property (retain, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *readyFlag;     //是否完成飞行准备标识

+(FPTaskTableViewCell *)getInstance;
+(FPTaskTableViewCell *) getOtherTaskInstance;



@end
