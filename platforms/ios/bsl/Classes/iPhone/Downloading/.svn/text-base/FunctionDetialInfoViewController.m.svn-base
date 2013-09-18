//
//  FunctionDetialInfoViewController.m
//  Cube-iOS
//
//  Created by 陈 晶多 on 13-1-15.
//
//

#import "FunctionDetialInfoViewController.h"
#import "CubeApplication.h"
#import "HTTPRequest.h"
#import "ConfigManager.h"
#import "DownloadManager.h"


#define KDISPALYVIEWWIDTH (320*self.dispayScrollView.frame.size.height/480)
#define kURL_PATH1 @"/m/widget"
#define kURL_PATH2 @"/snapshot"

static const NSString *const kLoadIconOperationKey = @"kLoadIconOperationKey";


@interface FunctionDetialInfoViewController ()
@property (retain,nonatomic) NSMutableArray *imageArray;

@end

@implementation FunctionDetialInfoViewController

- (void)dealloc {
    
    [[DownloadManager instance] cancelRequestForKey:kLoadIconOperationKey];
    
    [_iconImage release];
    [_functionName release];
    [_describeText release];
    [_newestVersion release];
    [_configButton release];
    [_dispayScrollView release];
    [_pageControl release];
    [_iconUrlArr release];
    [_wrapper release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //每次进入不处理同步，但是离开会处理同步
    firstEnter=TRUE;
    self.title=@"模块详情";
    self.identifier=_curCubeModlue.identifier;
    self.functionName.text=_curCubeModlue.name;
    self.iconImage.isShowMode=TRUE;
    [self.iconImage defaultSet];
     self.iconImage.frame=CGRectMake(10, 0, 85 , 113);
    [self.iconImage transformWithWidth:85 andHeight:123];
    self.iconImage.iconLabel.text = @"";
//    [self.iconImage loadImageWithURLString:self.curCubeModlue.iconUrl];
    self.newestVersion.text=_curCubeModlue.version;
//    self.describeText.text= _curCubeModlue.releaseNote;//为null时崩溃
    self.describeText.text= [_curCubeModlue.releaseNote stringByTrimmingCharactersInSet:[NSCharacterSet illegalCharacterSet]];
    _configButton.hidden=_curCubeModlue.local?TRUE:FALSE;
    self.iconUrlArr = [[[NSMutableArray alloc] init] autorelease];
    
    self.dispayScrollView.dataSource = self;
    self.dispayScrollView.delegate = self;

    
    [self loadImageData];
    
    
    if (_buttonStatus==InstallButtonStateUninstall) {
        _curTitle=EBTNINSTALL1;
    }else if (_buttonStatus==InstallButtonStateInstalled){
        _curTitle=EBTNDELETE1;
    }else
    {
        _curTitle=EBTNUPDATE1;
    }
    
    self.iconImage = [[IconButton alloc]initWithModule:self.curCubeModlue stauts:self.buttonStatus delegate:nil];
    
    if ([_iconImage stauts]==5) {
        self.configButton.btnStatus = InstallButtonStateInstalling;
    }else
    {
        self.configButton.btnStatus = _buttonStatus;
    }
   
    [self.view addSubview:_iconImage];
    
    
    self.wrapper.scrollView = self.dispayScrollView;
    
    if (CDV_IsIPhone5()) {
     self.pageControl.frame = CGRectMake( self.pageControl.frame.origin.x, 498 -self.pageControl.frame.size.height, self.pageControl.frame.size.width,self.pageControl.frame.size.height );
    }else{
         self.pageControl.frame = CGRectMake( self.pageControl.frame.origin.x, self.view.frame.size.height -self.pageControl.frame.size.height, self.pageControl.frame.size.width,self.pageControl.frame.size.height );
    }
    
    
   
}

- (void)viewDidUnload {
    
    [self setIconImage:nil];
    [self setFunctionName:nil];
    [self setDescribeText:nil];
    [self setNewestVersion:nil];
    [self setConfigButton:nil];
    [self setDispayScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self enableDetialInfoNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self disableDetialInfoNotification];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self synAppInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-- scrollView delegate
//滑动scrollView的回调方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    CGFloat pageWidth = self.dispayScrollView.pageWidth;
    int apage = floor((self.dispayScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = apage;
    self.dispayScrollView.currentPage = apage;
    NSArray *subView = self.pageControl.subviews;     // UIPageControl的每个点
	
    for (int i = 0; i < [subView count]; i++) {
		UIImageView *dot = [subView objectAtIndex:i];
		dot.image = (self.pageControl.currentPage == i ? [UIImage imageNamed:@"scorllview_dot_choose.png"] : [UIImage imageNamed:@"scorllview_dot_unchoose.png"]);
	}
}


//用户点击pageContrller的小圈圈
- (IBAction)pageChange:(id)sender {
//    int pagea = self.pageControl.currentPage;
//    CGRect frame = self.dispayScrollView.frame;
//    frame.origin.x = (self.dispayScrollView.pageWidth +10) * (pagea);
//    frame.origin.y = self.dispayScrollView.frame.origin.y;
//    [self.dispayScrollView scrollRectToVisible:frame animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    UIView *subView = [self.dispayScrollView.subviews objectAtIndex:self.dispayScrollView.currentPage];
//    NSLog(@"current page: %d",self.dispayScrollView.currentPage);
//    CGPoint offset = CGPointMake(subView.frame.origin.x - self.dispayScrollView.pageMargin - self.dispayScrollView.pageCornerWidth, subView.frame.origin.y);
    //[self.dispayScrollView setContentOffset:offset animated:YES];
}


#pragma mark --- notification method
-(void)finishDownload:(id)sender
{
//     kAlert(@"安装成功");
    _curTitle=EBTNDELETE1;
    self.configButton.btnStatus = InstallButtonStateInstalled;
}

-(void)finishDelete:(id)sender
{
//    kAlert(@"删除成功");
    _curTitle=EBTNSYN1;
    self.configButton.btnStatus = InstallButtonStateUninstall;
    [self synAppInfo];
    
}

-(void)failedDownload:(id)sender
{
    _curTitle=EBTNINSTALL1;
    self.configButton.btnStatus = InstallButtonStateUninstall;
}

-(void)failedDelete:(id)sender
{
      kAlert(@"删除失败");
    _curTitle=EBTNSYN1;
    self.configButton.btnStatus = InstallButtonStateInstalled;
    [self synAppInfo];
  
}

-(void)failedSyn:(id)sender
{
    if (!firstEnter) {
         kAlert(@"同步失败，请重试");

        _curTitle=EBTNSYN1;
//        self.configButton.btnStatus = InstallButtonStateSynFailed;
    }
}

-(void)finishSyn:(id)sender
{
    if (!firstEnter) {
        _curTitle=EBTNINSTALL1;
        self.configButton.btnStatus = InstallButtonStateUninstall;
        //主要解决删除后，安装队列里面没有东东问题
        if (_curTitle==EBTNINSTALL1) {
            for (CubeModule *tempModule in [[CubeApplication currentApplication] availableModules]) {
                if ([tempModule.identifier isEqualToString:_identifier]) {
                    self.curCubeModlue=tempModule;
                    break;
                }
            }
        }
        else if (_curTitle==EBTNUPDATE1)
        {
            for (CubeModule *tempModule in [[CubeApplication currentApplication] updatableModules]) {
                if ([tempModule.identifier isEqualToString:_identifier]) {
                    self.curCubeModlue=tempModule;
                    break;
                }
            }
        }else
        {
            NSLog(@"do nothing");
        }

    }
}

#pragma mark ---  private method
//应用同步并刷新队列
- (void)synAppInfo
{
    [[CubeApplication currentApplication] sync];
}


//开启消息通知
-(void)enableDetialInfoNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDelete:) name:KNOTIFICATION_DETIALPAGE_DELETESUCCESS object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishDownload:) name:KNOTIFICATION_DETIALPAGE_INSTALLSUCCESS object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedDownload:) name:KNOTIFICATION_DETIALPAGE_INSTALLFAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedDelete:) name:KNOTIFICATION_DETIALPAGE_DELETEFAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSyn:) name:KNOTIFICATION_DETIALPAGE_SYNSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedSyn:) name:KNOTIFICATION_DETIALPAGE_SYNFAILED object:nil];
}

