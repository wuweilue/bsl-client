//
//  AirPath.h
//  pilot
//
//  Created by Sencho Kong on 12-12-25.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirPath : NSObject




@property(nonatomic,retain)NSString* fileName;  //文件名
@property(nonatomic,retain)NSString* operTm;    //上传时间
@property(nonatomic,retain)NSString* fltNr;      //航班号
@property(nonatomic,retain)NSString* tailNr;    //机尾号
@property(nonatomic,retain)NSString* depArpCode;//出发机场代码
@property(nonatomic,retain)NSString* arvArpCode;//到达机场代码
@property(nonatomic,retain)NSString* fileType;  //文件类型
@property(nonatomic,retain)NSString* depDt;     //出发时刻

@end
