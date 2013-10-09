//
//  ManifestViewController.m
//  pilot
//
//  Created by wuzheng on 9/18/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "ManifestViewController.h"
#import "ManifestTableViewCell.h"

@implementation ManifestViewController
@synthesize bgImageView;
@synthesize myTableView;
@synthesize cabinOrder;
@synthesize cabinOrderDic;

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
    self.title = @"预计配载";
    
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
    myTableView.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Manifest" ofType:@"plist"];
    titleArray = [[NSArray alloc] initWithContentsOfFile:path];
    [self initDispalyData];
    [myTableView reloadData];
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setBgImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
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
    [cabinOrder release];
    [cabinOrderDic release];
    [titleArray release];
    [bgImageView release];
    [super dealloc];
}

#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ManifestCell";
    ManifestTableViewCell *cell = (ManifestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        if (device_Type == UIUserInterfaceIdiomPad) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ManifestTableViewCell_Pad" owner:nil options:nil] objectAtIndex:0];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ManifestTableViewCell_Phone" owner:nil options:nil] objectAtIndex:0];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *titleDic = [titleArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [titleDic objectForKey:@"title"];
    cell.valueLabel.text = [cabinOrderDic objectForKey:[titleDic objectForKey:@"dicKey"]];
    
    return cell;
}

#pragma mark -
- (void)initDispalyData{
    cabinOrderDic = [[NSMutableDictionary alloc] initWithCapacity:[titleArray count]];
    for(int i = 0;i < [titleArray count];i++){
        NSString *key = [[titleArray objectAtIndex:i] objectForKey:@"dicKey"];
        NSString *value = @"";
        if (i == 0) {
            value = [NSString stringWithFormat:@"%@-%@",cabinOrder.depPort,cabinOrder.arrPort];
        }else if(i == 1){
            value = [NSString stringWithFormat:@"%@/(%@)",cabinOrder.planeId,cabinOrder.version];
        }else if(i == 2){
            value = [NSString stringWithFormat:@"%@/%@/%@/%@",@"F",@"C",@"W",@"Y"];
        }else if(i == 3){
            if (!cabinOrder.FMax) {
                cabinOrder.FMax = @"*";
            }
            if (!cabinOrder.CMax) {
                cabinOrder.CMax = @"*";
            }
            if (!cabinOrder.WMax) {
                cabinOrder.WMax = @"*";
            }
            if (!cabinOrder.YMax) {
                cabinOrder.YMax = @"*";
            }
            value = [NSString stringWithFormat:@"%@/%@/%@/%@",cabinOrder.FMax,cabinOrder.CMax,cabinOrder.WMax,cabinOrder.YMax];
        }else if(i == 4){
            if (!cabinOrder.FActNum) {
                cabinOrder.FActNum = @"*";
            }
            if (!cabinOrder.CActNum) {
                cabinOrder.CActNum = @"*";
            }
            if (!cabinOrder.WActNum) {
                cabinOrder.WActNum = @"*";
            }
            if (!cabinOrder.YActNum) {
                cabinOrder.YActNum = @"*";
            }
            value = [NSString stringWithFormat:@"%@/%@/%@/%@",cabinOrder.FActNum,cabinOrder.CActNum,cabinOrder.WActNum,cabinOrder.YActNum];
        }else if(i == 5){
            value = [NSString stringWithFormat:@"%@",cabinOrder.MTP];
        }else if(i == 6){
            int adultCount = [cabinOrder.adultNum intValue];
            int childCount = [cabinOrder.childrenNum intValue];
            int babyCount = [cabinOrder.babyNum intValue];
            int allCount = adultCount + childCount + babyCount;
            value = [NSString stringWithFormat:@"%@/%@/%@/%d",cabinOrder.adultNum,cabinOrder.childrenNum,cabinOrder.babyNum,allCount];
        }else if(i == 7){
            value = [NSString stringWithFormat:@"%@/%@",cabinOrder.ctrEmpWeight,cabinOrder.TOF];
        }else if(i == 8){
            value = [NSString stringWithFormat:@"%@/%@",cabinOrder.actNonFuelWeight,cabinOrder.maxNonFuelWeight];
        }else if(i == 9){
            value = [NSString stringWithFormat:@"%@/%@",cabinOrder.actDepWeight,cabinOrder.maxDepWeight];
        }else if(i == 10){
            value = [NSString stringWithFormat:@"%@/%@",cabinOrder.LDW,cabinOrder.MLDW];
        }else if(i == 11){
            value = [NSString stringWithFormat:@"%@/%@/%@",cabinOrder.goodsWeight,cabinOrder.mailWeight,cabinOrder.luggageWeight];
        }else if(i == 12){
            value = [NSString stringWithFormat:@"%@/%@",cabinOrder.TTL,cabinOrder.remainWeight];
        }
        [cabinOrderDic setObject:value forKey:key];
    }
}

#pragma mark - Actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end