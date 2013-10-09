//
//  FlightTaskViewController.m
//  pilot
//
//  Created by wuzheng on 9/17/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "FlightTaskViewController.h"
#import "FlightTaskQuery.h"
#import "ManifestViewController.h"
#import "MBProgressController.h"
#import "GEAlertViewDelegate.h"
#import "Task.h"

@implementation FlightTaskViewController
@synthesize myTableView;
@synthesize bgImageView;
@synthesize flightTaskArray;
@synthesize cabinOrderQuery = _cabinOrderQuery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *buttonForBackImage = [UIImage imageNamed:@"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backButton.titleLabel setShadowColor:[UIColor grayColor]];
    [backButton.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton release];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [leftButtonItem release];
    
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [myTableView setBackgroundView:[[[UIView alloc] init] autorelease]];
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setBgImageView:nil];
    [self setCabinOrderQuery:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"预计配载";
    if (device_Type == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            self.bgImageView.image=[UIImage imageNamed:@"Background_1024X768.png"];
        }else{
            self.bgImageView.image=[UIImage imageNamed:@"Background_768X1024.png"];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
            self.bgImageView.image=[UIImage imageNamed:@"Background_1024X768.png"];
        }else{
            self.bgImageView.image=[UIImage imageNamed:@"Background_768X1024.png"];
        }
        return YES;
    }else{
        return NO;
    }
}

- (void)dealloc {
    [myTableView release];
    [bgImageView release];
    [flightTaskArray release];
    [_cabinOrderQuery release];
    [super dealloc];
}

#pragma mark - UITableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (flightTaskArray && [flightTaskArray count] > 0) {
        return [flightTaskArray count];
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ManiFestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Task *task = [flightTaskArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@ (%@-%@)",task.flightNo,task.flightDate,task.depPort,task.arrPort];
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.cabinOrderQuery = [[[CabinOrderQuery alloc] init] autorelease];
    Task *task = [flightTaskArray objectAtIndex:indexPath.row];
//    task.fltNo = @"373";
//    task.fltDate = @"2012-09-19";
//    task.origin = @"CAN";
//    task.destination = @"SGN";
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController setSafeConnet];
    [MBProgressController startQueryProcess];
    [_cabinOrderQuery queryFlightCabinOrderWithFlightTask:task completionBlock:^(CabinOrder *cabinOrder) {
        [MBProgressController dismiss];
        if (cabinOrder) {
            ManifestViewController *manifestViewController = [[ManifestViewController alloc] initWithNib];
            manifestViewController.cabinOrder = cabinOrder;
            [self.navigationController pushViewController:manifestViewController animated:YES];
            [manifestViewController release];
        }else{
            GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
            [geAlert showAlertViewWithTitle:@"提示" message:@"无预计配载信息" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
        }        
    } failedBlock:^(NSData *responseData) {
        NSLog(@"-----failed query Manifest-----");
        [MBProgressController dismiss];
        GEAlertViewDelegate *geAlert = [GEAlertViewDelegate defaultDelegate];
        [geAlert showAlertViewWithTitle:@"提示" message:@"查询预计配载信息失败" confirmButtonTitle:@"确定" cancelButtonTitle:nil confirmBlock:nil cancelBlock:nil];
    }];
}

#pragma mark - Actions
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end