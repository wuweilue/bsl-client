//
//  Member.h
//  pilot
//
//  Created by Sencho Kong on 12-11-21.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property(nonatomic,retain)NSString* empId;    //员工号
@property(nonatomic,retain)NSString* chnName;     //姓名
@property(nonatomic,retain)NSString* position; //职务
@property(nonatomic,retain)NSString* base;     //基地
@property(nonatomic,retain)UIImage*  image;    //图片
@property(nonatomic,retain)NSString* birthDtT; // 生日
@property(nonatomic,retain)NSString* readyFlag;//是否准备完成  readyFlag  “C” 是完成   “R”准备中   “N”未准备

@end
