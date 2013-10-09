//
//  FPCoordinatingController.h
//  pilot
//
//  Created by Sencho Kong on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PilotNavigationViewController.h"
#import "FPTaskListViewController.h"

#define TaskDelegate [FPCoordinatingController shareInstance]

@interface FPCoordinatingController : NSObject

typedef enum{
   
    kButtonTagReturnMainPage,
    kButtonTagOpenWeatherInfoView,
    kButtonTagOpenWeatherMapView,
    kButtonTagOpenFligthNoticeView,
    kButtonTagOpenImportantDocView,
    kButtonTagOpenHealthDeclarationView,
    kButtonTagOpenAnswerOnlineView,
    kbuttonTagBack
    
    
    
}ButtonTag;


@property(nonatomic,retain) FPTaskListViewController* taskViewController;
@property(nonatomic,retain) UIViewController* activeViewController;


@property(nonatomic,retain)NSString* depAirport; //出发机场
@property(nonatomic,retain)NSString* arvAirport; //到达机场
@property(nonatomic,retain)NSString* empId;      //员工号
@property(nonatomic,retain)NSString* flightNo;   //航班号
@property(nonatomic,retain)NSString* depTime;    //起飞时间
@property(nonatomic,retain)NSString* flightDate; //航班日期
@property(nonatomic,retain)NSString* plane;      //机型
@property(nonatomic,retain)NSString* route;      //航线
@property(nonatomic,retain)NSDate*   lastTime;   //持续时间（秒）
@property(nonatomic,retain)NSString* flightTime; //航班时间

+(FPCoordinatingController *)shareInstance;
-(IBAction)requestViewChangeBy:(id)sender;
@end
