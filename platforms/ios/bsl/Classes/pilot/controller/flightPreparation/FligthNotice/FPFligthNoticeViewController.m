//
//  FPFligthNoticeViewController.m
//  pilot
//
//  Created by Sencho Kong on 12-11-7.
//  Copyright (c) 2012年 chen shaomou. All rights reserved.
//

#import "FPFligthNoticeViewController.h"
#import "FPCoordinatingController.h"
#import "MBProgressController.h"
#import "BaseQuery.h"
#import "AirlineAnnounce.h"
#import "AirlineData.h"
#import "NSString+Verification.h"
#import "FPFlightNoticeCell.h"
#import "FPAirlineAnnounceCell.h"
#import "FPAnnexContentViewController.h"
#import "FileQuery.h"
#import "AnnounceText.h"
#import "FPFlightReportViewController.h"

@interface FPFligthNoticeViewController (){
    
    CGFloat tableWidth;
}

@property(nonatomic,retain)UISegmentedControl* noticeSegment;
@property(nonatomic,retain)AirlineAnnounce* myAirlineAnnounce;
@property(nonatomic,retain)NSArray*   myListOfAirlineData;

@property(nonatomic,retain)NSMutableDictionary* tableViewHeightCache;   //行高缓存；
@end

@implementation FPFligthNoticeViewController
@synthesize noticeSegment;
@synthesize myAirlineAnnounce;
@synthesize myListOfAirlineData;
@synthesize noticeInfoTableView = _noticeInfoTableView;
@synthesize plantInfoTableView = _plantInfoTableView;
@synthesize mapTablewView = _mapTablewView;
@synthesize AirlineDataCell = _AirlineDataCell;
@synthesize tableViewHeightCache;

-(void)dealloc{
    
    [myListOfAirlineData release];
    [myAirlineAnnounce release];
    [noticeSegment release];
    [_noticeInfoTableView release];
    [_plantInfoTableView release];
    [_mapTablewView release];
    [_AirlineDataCell release];
    [tableViewHeightCache release];
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title=@"航行通告";
    
    UIImage *buttonForBackImage = [UIImage imageNamed: @"BackButtonItem"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30) ];
    [backButton setBackgroundImage:buttonForBackImage forState:UIControlStateNormal];
    [backButton setTitle:@"  卫星云图" forState:UIControlStateNormal];
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
    buttonForNextStep.tag=kButtonTagOpenImportantDocView;
    UIBarButtonItem *nextStepItem = [[UIBarButtonItem alloc] initWithCustomView:buttonForNextStep];
    [buttonForNextStep release];
    self.navigationItem.rightBarButtonItem = nextStepItem;
    [nextStepItem release];
    
    
    UISegmentedControl* aSegmentedControl=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"通告信息",@"机场信息",@"航图", nil]];
    [aSegmentedControl setTintColor:[UIColor colorWithRed:42.0/255.0 green:142.0/255.0 blue:217.0/255.0 alpha:1.0]];
    [aSegmentedControl addTarget:self action:@selector(didSelectedSegment:) forControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];
    aSegmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
    // self.tableView.tableHeaderView=aSegmentedControl;
    self.noticeSegment=aSegmentedControl;
    [aSegmentedControl release];
    noticeSegment.selectedSegmentIndex=0;
    noticeSegment.selected=YES;
    
    [noticeSegment setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 31)];
    [noticeSegment setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth ];
    noticeSegment.backgroundColor =[UIColor clearColor];
    [self.view addSubview:noticeSegment];
    
    
    
    [[NSBundle mainBundle] loadNibNamed:@"FPFligthNoticeTableViews"
                                  owner:self
                                options:nil];
    noticeSegment.selectedSegmentIndex=0;
    
    [self didSelectedSegment:noticeSegment];
    
     
    self.tableViewHeightCache=[NSMutableDictionary dictionary];
    
}

