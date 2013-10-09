//
//  AirportWeatherInfo.h
//  pilot
//
//  Created by Sencho Kong on 12-11-14.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AirportWeatherInfo : NSObject

@property(nonatomic,retain)NSString* queryTime;      //查询时间
@property(nonatomic,retain)NSString* depArpCd;       //起飞机场四字代码
@property(nonatomic,retain)NSString* arvArpCd;       //到达机场四字代码
@property(nonatomic,retain)NSString* arvArpFullName; //到达机场全称
@property(nonatomic,retain)NSString* depArpFullName; //起飞机场全称
@property(nonatomic,retain)NSArray*  weatherInfos;   //各个机场气象信息列表


@end
