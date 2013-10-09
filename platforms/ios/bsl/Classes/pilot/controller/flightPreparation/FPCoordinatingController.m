//
//  FPCoordinatingController.m
//  pilot
//
//  Created by Sencho Kong on 12-11-5.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPCoordinatingController.h"
#import "FPTaskListViewController.h"
#import "FPDocListViewController.h"
#import "FPWeatherInfoViewController.h"
#import "FPWeatherMapViewController.h"
#import "FPFligthNoticeViewController.h"
#import "FPHealthDeclarationViewController.h"
#import "FPAnswerOnlineViewController.h"




@implementation FPCoordinatingController


@synthesize activeViewController;
@synthesize taskViewController;
@synthesize depAirport;
@synthesize arvAirport;
@synthesize empId;
@synthesize flightNo;
@synthesize depTime;
@synthesize flightDate;
@synthesize plane;
@synthesize lastTime;
@synthesize route;
@synthesize flightTime;

static FPCoordinatingController *instance;

+(FPCoordinatingController *)shareInstance{
    if(instance == nil){
        {
            @synchronized([FPCoordinatingController class]){
                if(instance == nil){
                    instance = [[FPCoordinatingController alloc] init];
                                        
                 }
            }
        }
    }
    return instance;
}

-(void)requestViewChangeBy:(id)sender{

    if ([sender isKindOfClass:[UIButton class]]) {
        switch ([sender tag]) {
            case kButtonTagReturnMainPage:
                
                [self.taskViewController.navigationController popViewControllerAnimated:YES];
                
                break;
              
            case kButtonTagOpenWeatherInfoView:{
                
                FPWeatherInfoViewController* aFPWeatherInfoViewController=[[FPWeatherInfoViewController alloc]initWithStyle:UITableViewStyleGrouped];
                [self.taskViewController.navigationController pushViewController:aFPWeatherInfoViewController animated:YES];
                [aFPWeatherInfoViewController release];
                
            }
               
                break;
                
            case kButtonTagOpenWeatherMapView:{
                
                FPWeatherMapViewController* aFPWeatherMapViewController=[[FPWeatherMapViewController alloc]init];
                [self.taskViewController.navigationController pushViewController:aFPWeatherMapViewController animated:YES];
                [aFPWeatherMapViewController release];
                
            }
                
                break;
                
                
            case kButtonTagOpenFligthNoticeView:{
                
                FPFligthNoticeViewController* aFPFligthNoticeViewController=[[FPFligthNoticeViewController alloc]init];
                [self.taskViewController.navigationController pushViewController:aFPFligthNoticeViewController animated:YES];
                [aFPFligthNoticeViewController release];
                
            }
                break;
                
            case kButtonTagOpenImportantDocView:{
                
                FPDocListViewController* docListViewController=[[FPDocListViewController alloc]initWithNib];
                [self.taskViewController.navigationController pushViewController:docListViewController animated:YES];
                [docListViewController release];
                
            }
                break;
                
            case kButtonTagOpenHealthDeclarationView:{
                
                FPHealthDeclarationViewController *healthDeclarationViewController = [[FPHealthDeclarationViewController alloc] initWithNibName:@"FPHealthDeclarationViewController" bundle:nil];
                [self.taskViewController.navigationController pushViewController:healthDeclarationViewController animated:YES];
                [healthDeclarationViewController release];
                
            }
                break;
                
            case kButtonTagOpenAnswerOnlineView:{
                
                FPAnswerOnlineViewController *answerOnlineViewControlle = [[FPAnswerOnlineViewController alloc] initWithNibName:@"FPAnswerOnlineViewController" bundle:nil];
                [self.taskViewController.navigationController pushViewController:answerOnlineViewControlle animated:YES];
                [answerOnlineViewControlle release];
                
            }
                break;            
                
            case kbuttonTagBack:{
                
                [self.taskViewController.navigationController popViewControllerAnimated:YES];
                              
            }
                 break;
                
            default:
                break;
        }
   }
    
    
}


-(void)dealloc{
    [empId release];
    [arvAirport release];
    [depAirport release];
    [flightNo release];
    [depTime release];
    [taskViewController release];
    [activeViewController release];
    [flightDate release];
    [plane release];
    [lastTime release];
    [route release];
    [flightTime release];
    [super dealloc];
}

@end
