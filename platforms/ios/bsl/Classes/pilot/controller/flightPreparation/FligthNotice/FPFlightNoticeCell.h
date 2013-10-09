//
//  FPFlightNoticeCell.h
//  pilot
//
//  Created by Sencho Kong on 12-11-21.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPFlightNoticeCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *arpName;

@property (retain, nonatomic) IBOutlet UILabel *latitude;
@property (retain, nonatomic) IBOutlet UILabel *longitude;
@property (retain, nonatomic) IBOutlet UILabel *locationName;
@property (retain, nonatomic) IBOutlet UILabel *useful;
@property (retain, nonatomic) IBOutlet UILabel *elevation;
@property (retain, nonatomic) IBOutlet UILabel *var;
@property (retain, nonatomic) IBOutlet UILabel *timezone;
@property (retain, nonatomic) IBOutlet UILabel *comment;
@property (retain, nonatomic) IBOutlet UILabel *arpShortCode;
@property (retain, nonatomic) IBOutlet UILabel *arpLongCode;
@property (retain, nonatomic) IBOutlet UILabel *fir;
@property (retain, nonatomic) IBOutlet UILabel *country;
@property (retain, nonatomic) IBOutlet UILabel *railway;
@property (retain, nonatomic) IBOutlet UILabel *summertime;
@property (retain, nonatomic) IBOutlet UILabel *insrailway;
@property (retain, nonatomic) IBOutlet UILabel *routeLabel;
@property (retain, nonatomic) IBOutlet UILabel *route;
@property (retain, nonatomic) IBOutlet UILabel *queryTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *effectTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *infoAreaLabel;
@property (retain, nonatomic) IBOutlet UILabel *alterAreaLabel;
@property (retain, nonatomic) IBOutlet UILabel *otherAirportLabel;
@property (retain, nonatomic) IBOutlet UILabel *routeTitle;
@property (retain, nonatomic) IBOutlet UILabel *infoAreaTitle;
@property (retain, nonatomic) IBOutlet UILabel *alertAreaTitle;
@property (retain, nonatomic) IBOutlet UILabel *otherAirportTitle;

+(FPFlightNoticeCell *)getInstance;
+(FPFlightNoticeCell *)getNoticeInstance;
+(FPFlightNoticeCell *)getInfoInstance;

-(void)infoCellSetNeedDisplay;

@end
