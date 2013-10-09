//
//  FPFlightNoticeCell.m
//  pilot
//
//  Created by Sencho Kong on 12-11-21.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPFlightNoticeCell.h"

@implementation FPFlightNoticeCell


@synthesize arpName = _arpName;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize locationName = _locationName;
@synthesize useful = _useful;
@synthesize elevation = _elevation;
@synthesize var = _var;
@synthesize timezone = _timezone;
@synthesize comment = _comment;
@synthesize arpShortCode = _arpShortCode;
@synthesize arpLongCode = _arpLongCode;
@synthesize fir = _fir;
@synthesize country = _country;
@synthesize railway = _railway;
@synthesize summertime = _summertime;
@synthesize insrailway = _insrailway;
@synthesize routeLabel = _routeLabel;
@synthesize queryTimeLabel = _queryTimeLabel;
@synthesize effectTimeLabel = _effectTimeLabel;
@synthesize infoAreaLabel = _infoAreaLabel;
@synthesize alterAreaLabel = _alterAreaLabel;
@synthesize otherAirportLabel = _otherAirportLabel;
@synthesize route=_route;

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

+(FPFlightNoticeCell *)getInstance{
    
    return  [[[NSBundle mainBundle]loadNibNamed:@"FPFlightNoticeCell" owner:self options:nil]objectAtIndex:0];
}

+(FPFlightNoticeCell *)getNoticeInstance{
    
    return  [[[NSBundle mainBundle]loadNibNamed:@"FPFlightNoticeCell" owner:self options:nil]objectAtIndex:1];
}

+(FPFlightNoticeCell *)getInfoInstance{
    
    return  [[[NSBundle mainBundle]loadNibNamed:@"FPFlightNoticeCell" owner:self options:nil]objectAtIndex:2];
}

-(void)infoCellSetNeedDisplay{
    
    [self.routeTitle setNeedsDisplay];
    [self.route setNeedsDisplay];
    [self.infoAreaTitle setNeedsDisplay];
    [self.infoAreaLabel setNeedsDisplay];
    [self.alertAreaTitle setNeedsDisplay];
    [self.alterAreaLabel setNeedsDisplay];
    [self.otherAirportLabel setNeedsDisplay];
    [self.otherAirportTitle setNeedsDisplay];
    
}


- (void)dealloc {
    [_arpName release];
    [_latitude release];
    [_longitude release];
    [_locationName release];
    [_useful release];
    [_elevation release];
    [_var release];
    [_timezone release];
    [_comment release];
    [_arpShortCode release];
    [_arpLongCode release];
    [_fir release];
    [_country release];
    [_railway release];
    [_summertime release];
    [_insrailway release];
    [_routeLabel release];
    [_queryTimeLabel release];
    [_effectTimeLabel release];
    [_infoAreaLabel release];
    [_alterAreaLabel release];
    [_otherAirportLabel release];
    [_route release];
    [_routeTitle release];
    [_infoAreaTitle release];
    [_alertAreaTitle release];
    [_otherAirportTitle release];
    [super dealloc];
}
@end
