//
//  ArticleInfo.h
//  pilot
//
//  Created by lei chunfeng on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleInfo : NSObject

@property (nonatomic, retain) NSString *seqID;  //通告编号
@property (nonatomic, retain) NSString *typeID;  //通告类型
@property (nonatomic, retain) NSString *deptID;  //部门号
@property (nonatomic, retain) NSString *baseCode;  //基地代码
@property (nonatomic, retain) NSString *title;  //标题
@property (nonatomic, retain) NSString *issuerDate;  //发布时间
@property (nonatomic, retain) NSString *content;  //通告文本名字
@property (nonatomic, retain) NSString *source;  //文章来源
@property (nonatomic, retain) NSString *fdFlag;  //飞行/乘务标识
@property (nonatomic, retain) NSArray *annexNameList;  //附件名
@property (nonatomic, retain) NSString *contentTxt;  //文件内容
@property (nonatomic, retain) NSArray *annexURLList;  //文件附件URL

@end