//关闭消息通知
-(void)disableDetialInfoNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)clickConfigButton:(id)sender {
    firstEnter=FALSE;
    InstallButton * button = sender;
    [button setEnabled:NO];
    if (_curTitle==EBTNSYN1) {
        button.btnStatus=InstallButtonStateUninstall;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先同步已获取改应用的最新资源" delegate:self cancelButtonTitle:@"同步" otherButtonTitles:@"取消", nil];
        alert.tag=1234;
        [alert show];
        [alert release];
    }else if (button.btnStatus == InstallButtonStateSynFailed) {
        //重新同步回去应用信息
        [self synAppInfo];
    }
    else if (button.btnStatus == InstallButtonStateInstalled) {
        button.btnStatus = InstallButtonStateDeleting;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确认删除该模块?"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        alert.tag = 5;
        [alert show];
        [alert release];
    }else
    {
        //icon状态改变为downloading
        self.iconImage.stauts = IconButtonStautsDownloading;
        
        //点击下载后改变button状态(下载中)
        InstallButton * button = sender;
        button.btnStatus = InstallButtonStateInstalling;
        
        CubeApplication *cubeApp = [CubeApplication currentApplication];
        CubeModule *downloadModule = [cubeApp availableModuleForIdentifier:_curCubeModlue.identifier];
        
        if(!downloadModule){
            
            downloadModule = [cubeApp updatableModuleModuleForIdentifier:_curCubeModlue.identifier];
        }
        //如果已经在下载,返回
        if(downloadModule.isDownloading)
            return;
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadAtModuleIdentifier:andCategory:)])  {
            [self.delegate downloadAtModuleIdentifier:_curCubeModlue.identifier andCategory:_curCubeModlue.category];
        }
    }
}



