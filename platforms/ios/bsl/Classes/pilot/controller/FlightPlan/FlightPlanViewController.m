//
//  FlightPlanViewController.m
//  pilot
//
//  Created by Sencho Kong on 12-12-25.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FlightPlanViewController.h"
#import "MBProgressController.h"
#import "BaseQuery.h"
#import "User.h"
#import "AirPath.h"
#import "Task.h"
#import "FileQuery.h"
#import "FPAnnexContentViewController.h"
#import "FlightTaskQuery.h"
#import "MBProgressController.h"

@interface FlightPlanViewController ()

@end

@implementation FlightPlanViewController
@synthesize flightTaskArray;

-(void)dealloc{
    [flightTaskArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 主页" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem=leftButtonItem;
    [leftButtonItem release];
    
    self.title=@"飞行计划";
    
    
    NSString* workNo=[[NSUserDefaults standardUserDefaults] valueForKey:@"loginUsername"];
    
    FlightTaskQuery *taskQuery = [[FlightTaskQuery alloc] init];
    //查询当天飞行任务
    [taskQuery queryFlightTaskFromSDESWithWorkNo:workNo taskDays:0 completionBlock:^(NSArray *responseArray) {
        [MBProgressController dismiss];
        if (responseArray == nil || [responseArray count] == 0) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无飞行计划相关数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
           
        }else{
            
            self.flightTaskArray =responseArray;
            [self.tableView reloadData];

        }
       
    } failedBlock:^(NSData *responseData) {
        [MBProgressController dismiss];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"查询飞行计划相关数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

    }];
    [taskQuery release];
        
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (device_Type == UIUserInterfaceIdiomPad) {
        return YES;
    }else{
        return NO;
    }
}

-(void)requestChangeView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)flightPlanQuery{
    
    BaseQuery *query=[[BaseQuery alloc]init];
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
    //http://10.108.68.135:8080/pilot/data/airPaths/3829/2012-12-24/CAN
    
    /*fltNr：航班号， (3829)
     depDt: 航班日期 （2012-12-24）
    base：基地（CAN）

   */
    NSString* user=[User currentUser].workNo;
    NSString* url= [NSString stringWithFormat:@"%@/data/airPaths/%@",BASEURL,user];
    
    [query queryArrayWithURL:url parameters:nil completion:^(NSArray *airPaths) {
         [MBProgressController dismiss];
        [self.tableView reloadData];
    } failed:^(NSData *error) {
        [MBProgressController dismiss];
    }];
    [query release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    return self.flightTaskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Task *task = [flightTaskArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@ (%@-%@)",task.flightNo,task.flightDate,task.depPort,task.arrPort];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Task *task=[self.flightTaskArray objectAtIndex:indexPath.row];
    
    FileQuery* query=[[FileQuery alloc]init];
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
    [query downloadPlanFileWithFlightNo:task.flightNo fltDt:task.flightDate arvArpCd:task.depPort depArpCd:task.arrPort completion:^(NSString *fileDataPath) {
        
        [MBProgressController dismiss];
        
        if ([fileDataPath length]>0) {
            
            FPAnnexContentViewController *detailViewController = [[FPAnnexContentViewController alloc] initWithNibName:@"FPAnnexContentViewController" bundle:nil];
            detailViewController.title=@"飞行计划";
            
            detailViewController.annexURL=[NSURL fileURLWithPath:fileDataPath];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }else{
            UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无飞行计划报文，请在航班起飞前3小时左右重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [alert show];
        }        
    } failed:^(NSString *error) {
        [MBProgressController dismiss];
        UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"查询失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }];
    [query release];
}

@end
