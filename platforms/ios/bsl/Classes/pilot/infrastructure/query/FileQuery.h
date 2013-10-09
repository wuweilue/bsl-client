//
//  FileQuery.h
//  pilot
//
//  Created by chen shaomou on 11/5/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILEDOWN_HEAD_PHOTO @"HEAD_PIC"
#define FILEDOWN_CLUDE_MAP @"CLUDE_MAP"
#define FILEDOWN_NOTIFICATION_FILE @"NOTIFICATION_FILE"

#define FLY_MAP @"FLY_MAP"               //航图
#define HEAD_PIC @"HEAD_PIC"             //头像
#define NOTICE_CONTENT @"NOTICE_CONTENT" //重要文件正文内容
#define NOTICE_ANNEX @"NOTICE_ANNEX_CAN"
#define AIRPORT_FILE @"AIRPORT_FILE"     //机场特点
#define WEATHER_MAP @"WEATHER_MAP"       //卫星云图
#define AIRPATH @"AIRPATH"               //飞行计划报文


#import "BaseQuery.h"
@interface FileQuery : BaseQuery

-(void)queryWeatherMapNameListWithremotePath:(NSString *)remotePath andType:(NSString *)type andArea:(NSString *)area completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed;

- (void)downloadFileWithRemotePath:(NSString *)remotePath AndFileName:(NSString *)fileName AndFileType:(NSString *)fileType inTimeFlag:(NSString *)inTimeFlag completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed;

- (void)downloadTowFileWithPlaneType:(NSString *)planeType AndFileName:(NSString *)fileName completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed;

- (void)downloadPlanFileWithFlightNo:(NSString *)fltNr fltDt:(NSString *)fltDt arvArpCd:(NSString *)arvArpCd depArpCd:(NSString *)depArpCd completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed;

-(void)cancelQuery;
@end