//航行通告信息查询
-(void)airlineAnnounceQuery{
    
    BaseQuery *query=[[BaseQuery alloc]init];
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
    //Url : /airlineAnnounce/route/staff_no/flt_no/flt_date/dep_port
    
    // NSString* url=[NSString stringWithFormat:@"%@/data/airlineAnnounce/CAN-PER/%@/%@/%@/%@",BASEURL,TaskDelegate.empId,TaskDelegate.flightNo,TaskDelegate.flightDate,TaskDelegate.depAirport] ;
    
    NSDate *date = [NSDate date];
    NSTimeInterval totalTimeDouble = [date timeIntervalSinceDate:TaskDelegate.lastTime];
    NSString *totalTime = [NSString stringWithFormat:@"%.2f", totalTimeDouble];
    TaskDelegate.lastTime=date;
    
    NSString* url=[NSString stringWithFormat:@"%@/data/airlineAnnounce/%@/%@/%@/%@/%@/%@",BASEURL,TaskDelegate.route,TaskDelegate.empId,TaskDelegate.flightNo,TaskDelegate.flightTime,TaskDelegate.depAirport,totalTime] ;
    
    [query queryObjectWithURL:url parameters:nil completion:^(NSObject *airlineAnnounce) {
        
        [MBProgressController dismiss];
        if (airlineAnnounce != nil) {
            self.myAirlineAnnounce=(AirlineAnnounce*)airlineAnnounce;
            [self.noticeInfoTableView reloadData];
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询超时，请重新再试！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] autorelease];
            [alert show];
        }        
    } failed:^(NSData *responseData) {
        [MBProgressController dismiss];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询失败，请重新再试！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] autorelease];
        [alert show];
    }];
    
    [query release];
}

//机场信息查询
-(void)airlineDataQuery{
    
    BaseQuery *query=[[BaseQuery alloc]init];
    
    [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
    [MBProgressController startQueryProcess] ;
    
    //Url:/airlineDatas/depPort/arvPort/staff_no/flt_no/flt_date
    
    NSString* url=[NSString stringWithFormat:@"%@/data/airlineDatas/%@/%@/%@/%@/%@",BASEURL,TaskDelegate.depAirport,TaskDelegate.arvAirport,TaskDelegate.empId,TaskDelegate.flightNo,TaskDelegate.flightDate] ;
    
    [query queryArrayWithURL:url parameters:nil completion:^(NSArray *listOfAirLineData) {
        [MBProgressController dismiss];
        if (listOfAirLineData) {
            self.myListOfAirlineData=listOfAirLineData;
            [self.plantInfoTableView reloadData];
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询超时，请重新再试！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] autorelease];
            [alert show];
        }
        
        
    } failed:^(NSData *responseData) {
        [MBProgressController dismiss];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询失败，请重新再试！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] autorelease];
        [alert show];
    }];
    
    
    [query release];
}


