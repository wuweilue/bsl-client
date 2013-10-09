//
//  PlaneTypeViewController.m
//  pilot
//
//  Created by wuzheng on 13-6-25.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "PlaneTypeViewController.h"

@interface PlaneTypeViewController ()

@end

@implementation PlaneTypeViewController
@synthesize planeTypeArr;
@synthesize selectedType;
@synthesize typeDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [planeTypeArr release];
    [selectedType release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"planeType" ofType:@"plist"];
    self.planeTypeArr = [NSArray arrayWithContentsOfFile:path];
    
    self.title = @"机型";
    
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
    
    UIImageView* imageView = nil;
    if (device_Type == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }else{
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
    }else{
        imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_640X940.png"]];
    }
    self.tableView.backgroundView = imageView;
    [imageView release];
    
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
    return [planeTypeArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *planeTypeItem = [planeTypeArr objectAtIndex:indexPath.row];
    cell.textLabel.text = planeTypeItem;
    if (selectedType && [planeTypeItem isEqualToString:selectedType]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *planeType = [planeTypeArr objectAtIndex:indexPath.row];
    NSLog(@"----------%@",planeType);
    if (typeDelegate) {
        [typeDelegate didSelectPlaneType:planeType];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (device_Type == UIUserInterfaceIdiomPad) {
        UIImageView* imageView = nil;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_1024X768.png"]];
        }else{
            imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_768X1024.png"]];
        }
        self.tableView.backgroundView = imageView;
        [imageView release];
        return YES;
    }else{
        return interfaceOrientation == UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - Back
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