//请求快照图片地址数据
-(void)loadImageData{
    HTTPRequest* request = [HTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/%d%@",kServerURLString,kURL_PATH1,self.identifier,self.curCubeModlue.build,kURL_PATH2]]];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getResult:)];
    [request setDidFailSelector:@selector(getFailMessage:)];
    
    [[DownloadManager instance] addOperation:request forIdentifier:kLoadIconOperationKey];
}

//取得请求数据 提醒scrollview更新
-(void)getResult:(HTTPRequest *)request{
    NSData *data = [request responseData];
    NSArray *array = [data objectFromJSONData];
    for(NSDictionary *dict in array){
        NSString *attachment = [dict objectForKey:@"snapshot"];
        NSString *urlStr  = [NSString stringWithFormat:@"%@/storage/attachments/%@",kServerURLString,attachment];
        [self.iconUrlArr addObject:urlStr];
    }

    self.pageControl.numberOfPages=[self.iconUrlArr count];
    self.pageControl.currentPage=0;
    self.pageControl.imagePageStateNormal=[UIImage imageNamed:@"scorllview_dot_unchoose.png"];
    self.pageControl.imagePageStateHightlighted=[UIImage imageNamed:@"scorllview_dot_choose.png"];
    NSArray *subView = self.pageControl.subviews;     // UIPageControl的每个点
	for (int i = 0; i < [subView count]; i++) {
		UIImageView *dot = [subView objectAtIndex:i];
		dot.image = (self.pageControl.currentPage == i ? [UIImage imageNamed:@"scorllview_dot_choose.png"] : [UIImage imageNamed:@"scorllview_dot_unchoose.png"]);
	}

    [self.dispayScrollView notifyDataChange];
    
}

//请求数据失败
-(void)getFailMessage:(HTTPRequest *)request{
    /*UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"连接失败" message:@"网络问题或者服务器连接失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];*/
}

-(NSMutableArray *)urlArrayForImages{
    return self.iconUrlArr;
}

#pragma mark -- alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1234) {
        if (buttonIndex==0) {
            [self synAppInfo];
        }
    }
    if(alertView.tag == 5){
        if(buttonIndex == 0){
            if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteAtModuleIdentifier:)])  {
                [self.delegate deleteAtModuleIdentifier:_curCubeModlue.identifier];
                self.configButton.btnStatus = InstallButtonStateUninstall;
            }
        }
        self.configButton.btnStatus = InstallButtonStateInstalled;
    }
}

@end
