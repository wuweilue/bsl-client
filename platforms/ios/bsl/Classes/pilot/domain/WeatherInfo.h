//
//  WeatherInfo.h
//  pilot
//
//  Created by Sencho Kong on 12-11-14.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject


@property(nonatomic,retain)NSString* arpType;       //机场类型
@property(nonatomic,retain)NSString* arpName;       //机场名称
@property(nonatomic,retain)NSArray*  optTxts;        //气象内容

@end
