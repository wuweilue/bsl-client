//
//  AirlineAnnoun.h
//  pilot
//
//  Created by Sencho Kong on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirlineAnnounce : NSObject

@property(nonatomic,retain)NSString* effectTime;      //有效时间
@property(nonatomic,retain)NSString* queryTime;       //查询时间
@property(nonatomic,retain)NSString* route;           //航线顺序
@property(nonatomic,retain)NSString* infoArea;        //情报区机场
@property(nonatomic,retain)NSString* alterArea;       //备降区机场
@property(nonatomic,retain)NSString* other;           //其它机场
@property(nonatomic,retain)NSString* routeCH;           //航线顺序中文
@property(nonatomic,retain)NSString* infoAreaCH;        //情报区机场中文
@property(nonatomic,retain)NSString* alterAreaCH;       //备降区机场中文
@property(nonatomic,retain)NSString* otherCH;           //其它机场中文
@property(nonatomic,retain)NSArray* announceTexts; //各机场报表

@end
