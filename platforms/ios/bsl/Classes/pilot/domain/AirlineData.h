//
//  AirlineData.h
//  pilot
//
//  Created by Sencho Kong on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirlineData : NSObject

@property(nonatomic,retain)NSString* arpShortCode;   //机场名的三字码
@property(nonatomic,retain)NSString* arpName;        //机场名
@property(nonatomic,retain)NSString* arpLongCode;    //机场名四字码
@property(nonatomic,retain)NSString* latitude;       //纬度
@property(nonatomic,retain)NSString* longitude;      //经度
@property(nonatomic,retain)NSString* locationName;   //地名
@property(nonatomic,retain)NSString* fir;            //情报区
@property(nonatomic,retain)NSString* useful;         //用途
@property(nonatomic,retain)NSString* ifInternat;     //是否国际机场
@property(nonatomic,retain)NSString* elevation;      //标高
@property(nonatomic,retain)NSString* var;            //磁差
@property(nonatomic,retain)NSString* railway;        //跑道长
@property(nonatomic,retain)NSString* summertime;     //夏令时
@property(nonatomic,retain)NSString* timezone;       //时区
@property(nonatomic,retain)NSString* insrailway;     //仪表跑道
@property(nonatomic,retain)NSString* comment;        //备注
@property(nonatomic,retain)NSString* country;        //国家名
@property(nonatomic,retain)NSString* arpFileUrl;     //机场特点文件下载路径


@end