-(void)airPortFileQueryWithCode:(NSString*)code{
//    if (code && ([code isEqualToString:@"ZGGG"] || [code isEqualToString:@"ZJSY"])) {
//        FileQuery* query=[[FileQuery alloc]init];
//        
//        [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
//        [MBProgressController startQueryProcess] ;
//        
//        [query queryFileWithName:[code stringByAppendingPathExtension:@"pdf"] FileType:[NSString stringWithFormat:@"%@_%@",AIRPORT_FILE,code] completion:^(NSString *fileDataPath) {
//            
//            
//            [MBProgressController dismiss];
//            
//            if ([fileDataPath length]>0) {
//                
//                FPAnnexContentViewController *detailViewController = [[FPAnnexContentViewController alloc] initWithNibName:@"FPAnnexContentViewController" bundle:nil];
//                detailViewController.title=@"机场特点";
//                
//                detailViewController.annexURL=[NSURL fileURLWithPath:fileDataPath];
//                [self.navigationController pushViewController:detailViewController animated:YES];
//                [detailViewController release];
//                
//                
//            }else{
//                
//                UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"该机场暂无机场特点信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
//                [alert show];
//            }
//            
//            
//            
//        } failed:^(NSString *error) {
//            
//            [MBProgressController dismiss];
//            
//            UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"连接服务失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
//            [alert show];
//            
//            
//        }];
//        [query release];
//    }else{
//        UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"该机场暂无机场特点信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
//        [alert show];
//    }
    
    UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"提示" message:@"该机场暂无机场特点信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}


-(void)didSelectedSegment:(UISegmentedControl*)sender{
    
    UITableView* tablewView = nil;
    
    switch (sender.selectedSegmentIndex) {
        case 0:{
            tablewView= self.noticeInfoTableView;
            [self airlineAnnounceQuery];
            
        }
            
            break;
        case 1:
            tablewView= self.plantInfoTableView;
            [self airlineDataQuery];
            break;
        case 2:
            tablewView=  self.mapTablewView;
            break;

            
        default:
            break;
    }
    
    [tablewView setFrame: CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30)];
    [tablewView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
    tablewView.delegate=self;
    tablewView.dataSource=self;
    
    UIImageView *imageview = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
    [imageview setImage:[UIImage imageNamed:@"Background_768X1024.png"]];
    [tablewView setBackgroundView:imageview];
    
    [self.view addSubview:tablewView];
}

-(void)requestChangeView:(id)sender{
    TaskDelegate.lastTime=[NSDate date];
    [[FPCoordinatingController shareInstance] requestViewChangeBy:sender];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView==self.noticeInfoTableView){
        return 3;
    }
    if (tableView==self.plantInfoTableView){
        return self.myListOfAirlineData.count;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==self.noticeInfoTableView) {
        
        if (section==0) {
            return 1;
        }else if(section==1){
            return 4;
        }else if (section==2){
            return self.myAirlineAnnounce.announceTexts.count;
        }
        
    }
    //机场信息
    if (tableView==self.plantInfoTableView) {
        return self.myListOfAirlineData.count;
    }
    
    
    if (tableView==self.mapTablewView) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.noticeInfoTableView) {
        if (indexPath.section==0) {
            
            static NSString *NoticCellIdentifier = @"NoticeCell";
            FPFlightNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NoticCellIdentifier];
            
            if (cell == nil) {
                cell=[FPFlightNoticeCell getNoticeInstance]  ;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            cell.routeLabel.text = TaskDelegate.route;
            cell.queryTimeLabel.text = self.myAirlineAnnounce.queryTime;
            cell.queryTimeLabel.numberOfLines = 0;
            cell.effectTimeLabel.text = self.myAirlineAnnounce.effectTime;
            cell.effectTimeLabel.numberOfLines = 0;
            return cell;
            
        }else if(indexPath.section==1){
            
            static NSString *InfoCellIdentifier = @"InfoCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
            if (cell == nil) {
                cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InfoCellIdentifier]autorelease];
            }
            cell.detailTextLabel.numberOfLines=0;
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"顺 序：";
                    cell.detailTextLabel.text=self.myAirlineAnnounce.routeCH;
                    break;
                case 1:
                     cell.textLabel.text=@"情报区：";
                    cell.detailTextLabel.text=self.myAirlineAnnounce.infoArea;
                    break;
                case 2:
                     cell.textLabel.text=@"备降区：";
                     cell.detailTextLabel.text=self.myAirlineAnnounce.alterArea;
                    
                    break;
                case 3:
                     cell.textLabel.text=@"其它机场：";
                     cell.detailTextLabel.text=self.myAirlineAnnounce.other;
                    break;
                    
                default:
                    break;
            }
            return cell;
            
        }
        
    }
    if (tableView==self.plantInfoTableView) {
        /*
         
         
         arpShortCode;   //机场名的三字码
         arpName;        //机场名
         arpLongCode;    //机场名四字码
         latitude;       //纬度
         longitude;      //经度
         locationName;   //地名
         fir;            //情报区
         useful;         //用途
         ifInternat;     //是否国际机场
         elevation;      //标高
         var;            //磁差
         railway;        //跑道长
         summertime;     //夏令时
         timezone;       //时区
         insrailway;     //仪表跑道
         comment;        //备注
         country;        //国家名
         arpFileUrl;     //机场特点文件下载路径
         
         */
        if (indexPath.row==0) {
            
            static NSString *CellIdentifier = @"PlantInfoCell";
            FPFlightNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell=[FPFlightNoticeCell getInstance]  ;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            AirlineData*  aAirlineData=[self.myListOfAirlineData objectAtIndex:indexPath.section];
            
            cell.arpLongCode.text=aAirlineData.arpLongCode;
            cell.arpName.text=aAirlineData.arpName;
            cell.arpShortCode.text=aAirlineData.arpShortCode;
            cell.latitude.text=aAirlineData.latitude;
            cell.longitude.text=aAirlineData.longitude;
            
            if (aAirlineData.locationName==nil ||[aAirlineData.locationName length]==0) {
                aAirlineData.locationName=aAirlineData.arpName;
            }
            cell.locationName.text=aAirlineData.locationName;
            cell.fir.text=aAirlineData.fir;
            cell.useful.text=aAirlineData.useful;
            cell.elevation.text=aAirlineData.elevation;
            cell.var.text=aAirlineData.var;
            cell.railway.text=aAirlineData.railway;
            cell.summertime.text=aAirlineData.summertime;
            cell.timezone.text=aAirlineData.timezone;
            cell.insrailway.text=aAirlineData.insrailway;
            cell.country.text=aAirlineData.country;
            
            
            CGSize size = [aAirlineData.comment sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(tableWidth,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            CGRect  labelRect= cell.comment.frame;
            cell.comment.frame=CGRectMake(labelRect.origin.x,labelRect.origin.y-10,labelRect.size.width, size.height);
            
            cell.comment.text=aAirlineData.comment;
            cell.comment.numberOfLines  = 0;
            [cell.comment setNeedsDisplay];
            
            return cell;
            
        }else{
            
            
            static NSString *CellIdentifier = @"PlantInfoCellNormal";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.numberOfLines=0;
            
            cell.textLabel.text=@"机场特点";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        
        return nil;
        
    }
    
    
    if (tableView==self.mapTablewView) {
        static NSString *CellIdentifier = @"MapCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.row==0) {
            cell.textLabel.text=@"国内航图查询";
        }else{
            cell.textLabel.text=@"JEPPESEN";
        }
        
        return cell;
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.noticeInfoTableView) {
        switch (indexPath.section) {
            case 0:
                return 160;
                break;
            case 1:{
                
                
                CGFloat width;
                if (device_Type == UIUserInterfaceIdiomPad){
                    width=530.0;
                }else{
                    width=230.0;
                }
             
                
                break;
            }
            case 2:{
                
                NSString* info = nil;
                
                switch (indexPath.row) {
                    case 0:
                        info=self.myAirlineAnnounce.route;
                        break;
                    case 1:
                        info=self.myAirlineAnnounce.infoArea;
                        break;
                    case 2:
                        info=self.myAirlineAnnounce.alterArea;
                        break;
                    case 3:
                        info=self.myAirlineAnnounce.other;
                        break;
                        
                    default:
                        
                        break;
                }

                
                //减去30的右箭头图标
              CGSize  size = [info sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableWidth-30,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
                
                if (size.height<44) {
                    return 44;
                }
                return size.height;
                
             
                return 44;
            }
                break;
                
            default:
                break;
        }
        return 44;
    }if (tableView==self.plantInfoTableView) {
        if (indexPath.row==0) {
            
            AirlineData*  aAirlineData=[self.myListOfAirlineData objectAtIndex:indexPath.section];
            CGSize size = [aAirlineData.comment sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(tableWidth,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            
            return 230+size.height;
        }
        
        
    }if (tableView==self.mapTablewView) {
        return 44;
    }
    return 44;
    
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.noticeInfoTableView&&indexPath.section==1) {
        
        NSString* fourCode=nil;
        switch (indexPath.row) {
            case 0:
                fourCode= [self.myAirlineAnnounce.route stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                break;
            case 1:
                fourCode= [self.myAirlineAnnounce.infoArea stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                break;
            case 2:
                fourCode=[self.myAirlineAnnounce.alterArea stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                break;
            case 3:
                fourCode=[self.myAirlineAnnounce.other stringByReplacingOccurrencesOfString:@" " withString:@"-"];
                break;
                
            default:
                break;
        }
        
        
        BaseQuery *query=[[BaseQuery alloc]init];
        
        [[MBProgressController getCurrentController] setMessage:@"正在查询..."];
        [MBProgressController startQueryProcess] ;
        
        //Url :  /data/otherAirlineAnnounce/机场四字码串        
    
        NSString* url=[NSString stringWithFormat:@"%@/data/otherAirlineAnnounce/%@",BASEURL,fourCode] ;
        
        [query queryObjectWithURL:url parameters:nil completion:^(NSObject *airlineAnnounce) {
            
                    
            [MBProgressController dismiss];
            
            AirlineAnnounce* aAirlineAnnounce=(AirlineAnnounce*)airlineAnnounce;
            
            if (aAirlineAnnounce.announceTexts != nil) {
                
                
                FPFlightReportViewController* aFPFlightReportViewController=[[FPFlightReportViewController alloc]initWithStyle:UITableViewStyleGrouped];
                
                NSString *airportAnnounce = [(AnnounceText*)[aAirlineAnnounce.announceTexts objectAtIndex:0] announceText];
                
                
                aFPFlightReportViewController.reportData=[airportAnnounce  componentsSeparatedByString:@"$"] ;
                
                [self.navigationController pushViewController:aFPFlightReportViewController animated:YES];
                [aFPFlightReportViewController release];
                
            
            }else{
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询超时，请重新再试！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] autorelease];
                [alert show];
            }
        } failed:^(NSData *responseData) {
            [MBProgressController dismiss];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询超时，请重新再试！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] autorelease];
            [alert show];
        }];
        
        [query release];
        
        
       
    
    }
    
    
   
    
    
    if (tableView==self.plantInfoTableView) {
        
        if (indexPath.row==1) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"目前暂无机场特点信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [alert show];
            
            
//            AirlineData*  aAirlineData= [self.myListOfAirlineData objectAtIndex:indexPath.section];
//            [self airPortFileQueryWithCode:aAirlineData.arpLongCode];
        }
        
    }
    
    
    
    if (tableView==self.mapTablewView){
        
        
        FPAnnexContentViewController *detailViewController = [[FPAnnexContentViewController alloc] initWithNibName:@"FPAnnexContentViewController" bundle:nil];
        
        if (indexPath.row==0) {
            detailViewController.annexURL=[NSURL URLWithString:@"http://125.88.6.180/begin.aspx?edition=es"];
        }else{
            detailViewController.annexURL=[NSURL URLWithString:@"https://www.jeppesen.com/elink/LoginInterceptor"];
        }
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    }
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (device_Type == UIUserInterfaceIdiomPad) {
        
        if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
            tableWidth=1000;
        }else{
            tableWidth=730;
        }
        
        return YES;
    }else{
        if (interfaceOrientation==UIInterfaceOrientationPortrait) {
            tableWidth=300;
            return YES;
        }
        return NO;
    }
}

-(BOOL)shouldAutorotate{
    
    if (device_Type == UIUserInterfaceIdiomPhone){
        return NO;
    }else{
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations{
    
    if (device_Type == UIUserInterfaceIdiomPad) {
        tableWidth=1000;
        
        return   UIInterfaceOrientationMaskAll;
        
        
    }else{
        
        tableWidth=300;
        
        return UIInterfaceOrientationMaskPortrait  ;
        
        
    }
    
}




- (void)viewDidUnload {
    [self setNoticeInfoTableView:nil];
    [self setPlantInfoTableView:nil];
    [self setMapTablewView:nil];
    [self setAirlineDataCell:nil];
    [super viewDidUnload];
}
@end
