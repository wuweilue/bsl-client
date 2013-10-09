//
//  FPWeatherMapViewController.h
//  pilot
//
//  Created by Sencho Kong on 12-11-7.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPWeatherMapViewController : UITableViewController{
    NSArray                 *areaNames;
    NSDictionary            *weatherAreaDic;
    NSDictionary            *temperatureAreaDic;
}

@property(nonatomic,retain)NSArray* areaNames;
@property(nonatomic,retain)NSArray* tableViewData;
@property(nonatomic,retain)UISegmentedControl* weatherSegment;
@property (nonatomic, retain) NSDictionary *weatherAreaDic;
@property (nonatomic, retain) NSDictionary *temperatureAreaDic;

- (void) loadWeatherMapWithMapName:(NSString *)mapNameString andArea:(NSString *)area;

@end
