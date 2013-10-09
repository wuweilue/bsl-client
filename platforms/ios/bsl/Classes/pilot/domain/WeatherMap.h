//
//  WeatherMap.h
//  pilot
//
//  Created by Sencho Kong on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherMap : NSObject

@property(nonatomic,retain)NSString* mapName;         //云图图片名
@property(nonatomic,retain)NSString* translatedName;  //云图显示的名
@property(nonatomic,retain)NSString* weatherType_;     //云图类型
@property(nonatomic,retain)NSString* weatherArea_;     //云图区域



-(id)initWithMapName:(NSString*)name;
@end
