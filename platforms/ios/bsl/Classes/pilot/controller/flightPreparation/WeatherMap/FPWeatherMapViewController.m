//
//  FPWeatherMapViewController.m
//  pilot
//
//  Created by Sencho Kong on 12-11-7.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPWeatherMapViewController.h"
#import "FPWeatherInfoListViewController.h"
#import "FPCoordinatingController.h"
#import "BaseQuery.h"
#import "MBProgressController.h"
#import "NSString+Verification.h"
#import "WeatherMap.h"
#import "FileQuery.h"


@interface FPWeatherMapViewController (){
    
}

@end

@implementation FPWeatherMapViewController
@synthesize tableViewData;
@synthesize areaNames;
@synthesize weatherSegment;
@synthesize weatherAreaDic;
@synthesize temperatureAreaDic;

-(void)dealloc{
    [weatherSegment release];
    [areaNames release];
    [tableViewData release];
    [weatherAreaDic release];
    [temperatureAreaDic release];
    [super dealloc];
}

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

     self.title=@"卫星云图";
    
    
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,70, 28) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@"气象信息" forState:UIControlStateNormal];
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
    UIButton *buttonForNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,42, 28) ];
    [buttonForNextStep setBackgroundImage:nextImage forState:UIControlStateNormal];
    [buttonForNextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [buttonForNextStep.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [buttonForNextStep.titleLabel setShadowColor:[UIColor grayColor]];
    [buttonForNextStep.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [buttonForNextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonForNextStep addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    buttonForNextStep.tag=kButtonTagOpenFligthNoticeView;
    UIBarButtonItem *nextStepItem = [[UIBarButtonItem alloc] initWithCustomView:buttonForNextStep];
    [buttonForNextStep release];
    self.navigationItem.rightBarButtonItem = nextStepItem;
    [nextStepItem release];

    UISegmentedControl* aSegmentedControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"重要天气",@"风温预告", nil]];
    [aSegmentedControl setTintColor:[UIColor colorWithRed:42.0/255.0 green:142.0/255.0 blue:217.0/255.0 alpha:1.0]];
       [aSegmentedControl addTarget:self action:@selector(didSelectedWeatherType:) forControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];
    aSegmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
    self.tableView.tableHeaderView=aSegmentedControl;
    self.weatherSegment=aSegmentedControl;
    [aSegmentedControl release];
    
    //重要天气地区
    NSString *weatherPath = [[NSBundle mainBundle] pathForResource:@"weather_area" ofType:@"plist"];
    self.weatherAreaDic = [NSDictionary dictionaryWithContentsOfFile:weatherPath];
    
    //风温预报地区
    NSString *temperaturePath = [[NSBundle mainBundle] pathForResource:@"temperature_area" ofType:@"plist"];
    self.temperatureAreaDic = [NSDictionary dictionaryWithContentsOfFile:temperaturePath];
    
    weatherSegment.selectedSegmentIndex=0;
    weatherSegment.selected=YES;
    [self didSelectedWeatherType:weatherSegment];
    
    [self timeQuery];
}

-(void)requestChangeView:(id)sender{
    [[FPCoordinatingController shareInstance] requestViewChangeBy:sender];
}

-(void)timeQuery{
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;

    BaseQuery* query=[[BaseQuery alloc]init];
      
    NSDate *date = [NSDate date];
    NSTimeInterval totalTimeDouble = [date timeIntervalSinceDate:TaskDelegate.lastTime];
    NSString *totalTime = [NSString stringWithFormat:@"%.2f", totalTimeDouble];
    TaskDelegate.lastTime=date;
    
    NSString* url=[NSString stringWithFormat:@"%@/data/preflytInfo/%@/%@/%@/%@/%@/%@/%@",BASEURL,TaskDelegate.empId,TaskDelegate.flightNo,TaskDelegate.flightTime,TaskDelegate.depAirport,@"0902",totalTime,@"Y"];
    
    [query postObjectWithURL:url object:[NSData data] parameters:nil completion:^(NSObject *data) {
        [MBProgressController dismiss];
        
    } failed:^(NSData *error) {
        [MBProgressController dismiss];
    }];
    [query release];
}

-(void)didSelectedWeatherType:(UISegmentedControl*)sender{
    
    NSArray* nameArray;
    switch (sender.selectedSegmentIndex) {
        case 0:{
            nameArray = [self.weatherAreaDic allKeys];
        }
            break;
        case 1:{
            nameArray = [self.temperatureAreaDic allKeys];
        }
            break;
        default:
            break;
    }
    
    self.tableViewData = nameArray;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [self.tableViewData objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *area = [self.tableViewData objectAtIndex:indexPath.row];
    [self weatherMapQueryWithArea:area];
}

-(void)weatherMapQueryWithArea:(NSString *)area{
    
    FileQuery *query=[[FileQuery alloc]init];
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
    NSString* weatherType=nil;
    
    if ([[self.weatherSegment titleForSegmentAtIndex:self.weatherSegment.selectedSegmentIndex] isEqualToString:@"重要天气"]) {
        weatherType=@"IW";
    }else{
        weatherType=@"WT";
    }
    
    NSString* weatherArea = nil;
    if ([weatherType isEqualToString:@"IW"]) {
        weatherArea = [self.weatherAreaDic objectForKey:area];
    }else if([weatherType isEqualToString:@"WT"]){
        weatherArea = [self.temperatureAreaDic objectForKey:area];
    }
    
  //  NSString* url=[NSString stringWithFormat:@"%@/data/weatherMaps/%@/%@/%@/%@",BASEURL,TaskDelegate.empId,TaskDelegate.flightNo,TaskDelegate.flightDate,TaskDelegate.depAirport] ;
    
    [query queryWeatherMapNameListWithremotePath:WEATHER_MAP_REMOTEPATH andType:weatherType andArea:weatherArea completion:^(NSString *mapNameString) {
        [MBProgressController dismiss];
        if (mapNameString && ![@"" isEqualToString:mapNameString]) {
            [self loadWeatherMapWithMapName:mapNameString andArea:area];
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"无相关卫星云图信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [alert show];
        }         
    } failed:^(NSString *error) {
        [MBProgressController dismiss];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"获取卫星云图文件列表失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }];
    
    [query release];
}

- (void) loadWeatherMapWithMapName:(NSString *)mapNameString andArea:(NSString *)area{
    
    NSArray* namesOfMap=[mapNameString componentsSeparatedByString:@","];
    
    NSMutableArray* weatherMaps=[NSMutableArray array];
    
    for (NSString* name in  namesOfMap) {
        if ([name length]>0) {
            WeatherMap* map=[[WeatherMap alloc]initWithMapName:name];
            [weatherMaps addObject:map];
            [map release];
        }
    }
    
//    //能识别到区域标识的云图列表
//    NSMutableArray* maps=[NSMutableArray array];
//    //不能识别到区域标识的云图列表
//    NSMutableArray* unKnowAreaMaps=[NSMutableArray array];
//    
//    NSString* weatherTypeTitle=[self.weatherSegment titleForSegmentAtIndex:self.weatherSegment.selectedSegmentIndex ];
//    
//    
//    //地区标识：中国区：P ；中南区：8 ；北太平洋：B ；欧亚区：C；中低纬区：E；亚太区：G；亚洲区：Z ；其他字符的直接显示。
//    NSString* selectedWeatherArea = area;
//    
////    NSArray* areaArray=[NSArray arrayWithObjects:@"中国区",@"中南区",@"北太平洋",@"欧亚区",@"中低纬区",@"亚太区",@"亚洲区", nil];
//    
//    //是否能识别标识
//    BOOL isFlag=NO;
//    
//    if ([areaArray containsObject:selectedWeatherArea]) {
//        isFlag=YES;
//    }
    
//    for (WeatherMap* aMap in weatherMaps) {
//
//        if ([aMap.weatherType_ isEqualToString:weatherTypeTitle]) {
//            
//            if ([areaArray containsObject:selectedWeatherArea]&&[aMap.weatherArea_ isEqualToString:selectedWeatherArea]) {
//                [maps addObject:aMap];
//            }else{
//                
//                if (![areaArray containsObject:aMap.weatherArea_]) {
//                    [unKnowAreaMaps addObject:aMap];
//                }
//            }
//        }
//    }
    
    FPWeatherInfoListViewController *detailViewController = [[FPWeatherInfoListViewController alloc] initWithStyle:UITableViewStylePlain];
    
//    if (isFlag) {
//        detailViewController.myWeatherMaps=maps;
//    }else{
//        detailViewController.myWeatherMaps=unKnowAreaMaps;
//    }
    
    detailViewController.myWeatherMaps = weatherMaps;
    
    detailViewController.title= [area stringByAppendingFormat:@"-%@",[self.weatherSegment titleForSegmentAtIndex:self.weatherSegment.selectedSegmentIndex]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    [detailViewController release];
    [detailViewController.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    }else{
        if (interfaceOrientation==UIInterfaceOrientationPortrait) {
            return YES;
        }
        return NO;
    }
}

@end
