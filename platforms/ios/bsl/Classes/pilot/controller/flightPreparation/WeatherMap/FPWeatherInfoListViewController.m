//
//  FPWeatherInfoListViewController.m
//  pilot
//
//  Created by Sencho Kong on 12-11-8.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPWeatherInfoListViewController.h"
#import "BaseQuery.h"
#import "FPCoordinatingController.h"
#import "MBProgressController.h"
#import "WeatherMap.h"
#import "NSString+Verification.h"
#import "FPAnnexContentViewController.h"
#import "FileQuery.h"

@interface FPWeatherInfoListViewController ()



@end

@implementation FPWeatherInfoListViewController
@synthesize myWeatherMaps;

-(void)dealloc{
    
    [myWeatherMaps release];
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
    
    
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,50, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    leftButtonItem.tag=kbuttonTagBack;
    self.navigationItem.leftBarButtonItem=leftButtonItem;
    [leftButtonItem release];
}

-(void)requestChangeView:(id)sender{
    TaskDelegate.lastTime=[NSDate date];
    [self.navigationController popViewControllerAnimated:YES];
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
    return self.myWeatherMaps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    WeatherMap* aWeatherMap= [self.myWeatherMaps objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines=0;
    
    float textSize = 0.0;
    if (device_Type == UIUserInterfaceIdiomPad) {
        textSize = 20.0;
    }else if(device_Type == UIUserInterfaceIdiomPhone){
        textSize = 15.0;
    }
    cell.textLabel.font =  [UIFont systemFontOfSize:textSize];
    cell.textLabel.text=aWeatherMap.translatedName;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
    FileQuery *fileQuery=[[FileQuery alloc]init];
    
    WeatherMap* map=[self.myWeatherMaps objectAtIndex:indexPath.row];
 
    [fileQuery downloadFileWithRemotePath:WEATHER_MAP_REMOTEPATH AndFileName:[map mapName] AndFileType:WEATHER_MAP inTimeFlag:@"Y" completion:^(NSString *filePath) {
        [MBProgressController dismiss];
        if (filePath) {
            NSLog(@"-------%@",filePath);
            FPAnnexContentViewController *fpAnnexContentViewController = [[FPAnnexContentViewController alloc] initWithNibName:@"FPAnnexContentViewController" bundle:nil];
            NSURL *url = [NSURL fileURLWithPath:filePath];
            fpAnnexContentViewController.annexURL = url;
            fpAnnexContentViewController.annexString = [map translatedName];
            fpAnnexContentViewController.title = [map translatedName];
            [self.navigationController pushViewController:fpAnnexContentViewController animated:YES];
            [fpAnnexContentViewController release];
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"目前暂无卫星云图" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [alert show];
        }
        
    } failed:^(NSString *failedString) {
        [MBProgressController dismiss];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }];
    [fileQuery release];
    
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
