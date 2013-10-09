//
//  FPWeatherInfoViewController.m
//  pilot
//
//  Created by Sencho Kong on 12-11-7.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPWeatherInfoViewController.h"
#import "FPCoordinatingController.h"
#import "BaseQuery.h"
#import "MBProgressController.h"
#import "WeatherInfo.h"
#import "AirportWeatherInfo.h"
#import "FPWeatherInfoCell.h"


@interface FPWeatherInfoViewController (){
    CGFloat tableWidth;
}

@property(nonatomic,retain)AirportWeatherInfo* myWeatherInfo;

@end

@implementation FPWeatherInfoViewController
@synthesize myWeatherInfo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"气象信息";
    
    
    UIImageView* imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        } else {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    }else{
        imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    self.tableView.backgroundView = imageView;
    [imageView release];
    
    
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@"  飞行任务" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag=kbuttonTagBack;
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem=leftButtonItem;
    [leftButtonItem release];
    
    
    
    
    UIImage *nextImage = [UIImage imageNamed: @"RightButtonItem"];
    UIButton *buttonForNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30) ];
    [buttonForNextStep setBackgroundImage:nextImage forState:UIControlStateNormal];
    [buttonForNextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [buttonForNextStep.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [buttonForNextStep.titleLabel setShadowColor:[UIColor grayColor]];
    [buttonForNextStep.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [buttonForNextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonForNextStep addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    buttonForNextStep.tag=kButtonTagOpenWeatherMapView;
    UIBarButtonItem *nextStepItem = [[UIBarButtonItem alloc] initWithCustomView:buttonForNextStep];
    [buttonForNextStep release];
    self.navigationItem.rightBarButtonItem = nextStepItem;
    [nextStepItem release];
    
    [self weatherInfoQuery];
    
}

-(void)weatherInfoQuery{
    
    BaseQuery *query=[[BaseQuery alloc]init];
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
    
    
    //for test URL /arpWeatherInfo/depArp/arvArp/staff_no/flt_no/flt_date
    
    NSDate *date = [NSDate date];
    NSTimeInterval totalTimeDouble = [date timeIntervalSinceDate:TaskDelegate.lastTime];
    NSString *totalTime = [NSString stringWithFormat:@"%.2f", totalTimeDouble];
    TaskDelegate.lastTime=date;
    
//    NSString* url=[NSString stringWithFormat:@"%@/data/arpWeatherInfo/%@/%@/%@/%@/%@/%@",BASEURL,@"CAN",@"HGH",TaskDelegate.empId,TaskDelegate.flightNo,TaskDelegate.flightDate,totalTime];
    
    NSString* url=[NSString stringWithFormat:@"%@/data/arpWeatherInfo/%@/%@/%@/%@/%@/%@",BASEURL,TaskDelegate.depAirport,TaskDelegate.arvAirport,TaskDelegate.empId,TaskDelegate.flightNo,TaskDelegate.flightTime,totalTime];
    
    [query queryObjectWithURL:url parameters:nil completion:^(NSObject *weather) {
        [MBProgressController dismiss];
        self.myWeatherInfo=(AirportWeatherInfo*)weather;
        
        [self.tableView reloadData];
        
    } failed:^(NSData *responseData) {
        [MBProgressController dismiss];
        
    }];
    [query release];
}


-(void)requestChangeView:(id)sender{
    
    [[FPCoordinatingController shareInstance] requestViewChangeBy:sender ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==0) {
        
        static NSString *CellIdentifier = @"Cell";
        FPWeatherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell=[[[FPWeatherInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier contentViewStyle:kHeadCell] autorelease];
            cell.selectionStyle=UITableViewCellEditingStyleNone;
        }
        
        cell.airportWeatherInfo=self.myWeatherInfo;
        
        
        return cell;
        
    }else{
        
        static NSString *WeatherInfoCell = @"WeatherInfoCell";
        FPWeatherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:WeatherInfoCell];
        
        if (cell == nil) {
            cell=[[[FPWeatherInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeatherInfoCell contentViewStyle:kMiddleCell] autorelease];
            cell.selectionStyle=UITableViewCellEditingStyleNone;
        }
        cell.weatherInfo=[self.myWeatherInfo.weatherInfos objectAtIndex:indexPath.row-1];
        
        return cell;
        
        
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
     *上下行距各10，字高20，行间距为3    
     *如果有气象信息，计算行高度
    */
    
    if (indexPath.row==0) {
        return 100;
    }else{
        
        WeatherInfo* weatherInfo=[self.myWeatherInfo.weatherInfos objectAtIndex:indexPath.row-1];
        
        NSLog(@"%@",weatherInfo.optTxts);
        
        
        //初始行高为：上下留空各10，标题20
        float cellHeight=10+10+20;
        //第4，5，6行为两行的标题，再加20
        if (indexPath.row==3||indexPath.row==4||indexPath.row==5) {
            cellHeight+=20;
        }
      
        
        if ([weatherInfo.optTxts isKindOfClass:[NSString class]]) {
           
            CGSize size = [(NSString*)weatherInfo.optTxts sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableWidth,CGFLOAT_MAX) lineBreakMode:0];
            //3为行间距
            cellHeight+=size.height+3;
            
            return cellHeight;
            
        }
        
        if ([weatherInfo.optTxts isKindOfClass:[NSArray class]] && weatherInfo.optTxts.count>0) {
           
            for (NSString* info in weatherInfo.optTxts) {
                CGSize size = [info sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableWidth,CGFLOAT_MAX) lineBreakMode:0];
                //3为行间距
                cellHeight+=size.height+4;
            }
            return cellHeight+20;
        }else{
            
            return 60;
        }
        
    }
    
    //默认60行高
    return 60;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        
        if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
            tableWidth=900;
        }else{
            tableWidth=680;
        }
        
        [self.tableView reloadData];
        return YES;
    }else{
        if (interfaceOrientation==UIInterfaceOrientationPortrait) {
            
            
            tableWidth=290;
            return YES;
            
        }
        return NO;
    }
    
}


- (BOOL)shouldAutorotate
{
    if (device_Type == UIUserInterfaceIdiomPhone){
        return NO;
    }else{
        return YES;
    }
    
}



- (NSUInteger)supportedInterfaceOrientations{
    
       
    
    if (device_Type == UIUserInterfaceIdiomPad) {
        
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            
             tableWidth=900;
        }else{
             tableWidth=680;
        }

        
       
        [self.tableView reloadData];
        return UIInterfaceOrientationMaskAll;
        
        
    }else{
        
        tableWidth=290;
        
        return UIInterfaceOrientationMaskPortrait ;
        
        
    }
    
}



@end
