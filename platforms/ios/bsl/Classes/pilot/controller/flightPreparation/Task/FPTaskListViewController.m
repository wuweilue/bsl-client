
//
//  FPTaskListViewController.m
//  pilot
//
//  Created by Sencho Kong on 12-11-6.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPTaskListViewController.h"
#import "FPCoordinatingController.h"
#import "FPTaskTableViewCell.h"
#import "FPTaskTeamMemberViewController.h"
#import "FPOtherTaskViewController.h"
#import "BaseQuery.h"
#import "User.h"
#import "PilotTask.h"
#import "OtherTask.h"
#import "FltTask.h"
#import "MBProgressController.h"
#import "UserQuery.h"

@interface FPTaskListViewController (){
    
    UIButton *buttonForNextStep;
    UserQuery* userQuery ;
}
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,retain)UILabel* headerLable;
@property(nonatomic,retain)PilotTask* myTask;

-(void) loadWithTask:(NSObject*) pilotTask andUser:(NSString*) user;
@end

@implementation FPTaskListViewController
@synthesize tableView;
@synthesize headerLable;
@synthesize myTask;


-(void)dealloc{
    [userQuery release];
    [myTask release];
    [tableView release];
    [headerLable release];
    [super dealloc];
}

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
	
    self.title=@"飞行任务";
       
    UIImageView *imageview = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
    [imageview setImage:[UIImage imageNamed:@"Background_768X1024.png"]];
    [imageview setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:imageview];

    
    
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
    leftButtonItem.tag=kButtonTagReturnMainPage;
    self.navigationItem.leftBarButtonItem=leftButtonItem;
    [leftButtonItem release];
    
    
    
    
    UIImage *nextImage = [UIImage imageNamed: @"RightButtonItem"];
    buttonForNextStep = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30) ];
    [buttonForNextStep setBackgroundImage:nextImage forState:UIControlStateNormal];
    [buttonForNextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [buttonForNextStep.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [buttonForNextStep.titleLabel setShadowColor:[UIColor grayColor]];
    [buttonForNextStep.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [buttonForNextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonForNextStep setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [buttonForNextStep addTarget:self action:@selector(requestChangeView:) forControlEvents:UIControlEventTouchUpInside];
    buttonForNextStep.tag=kButtonTagOpenWeatherInfoView;
    UIBarButtonItem *nextStepItem = [[UIBarButtonItem alloc] initWithCustomView:buttonForNextStep];
    [buttonForNextStep release];
    self.navigationItem.rightBarButtonItem = nextStepItem;
    [nextStepItem release];
    
    //飞行任务列表
    UITableView *aTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20) style:UITableViewStyleGrouped];
  
    aTableView.delegate=self;
    aTableView.dataSource=self;
    [aTableView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:aTableView];
    self.tableView=aTableView;
    [aTableView release];
    self.tableView.backgroundView=nil;
    self.tableView.backgroundColor=[UIColor clearColor];
    //顶部飞行小时数label
    
    UILabel* aLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    [aLable setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth ];
    [aLable setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [aLable setBackgroundColor:[UIColor clearColor]];
    self.headerLable=aLable;
    [self.view addSubview:headerLable];
    [aLable release];
    
    
    [FPCoordinatingController shareInstance].taskViewController =self;
    //先请求原来的登录接口，取得基地号，和是否飞行员的标识
    [self loginPilot];
    
//    UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"该功能为试运行版本，在使用过程中可能会存在一些问题，烦请使用意见反馈模块进行反馈，谢谢！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]  autorelease];
//    [alert show];
}

//add by Sencho Kong
//飞行移动迁移添加的方法，需求再登录一次业务系统取user数据，持久化
-(void)loginPilot{
    
    NSString* workNo=[[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString* pwd=[[NSUserDefaults standardUserDefaults] valueForKey:@"loginPassword"];
    
    //登录请求
    if (userQuery==nil) {
        userQuery = [[UserQuery alloc] init];
    }
    
    [userQuery newLoginWithWorkNo:workNo password:pwd completionBlock:^(NSString* resultString) {
    
        
        if ([[User currentUser].pilotFlag isEqualToString:@"Y"]) {
            
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有飞行准备的权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
            [alert show];
            [alert release];
            
           self.navigationItem.rightBarButtonItem.enabled=NO;
            return;
        }

        
        [self taskQuery];
               
    } failedBlock:^(NSString* resultString) {
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询失败，请重新再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
        self.navigationItem.rightBarButtonItem.enabled=NO;
        
    }];
    
    //end add
    
    
}


-(void)taskQuery{
    
    BaseQuery *query=[[BaseQuery alloc]init];
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
      //NSString* url=[NSString stringWithFormat: @"%@/data/pilotTask/%@" ,BASEURL, currentUser.workNo];
    
    //for test URL

    NSString* user=[User currentUser].workNo;
    NSString* url= [NSString stringWithFormat:@"%@/data/pilotTask/%@",BASEURL,user];
    
    [query queryObjectWithURL:url parameters:nil completion:^(NSObject *pilotTask) {
        [MBProgressController dismiss];
        [self loadWithTask:pilotTask andUser:user];
    } failed:^(NSData *responseData) {
        [MBProgressController dismiss];
        buttonForNextStep.enabled=NO;
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询失败，请重新再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
        [alert show];
        
    }];
    [query release];
}

- (void) loadWithTask:(NSObject *) pilotTask andUser:(NSString *)user
{
    self.myTask=(PilotTask*)pilotTask;
    
    TaskDelegate.empId=user;
    

    /*
     
     *  result = "B"    基地和始发站不一致，不需要准备
     *  result = "T"    时间不符合要求
     *  result = "C"    准备完成
     *  result = "R"    正在准备
     *  result = "N"    未准备
     *  result = "NO"   暂不需要准备
     */
    
    if (myTask.fltTasks.count>0) {
        
        FltTask* task=[myTask.fltTasks objectAtIndex:0];
        
        TaskDelegate.depAirport=task.depPort;
        TaskDelegate.arvAirport=task.arrPort;
        TaskDelegate.depTime=task.depTime;
        TaskDelegate.flightNo=task.flightNo;
        TaskDelegate.flightDate=task.flightDate;
        TaskDelegate.plane=task.plane;
        TaskDelegate.lastTime= [NSDate date];
        TaskDelegate.route=[NSString stringWithFormat:@"%@-%@",task.depPort,task.arrPort];
        TaskDelegate.flightTime = [task.depTime stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        TaskDelegate.flightTime = [NSString stringWithFormat:@"%@:00",TaskDelegate.flightTime];
        
        //再判断是否3个航断，如果是就拼出3航段的航线
        if ([myTask.fltTasks objectAtIndex:1] && 1>!myTask.fltTasks.count) {
            
            FltTask* secondFlighTask= [myTask.fltTasks objectAtIndex:1];
            if ([secondFlighTask.flightNo isEqualToString:task.flightNo]) {
                TaskDelegate.route=[NSString stringWithFormat:@"%@-%@",TaskDelegate.route,secondFlighTask.arrPort];
            }
        }

    }else if(myTask.fltTasks.count==0){
        
        UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"您好，目前没有未来五天的任务航班，不需要做飞行准备！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]  autorelease];
        [alert show];
        
        buttonForNextStep.enabled=NO; 
    }
        
    
    int bFlag=0;
    
    
    for (int i=0;i<myTask.fltTasks.count;i++) {
       
        FltTask* firstTask=[myTask.fltTasks objectAtIndex:i];
        
        //如果有正在准备的任务和未准备的任务的情况，可以按下一步；否则不可以按下一步
        if([firstTask.readyFlag isEqualToString:@"R"]||[firstTask.readyFlag isEqualToString:@"N"]){
        
            buttonForNextStep.enabled=YES;
            break;
            
        }
        //如果所有任务状态都是不需要准备和暂不需要，并且第一个任务是不需要准备的情况下，则可以按下一步
        else if ([firstTask.readyFlag isEqualToString:@"B"] ||[firstTask.readyFlag isEqualToString:@"NO"]){
            bFlag++;
            if (bFlag==myTask.fltTasks.count-1 ) {
                FltTask* task=[myTask.fltTasks objectAtIndex:0];
                if ([task.readyFlag isEqualToString:@"B"]) {
                     buttonForNextStep.enabled=YES;
                }else{
                     buttonForNextStep.enabled=NO;
                }  
            }
        }
        else{
            if (i==myTask.fltTasks.count-1) {
                UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"您好，您目前没有需要进行飞行准备的任务，敬请关注！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]  autorelease];
                [alert show];
                buttonForNextStep.enabled=NO;
            }
        }
    }
    
    NSString* totalTime=self.myTask.totalTime;
    
    if (totalTime==nil) {
        totalTime=@"";
    }
    
    self.headerLable.text=[NSString stringWithFormat:@"本月累计实际飞行总小时数: %@ 小时\n",totalTime ];
    [self.headerLable setBackgroundColor:[UIColor colorWithRed:0 green:83/255.0 blue:162/255.0 alpha:1.0]];
    [self.headerLable setTextColor:[UIColor whiteColor]];
    
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [userQuery cancelTheRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)requestChangeView:(id)sender{
    
//    if (![self.navigationController isKindOfClass:[PilotNavigationViewController class]]) {
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }
    
     [[FPCoordinatingController shareInstance] requestViewChangeBy:sender];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return self.myTask.fltTasks.count;
    }else if(section==1) {
        return self.myTask.otherTasks.count ;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"TaskCell";
        FPTaskTableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [FPTaskTableViewCell getInstance];
            [cell.teamMemberButton addTarget:self action:@selector(loadTeamMember:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        FltTask* fltTask=[self.myTask.fltTasks objectAtIndex:indexPath.row];
        cell.filghtNoLabel.text=fltTask.flightNo;
        cell.leaderNoLabel.text=fltTask.leaderNo;
        cell.taskTypeLabel.text=fltTask.taskType;
        cell.depPortLabel.text=fltTask.depPort;
        cell.arrPortLabel.text=fltTask.arrPort;
        cell.depTimeLabel.text=fltTask.depTime;
        cell.arrTimeLabel.text=fltTask.arrTime;
        cell.planeLabel.text=fltTask.plane;
        cell.tailNumLabel.text=fltTask.tailNum;
        cell.readyFlag.text   =fltTask.readyFlagName;
        
        cell.teamMemberButton.tag=indexPath.row;
        
        return cell;
        
    }
    
    if (indexPath.section==1) {
        
        static NSString *CellIdentifier = @"OtherTaskCell";
    
        FPTaskTableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell=[FPTaskTableViewCell getOtherTaskInstance];
        }
        
        OtherTask* otherTask=[myTask.otherTasks objectAtIndex:indexPath.row];
        cell.taskCodeLabel.text = [NSString stringWithFormat:@"%@",otherTask.code];
        cell.beginTimeLabel.text = [NSString stringWithFormat:@"%@",otherTask.beginTime];
        cell.endTimeLabel.text = [NSString stringWithFormat:@"%@",otherTask.endTime];
        
        return cell;
        
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 240;
    }else if(indexPath.section==1) {
        return 80 ;
    }
    
    return 44;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"其它任务";
    }
    return nil;
    
}

-(void)loadTeamMember:(UIButton*)sender{
    
    FPTaskTeamMemberViewController* aFPTaskTeamMemberViewController=[[FPTaskTeamMemberViewController alloc]init];
    aFPTaskTeamMemberViewController.listOfMembers=[[self.myTask.fltTasks objectAtIndex:sender.tag] members];
    
    [self.navigationController pushViewController:aFPTaskTeamMemberViewController animated:YES];
    [aFPTaskTeamMemberViewController release];
    
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       
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
