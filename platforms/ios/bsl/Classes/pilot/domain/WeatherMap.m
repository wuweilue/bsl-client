//
//  WeatherMap.m
//  pilot
//
//  Created by Sencho Kong on 12-11-15.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "WeatherMap.h"

@implementation WeatherMap
@synthesize mapName=_mapName;
@synthesize translatedName;
@synthesize weatherArea_;
@synthesize weatherType_;


-(id)initWithMapName:(NSString*)name{
    if (self=[super init]) {
        self.mapName=name;
    }
    return self;
}

-(void)dealloc{
    [_mapName release];
    [translatedName release];
    [weatherArea_ release];
    [weatherType_ release];
    [super dealloc];
}

-(void)setMapName:(NSString *)aMapName{
    
    if (aMapName==nil||[aMapName length]==0) {
        return;
    }
    
    if ([aMapName length]>0) {
        
        [_mapName release];
        _mapName=[aMapName retain];
        
    }
    
    aMapName=[aMapName stringByDeletingPathExtension];

    if ([aMapName length]!=22) {
        return;
    }
    
    /*
     转换中文显示名称
     
     sample: EGRR PG A E 05 2012-11-27-18-00
     
     1.发布单位取的是文件名前4个字符，取得直接拼进去文件显示文件名。
     
     2.图片类型的获取是文件名的第5个和第6个字符，重要天气图：PG 和 FN ; 风温预告图：PW , FB ； 其他字符直接显示
     
     3.地区的获取是文件名的第7个字符，中国区：P ；中南区：8 ；北太平洋：B ；欧亚区：C；欧洲区：D；中低纬区：E；亚太区：G；亚洲区：Z ；其他字符的直接显示。
     
     4.有效时间数是文件名的第8个字符，A：0小时；B：6小时；C：12小时；D：18小时；E：24小时；F：30小时；其他数字直接显示。
     
     5.飞行高度是文件名的第9个和第10个字符，SH:高空；SM：中空；05：高空；SL：低空；20：200HPA；25：250HPA；30：300HPA；40：400HPA；50：500HPA；85：850HPA；70：700HPA，其他字符直接显示。
     
     6.有效时间是文件名的第11个字符到22个字符获取出来一个日期，其日期的格式是“yyyyMMddHHmm”在时分格式里加上有效时间数的小时数，得出的时间才是真正的有效时间。
     
     */
    
    //  1.取发布单位
    NSString* released= [NSString stringWithFormat:@"%@发布: ", [_mapName substringWithRange: NSMakeRange(0,4)] ];
    
    // 2.图片类型
    NSString* weatherType=[_mapName substringWithRange: NSMakeRange(4,2)];
    if ([weatherType isEqualToString:@"PG"]||[weatherType isEqualToString:@"FN"]) {
        weatherType=@"重要天气图:";
    }else if ([weatherType isEqualToString:@"PW"]||[weatherType isEqualToString:@"FB"]){
        weatherType=@"风温预告图:";
    }
    self.weatherType_=weatherType;
    
    // 3.地区
    NSString* weatherArea=[_mapName substringWithRange: NSMakeRange(6,1)];
    if ([weatherArea isEqualToString:@"P"]) {
        weatherArea=@"中国区";
    }else if ([weatherArea isEqualToString:@"8"]){
        weatherArea=@"中南区";
    }else if ([weatherArea isEqualToString:@"B"]){
        weatherArea=@"北太平洋";
    }else if ([weatherArea isEqualToString:@"C"]){
        weatherArea=@"欧亚区";
    }else if ([weatherArea isEqualToString:@"D"]){
        weatherArea=@"欧洲区";
    }else if ([weatherArea isEqualToString:@"E"]){
        weatherArea=@"中低纬区";
    }else if ([weatherArea isEqualToString:@"G"]){
         weatherArea=@"亚太区";
    }else if ([weatherArea isEqualToString:@"Z"]){
        weatherArea=@"亚洲区";
    }
    self.weatherArea_=weatherArea;
    
    // 5.飞行高度
    // 5.飞行高度是文件名的第9个和第10个字符，SH:高空；SM：中空；05：高空；SL：低空；20：200HPA；25：250HPA；30：300HPA；40：400HPA；50：500HPA；85：850HPA；70：700HPA，其他字符直接显示。
    NSString* weatherHeight=[_mapName substringWithRange: NSMakeRange(8,2)];
    if ([weatherHeight isEqualToString:@"SH"]||[weatherHeight isEqualToString:@"05"]) {
        weatherHeight=@"高空 ";
    }else if ([weatherHeight isEqualToString:@"SM"]){
        weatherHeight=@"中空 ";
    }else if ([weatherHeight isEqualToString:@"SL"]){
        weatherHeight=@"低空 ";
    }else if ([weatherHeight isEqualToString:@"20"]){
        weatherHeight=@"200HPA ";
    }else if ([weatherHeight isEqualToString:@"25"]){
        weatherHeight=@"250HPA ";
    }else if ([weatherHeight isEqualToString:@"30"]){
        weatherHeight=@"300HPA ";
    }else if ([weatherHeight isEqualToString:@"40"]){
        weatherHeight=@"400HPA ";
    }else if ([weatherHeight isEqualToString:@"50"]){
        weatherHeight=@"500HPA ";
    }else if ([weatherHeight isEqualToString:@"85"]){
        weatherHeight=@"850HPA ";
    }else if ([weatherHeight isEqualToString:@"70"]){
        weatherHeight=@"700HPA ";
    }
    
    // 4.有效时间
    NSString* weatherTime=[_mapName substringWithRange: NSMakeRange(7,1)];
    
    int effHour = 0;
    if ([weatherTime isEqualToString:@"A"]) {
        effHour = 0;
    }else if ([weatherTime isEqualToString:@"B"]) {
        effHour = 6;
    }else if ([weatherTime isEqualToString:@"C"]) {
        effHour = 12;
    }else if ([weatherTime isEqualToString:@"D"]) {
        effHour = 18;
    }else if ([weatherTime isEqualToString:@"E"]) {
        effHour = 24;
    }else if ([weatherTime isEqualToString:@"F"]) {
        effHour = 30;
    }else{
        effHour = [weatherTime intValue];
    }
    
    // 6.有效日期
    // 6.有效时间是文件名的第11个字符到22个字符获取出来一个日期，其日期的格式是“yyyyMMddHHmm”在时分格式里加上有效时间数的小时数，得出的时间才是真正的有效时间。
    NSString* weatherDateStr = [_mapName substringWithRange: NSMakeRange(10,12)];
    NSString* year = [weatherDateStr substringWithRange:NSMakeRange(0, 4)];
    NSString* month = [weatherDateStr substringWithRange:NSMakeRange(4, 2)];
    NSString* day = [weatherDateStr substringWithRange:NSMakeRange(6, 2)];
    NSString* hour = [weatherDateStr substringWithRange:NSMakeRange(8, 2)];
    NSString* minute = [weatherDateStr substringWithRange:NSMakeRange(10, 2)];

    weatherDateStr = [NSString stringWithFormat:@" %@-%@-%@ %@:%@:00",year,month,day,hour,minute];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *weatherDate = [formatter dateFromString:weatherDateStr];
    
    NSTimeInterval effVal = effHour * 60 * 60;
    
    //时间串加上有效小时为有效时间
    NSDate *effDate = [NSDate dateWithTimeInterval:effVal sinceDate:weatherDate];
    
    NSString *effDateStr = [NSString stringWithFormat:@"(有效时间:%@)",[formatter stringFromDate:effDate]];
    
    NSArray *array=[NSArray arrayWithObjects:released,weatherType,weatherArea,weatherHeight,effDateStr, nil];
   
    self.translatedName=[[array valueForKey:@"description"] componentsJoinedByString:@""];
    
    [formatter release];
}
@end
