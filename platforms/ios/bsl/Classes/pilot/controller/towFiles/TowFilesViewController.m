//
//  TowFilesViewController.m
//  pilot
//
//  Created by wuzheng on 13-6-25.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//

#import "TowFilesViewController.h"
#import "QueryTableCell.h"
#import "PlaneTypeViewController.h"
#import "TowFilesQuery.h"
#import "TowFileName.h"
#import "FileQuery.h"
#import "FPAnnexContentViewController.h"
#import "MBProgressController.h"

@interface TowFilesViewController ()

@end

@implementation TowFilesViewController
@synthesize typeDelegate;
@synthesize portCodeField;
@synthesize fileNameList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"起飞限重表";
    
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
    
    [_queryTable setBackgroundColor:[UIColor clearColor]];
    [_queryTable setBackgroundView:[[[UIView alloc] init] autorelease]];
    
    [_resultTable setBackgroundColor:[UIColor clearColor]];
    [_resultTable setBackgroundView:[[[UIView alloc] init] autorelease]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_queryTable release];
    [_resultTable release];
    [_bgImageView release];
    [portCodeField release];
    [fileNameList release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setQueryTable:nil];
    [self setResultTable:nil];
    [self setBgImageView:nil];
    [super viewDidUnload];
}

//查询起飞限重表文件列表
- (IBAction)queryFileList:(id)sender {
    if ([portCodeField canResignFirstResponder]) {
        [portCodeField resignFirstResponder];
    }
    if (portCodeField.text == nil || [portCodeField.text isEqualToString:@""]){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入机场三字码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
        return;
    }
    if(selectedType == nil) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择机型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
        return;
    }
    NSString *portCode = [[portCodeField text] uppercaseString];
    NSLog(@"-----portCode : %@   ---type  : %@",portCode,selectedType);
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
    TowFilesQuery *towFilesQuery = [[TowFilesQuery alloc] init];
    [towFilesQuery queryTowFilesNameListWithPortCode:portCode planeType:selectedType completion:^(NSObject *fileNames) {
        [MBProgressController dismiss];
        if(fileNames && [fileNames isKindOfClass:[TowFileName class]]){
            NSLog(@"-------success");
            TowFileName *towFileName = (TowFileName *)fileNames;
            if ([towFileName fileNameList] && [[towFileName fileNameList] count] > 0) {
                self.fileNameList = [towFileName fileNameList];
                
            }else{
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"无相关起飞限重文件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
                [alert show];
                self.fileNameList = [NSArray array];
            }
            [_resultTable reloadData];
        }else{
            
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"无相关起飞限重文件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [alert show];
            self.fileNameList = nil;
            [_resultTable reloadData];
        }
     
    } failed:^(NSData *responseData) {
        NSLog(@"-------failed");
        [MBProgressController dismiss];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
        self.fileNameList = [NSArray array];
        [_resultTable reloadData];
    }];
    [towFilesQuery release];
}

//下载起飞限重表文件
- (void)queryTowFileWithPlaneType:(NSString*)planeType andFileName:(NSString *)fileName{
    FileQuery *fileQuery = [[FileQuery alloc] init];
    [fileQuery downloadTowFileWithPlaneType:selectedType AndFileName:fileName completion:^(NSString *path) {
        NSLog(@"--------%@",path);
        FPAnnexContentViewController *fpAnnexContentViewController = [[FPAnnexContentViewController alloc] initWithNibName:@"FPAnnexContentViewController" bundle:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        fpAnnexContentViewController.annexURL = url;
        fpAnnexContentViewController.annexString = fileName;
        fpAnnexContentViewController.title = fileName;
        [self.navigationController pushViewController:fpAnnexContentViewController animated:YES];
        [fpAnnexContentViewController release];
    } failed:^(NSString *path) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"文件下载失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }];
    [fileQuery release];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = 0;
    if (tableView == _queryTable) {
        count = 2;
    }else if(tableView == _resultTable){
        if (fileNameList == nil) {
            count = 0;
        }else{
            count = [fileNameList count];
        }
    }
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _queryTable) {
        static NSString *CellIdentifier = @"QueryCell";
        QueryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            if (device_Type == UIUserInterfaceIdiomPhone) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"QueryTableCell_Phone" owner:nil options:nil] objectAtIndex:0];
            }else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"QueryTableCell_Pad" owner:nil options:nil] objectAtIndex:0];
            }
        }
        if (indexPath.row == 0) {
            cell.tilteLabel.text = @"机场";
            cell.myTextField.hidden = NO;
            cell.valueLabel.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.myTextField.placeholder = @"请输入机场三字码";
            
            if (self.portCodeField) {
                cell.myTextField.text = self.portCodeField.text;
            }
            self.portCodeField = cell.myTextField;
        }else if(indexPath.row == 1){
            cell.tilteLabel.text = @"机型";
            cell.myTextField.hidden = YES;
            cell.valueLabel.hidden = NO;
            if (selectedType) {
                cell.valueLabel.text = selectedType;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(tableView == _resultTable){
        static NSString *CellIdentifier = @"BaseCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [fileNameList objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _queryTable) {
        if (indexPath.row == 1) {
            PlaneTypeViewController *planeTypeViewController = [[PlaneTypeViewController alloc] initWithStyle:UITableViewStyleGrouped];
            planeTypeViewController.typeDelegate = self;
            planeTypeViewController.selectedType = selectedType;
            [self.navigationController pushViewController:planeTypeViewController animated:YES];
            [planeTypeViewController release];
        }
    }else if(tableView == _resultTable){
        NSString *fileName = [fileNameList objectAtIndex:indexPath.row];
        [self queryTowFileWithPlaneType:selectedType andFileName:fileName];
    }
}

#pragma mark - Type delegate
- (void)didSelectPlaneType:(NSString *)planeType{
    NSLog(@"-------delegate     %@",planeType);
    selectedType = [planeType retain];
    [_queryTable reloadData];
}

#pragma mark - Back
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
