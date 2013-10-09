//
//  FPWeatherInfoCell.h
//  pilot
//
//  Created by Sencho Kong on 12-12-3.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirportWeatherInfo.h"
#import "WeatherInfo.h"

 //定义两种类型的Cell
typedef enum{
    
    kHeadCell,    //顶部的cell
    kMiddleCell   //中间有内容的cell
    
    
}ContentStyle;


@interface FPWeatherInfoCell : UITableViewCell


@property(nonatomic,retain)AirportWeatherInfo* airportWeatherInfo;
@property(nonatomic,retain)WeatherInfo* weatherInfo;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contentViewStyle:(ContentStyle)contentViewStyle;

@end
