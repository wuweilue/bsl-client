//
//  XMPPFriendsViewController.m
//  cube-ios
//
//  Created by 东 on 13-3-5.
//
//

#import "XMPPFriendsViewController.h"

#import "ASIFormDataRequest.h"
#import "UIColor+expanded.h"
#import "XMPPSearchViewController.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPSqlManager.h"
#import "SVProgressHUD.h"
#import "XMPPvCardTempModule.h"
#import "XMPPRoom.h"
#import "XMPPFramework.h"
#import "XMPPJID.h"

#import "JSONKit.h"
#import "NSManagedObject+Repository.h"
#import "XMPPSqlManager.h"
//fanty temp
//#import "XMPPGroupAddViewController.h"
//#import "XMPPChatRoomViewController.h"
#import "CollectedFriend.h"

#import "ChatMainViewController.h"

#define kNumViewTag 100
#define kNumLabelTag 101

enum{
    kXMPPLatestComunication =1,
    kXMPPAllFriends =2,
    kXMPPAllGroups =3,
    
};


@interface XMPPFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,ChatDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate>{
    NSMutableArray * friendsArray;
    NSMutableArray * friendsSearchArray;
    NSMutableDictionary *friends;
    NSString * chatUserName;
    NSXMLElement *xmlElement;
    BOOL isFirstLoadUserInfo;
    XMPPRoom *xmpproom;
    XMPPMUC *xmppMUC;
    UIView * bgView;
    UIView *titleView;
    UILabel *mytitleLabel;
    int currentTag;
    NSMutableArray * latestUserArray;
    NSMutableArray * collectedArray;
}

//- (void)animationDidStart:(CAAnimation *)anim;
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;


@end

@implementation XMPPFriendsViewController
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize userFetchedResultsController = _userFetchedResultsController;
@synthesize friendsFetchedResultsController =_friendsFetchedResultsController;
@synthesize isOpen;
@synthesize selectIndex;
@synthesize oldSelectIndex;
@synthesize curFliterStr;
@synthesize isSearch;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.managedObjectContext = [ShareAppDelegate xmpp].managedObjectContext;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	latestUserArray =[[NSMutableArray alloc]initWithCapacity:0];
    friendsArray = [[NSMutableArray alloc]init];
    friendsSearchArray = [[NSMutableArray alloc]init];
    collectedArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    _friendsTableView.delegate = self;
    _friendsTableView.dataSource = self;
    AppDelegate *del = [self appDelegate];
    del.xmpp.chatDelegate = self;
    //    collectedDictionary =[[NSMutableDictionary alloc]initWithCapacity:0];
    self.title = @"最近联系好友";
    _friendsTableView.separatorStyle = NO;
    
    self.selectIndex = -1;
    //添加顶部view
    titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 50)];
    titleView.backgroundColor= [[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"normal_bg.png"]]autorelease];
    //    UIImageView *imageView=[[UIImageView alloc]initWithFrame:titleView.frame];
    //    imageView.image=[UIImage imageNamed:@"bg_search_lightgray"];
    //    [titleView addSubview:imageView];
    [self.view addSubview:titleView];
    //添加顶部的切换按钮
    if ([[ShareAppDelegate xmpp] isConnected]) {
        [[ShareAppDelegate xmpp] findFriendsList];
    }
    bgView= [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 106, 50)]retain];
    bgView.backgroundColor = [[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"clicked_bg.png"]]autorelease];
    [titleView addSubview:bgView];
    
    UIImageView *spereateView1 =[[UIImageView alloc]initWithFrame:CGRectMake(106, 0, 1, 50)];
    [spereateView1 setImage:[UIImage imageNamed:@"sperate_line.png"]];
    
    UIImageView *spereateView2 =[[UIImageView alloc]initWithFrame:CGRectMake(213, 0, 1, 50)];
    [spereateView2 setImage:[UIImage imageNamed:@"sperate_line.png"]];
    
    [titleView addSubview:spereateView1];
    [titleView addSubview:spereateView2];
    [spereateView1 release];
    [spereateView2 release];
    UIImageView *lastCoversationView = [[UIImageView alloc]initWithFrame:CGRectMake(43, 10, 30, 30)];
    [lastCoversationView setUserInteractionEnabled:YES];
    lastCoversationView.tag =101;
    currentTag = 101;
    [lastCoversationView setImage:[UIImage imageNamed:@"last_talk_friends_icon_clicked.png"]];
    UITapGestureRecognizer *lastGesture=  [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDifferentView:)]autorelease];
    [lastCoversationView addGestureRecognizer:lastGesture];
    
    UIImageView *allFriendsView = [[UIImageView alloc]initWithFrame:CGRectMake(145, 10, 30, 30)];
    [allFriendsView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *allGesture = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDifferentView:)]autorelease];
    allFriendsView.tag =102;
    [allFriendsView addGestureRecognizer:allGesture];
    [allFriendsView setImage:[UIImage imageNamed:@"all_friends_icon.png"]];
    UIImageView *groupView = [[UIImageView alloc]initWithFrame:CGRectMake(247, 10, 30, 30)];
    [groupView setUserInteractionEnabled:YES];
    groupView.tag =103;
    [groupView setImage:[UIImage imageNamed:@"add_friend_icon.png"]];
    UITapGestureRecognizer *groupGesture = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDifferentView:)]autorelease];
    [groupView addGestureRecognizer:groupGesture];
    [titleView addSubview:lastCoversationView];
    [titleView addSubview:allFriendsView];
    [titleView addSubview:groupView];
    [lastCoversationView release];
    [allFriendsView release];
    [groupView release];
    //添加当前好友搜索
    UIView *searchBarView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)] autorelease];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, searchBarView.frame.size.height)];
    imageView.image=[UIImage imageNamed:@"bg_search_lightgray"];
    [searchBarView addSubview:imageView];
    [imageView release];
    tableViewSearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(5, 0, 310, 40)] autorelease];
    [[tableViewSearchBar.subviews objectAtIndex:0]removeFromSuperview];
    tableViewSearchBar.delegate = self;
    tableViewSearchBar.placeholder = @"搜索好友";
    [searchBarView addSubview:tableViewSearchBar];
    [self.view addSubview:searchBarView];
    /*
     * 修改者： 张国东
     * 修改原因： 这个项目不需要用到即时通讯群聊功能
     *
     */
    //    //群组
    //    UIControl* myControl = [[[UIControl alloc] initWithFrame:CGRectMake(0.0f, 90.0f, self.view.bounds.size.width, 41)]autorelease];
    //    myControl.tag =200;
    //    [myControl addTarget:self action:@selector(showGroup) forControlEvents:UIControlEventTouchUpInside];
    //    UIImageView* myView = [[[UIImageView alloc] init] autorelease];
    //
    //    myView.backgroundColor = [UIColor colorWithRGBHex:0xFFFFFF];
    //
    //    myView.frame = CGRectMake(0, 0, self.view.frame.size.width, 41);
    //
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 41)];
    //    titleLabel.textColor= [ UIColor colorWithRGBHex:0x535353];
    //    titleLabel.backgroundColor = [UIColor clearColor];
    //    titleLabel.text= @"我的群组";
    //    [myView addSubview:titleLabel];
    //    [titleLabel release];
    //    [myControl addSubview:myView];
    
    //    //根据组名来获取该组所有的未读信息
    //    UIImageView* arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_arrow.png"]];
    //    arrowImageView.tag =201;
    //    if(currentTag == 101)
    //    {
    //        arrowImageView.frame= CGRectMake(300, 15, 10, 11);
    //    }
    //    else
    //    {
    //        arrowImageView.frame= CGRectMake(17, 15, 10, 11);
    //    }
    //
    //    [myControl addSubview:arrowImageView];
    //    [arrowImageView release];
    //
    //    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0,  myControl.frame.size.height-0.3,  myControl.frame.size.width, 0.3)];
    //    lineView.backgroundColor = [UIColor colorWithRGBHex:0x898989];
    //    [myView addSubview:lineView];
    //    [lineView release];
    //    [self.view addSubview:myControl];
    
    
    //    CGRect frame = self.friendsTableView.frame;
    //    frame.origin.y -= 41;
    //    self.friendsTableView.frame =frame;
    
    //关闭添加好友方法
    /*UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 43, 30)];
     [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn@2x.png"] forState:UIControlStateNormal];
     [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn_active@2x.png"] forState:UIControlStateSelected];
     [navRightButton setTitle:@"搜索" forState:UIControlStateNormal];
     [[navRightButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
     [navRightButton addTarget:self action:@selector(activateSearch) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:navRightButton] autorelease];
     [navRightButton release];*/
    
    [super viewDidLoad];
}

-(void)showGroup
{
    /* remove by fanty temp
    XMPPChatRoomViewController *controller = [[XMPPChatRoomViewController alloc]initWithNibName:@"XMPPChatRoomViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
     */
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self queryAllCollectedFriend:[[self appDelegate].xmpp.xmppStream.myJID bare]];
    });
    
}


-(void)changeUserStatus
{
    for(UserInfo *user in [self.fetchedResultsController fetchedObjects])
    {
        user.userStatue = nil;
        [user save];
    }
    [self.friendsTableView reloadData];
}

-(void)showDifferentView:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView  = (UIImageView*)sender.view;
    if(currentTag == imageView.tag)
    {
        return;
    }
    else
    {
        if((currentTag ==101&& imageView.tag==101) || (currentTag ==103&&imageView.tag==101))
        {
            self.isCanChange = NO;
        }
        else
        {
            self.isCanChange = YES;
        }
        currentTag = imageView.tag;
    }
    //    CATransition *animation = [CATransition animation];
    //    animation.delegate = self;
    //    animation.duration = 0.5;
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //    animation.type = kCATransitionReveal;
    //    animation.subtype = kCATransitionFromLeft;
    CGRect frame = bgView.frame;
    switch (imageView.tag) {
        case 101:
            frame.origin.x = 0;
            bgView.frame =frame;
            //            if([self.view viewWithTag:200].hidden)
            //            {
            //                [self.view viewWithTag:200].hidden = NO;
            //                CGRect frame = self.friendsTableView.frame;
            //                frame.origin.y += 41;
            //                self.friendsTableView.frame =frame;
            //            }
            //            UIImageView*imageView = (UIImageView*)[[self.view viewWithTag:200]viewWithTag:201];
            //            imageView.frame = CGRectMake(300, 15, 10, 11);
            
            //            mytitleLabel.text = @"最近联系好友";
            self.title=@"最近联系好友";
            [((UIImageView *)[titleView viewWithTag:101]) setImage:[UIImage imageNamed:@"last_talk_friends_icon_clicked.png"]];
            [((UIImageView *)[titleView viewWithTag:102]) setImage:[UIImage imageNamed:@"all_friends_icon.png"]];
            [((UIImageView *)[titleView viewWithTag:103]) setImage:[UIImage imageNamed:@"add_friend_icon.png"]];
            if (self.isSearch && self.curFliterStr.length !=0) {
                self.curFliterStr = @"";
                tableViewSearchBar.text=@"";
            }
            break;
        case 102:
            frame.origin.x = 107;
            bgView.frame =frame;
            //            if([self.view viewWithTag:200].hidden)
            //            {
            //                [self.view viewWithTag:200].hidden = NO;
            //                CGRect frame = self.friendsTableView.frame;
            ////                frame.origin.y += 41;
            //                self.friendsTableView.frame =frame;
            //            }
            //            UIImageView*imageView1 = (UIImageView*)[[self.view viewWithTag:200]viewWithTag:201];
            //            imageView1.frame = CGRectMake(17, 15, 10, 11);
            //
            [((UIImageView *)[titleView viewWithTag:102]) setImage:[UIImage imageNamed:@"all_friends_icon_clicked.png"]];
            [((UIImageView *)[titleView viewWithTag:101]) setImage:[UIImage imageNamed:@"last_talk_friends_icon.png"]];
            [((UIImageView *)[titleView viewWithTag:103]) setImage:[UIImage imageNamed:@"add_friend_icon.png"]];
            //            mytitleLabel.text = @"所有好友";
            self.title =  @"所有好友";
            break;
        case 103:
            self.navigationItem.rightBarButtonItem=nil;
            frame.origin.x = 214;
            bgView.frame =frame;
            //            [self.view viewWithTag:200].hidden = YES;
            //            CGRect frame = self.friendsTableView.frame;
            //            frame.origin.y -= 41;
            //            self.friendsTableView.frame =frame;
            [((UIImageView *)[titleView viewWithTag:103]) setImage:[UIImage imageNamed:@"add_friend_icon_clicked.png"]];
            [((UIImageView *)[titleView viewWithTag:102]) setImage:[UIImage imageNamed:@"all_friends_icon.png"]];
            [((UIImageView *)[titleView viewWithTag:101]) setImage:[UIImage imageNamed:@"last_talk_friends_icon.png"]];
            
            //            mytitleLabel.text = @"收藏的好友";
            self.title = @"收藏的好友";
            if (self.isSearch && self.curFliterStr.length !=0) {
                self.curFliterStr = @"";
                tableViewSearchBar.text=@"";
            }
            break;
        default:
            break;
    }
    if(currentTag ==101)
    {
        NSArray *array = [self.userFetchedResultsController fetchedObjects];
        if(array && array.count>0)
        {
            [latestUserArray removeAllObjects];
            [latestUserArray addObjectsFromArray:array];
        }
        [self.friendsTableView reloadData];
    }
    else if(currentTag == 102)
    {
        //如果好友列表已经有数据后  进行刷新数据
        if ([[self.fetchedResultsController sections] count]>0) {
            
            [self getFriendsUserInfo];
        }
    }
    else if(currentTag == 103)
    {
        [self.friendsTableView reloadData];
        
    }
    //    [[self.view layer] addAnimation:animation forKey:@"animation"];
}
//屏蔽切面切换动画
//- (void)animationDidStart:(CAAnimation *)anim
//{
//    if(currentTag ==101)
//    {
//        NSArray *array = [self.userFetchedResultsController fetchedObjects];
//        if(array && array.count>0)
//        {
//            [latestUserArray removeAllObjects];
//            [latestUserArray addObjectsFromArray:array];
//        }
//        [self.friendsTableView reloadData];
//    }
//    else if(currentTag == 102)
//    {
//        //如果好友列表已经有数据后  进行刷新数据
//        if ([[self.fetchedResultsController sections] count]>0) {
//
//            [self getFriendsUserInfo];
//        }
//    }
//    else if(currentTag == 103)
//    {
//        [self.friendsTableView reloadData];
//
//    }
//}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //    if(currentTag == 102)
    //    {
    //
    //        UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 43, 30)];
    //         [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn@2x.png"] forState:UIControlStateNormal];
    //         [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn_active@2x.png"] forState:UIControlStateSelected];
    //         [navRightButton setTitle:@"添加" forState:UIControlStateNormal];
    //         [[navRightButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
    //         [navRightButton addTarget:self action:@selector(addGroupView) forControlEvents:UIControlEventTouchUpInside];
    //         self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:navRightButton] autorelease];
    //        [navRightButton release];
    //    }
    //    else
    //    {
    //        self.navigationItem.rightBarButtonItem=nil;
    //    }
}

////获取所有的MUC服务
-(void)findService
{
    /*
     <iq id="1HAKC-9" to="mobile.app" type="get">
     <query xmlns="http://jabber.org/protocol/disco#items"></query>
     </iq>
     */
    NSString *fetchID = [[[self appDelegate].xmpp xmppStream]generateUUID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:[XMPPJID jidWithString:kXMPPDomin] elementID:fetchID child:query];
    //    [iq addAttributeWithName:@"from" stringValue:[[[self appDelegate].xmpp xmppStream].myJID bare]];
    [[[self appDelegate].xmpp xmppStream] sendElement:iq];
    
}
//判断MUC服务是否支持MUC协议
//-(void)handleMUCService:(NSNotification*)notification
//{
//    NSArray *mucServices = notification.object;
//    for (NSString * serviceName in mucServices) {
//        NSString *fetchID = [[[self appDelegate].xmpp xmppStream]generateUUID];
//        NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
//        XMPPIQ *iq = [[XMPPIQ alloc]initWithType:@"get" to:[XMPPJID jidWithString:serviceName] elementID:fetchID child:query];
//        [[[self appDelegate].xmpp xmppStream] sendElement:iq];
//        [iq release];
//    }
//
//}


- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    
}
- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    
}




- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    NSLog(@"didFetchBanList-[%@]=",items);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    NSLog(@"didNotFetchBanList-[%@]=",iqError);
    
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    NSLog(@"didFetchMembersList-[%@]=",items);
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    
}

//获取用户性别
-(void)getFriendsUserInfo{
    //关闭 自动刷新
    isCanRefresh = false;
    NSLog(@"读取数组");
    NSMutableArray* userArray = [[NSMutableArray alloc]init];
    for ( id <NSFetchedResultsSectionInfo> sectionInfo in [self.fetchedResultsController sections]) {
        for (UserInfo* userInfo in [sectionInfo objects]) {
            if (!userInfo.userSex || userInfo.userSex.length == 0) {
                [userArray addObject:userInfo];
            }
        }
    }
    NSLog(@"读取数组完成 条数为%d",[userArray count]);
    
    if([userArray count]>0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int i = 0;
            if ([userArray count] >0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIActivityIndicatorView* indicatiorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:indicatiorView] autorelease];
                    //                    [indicatiorView startAnimating];
                    [indicatiorView release];
                    
                });
            }
            
            
            //开异步读取好友VCard
            AppDelegate *del = [self appDelegate];
            for (UserInfo* userInfo in userArray) {
                i++;
                //                NSLog(@"执行到=== %d",i);
                if (!del.xmpp.xmppvCardTempModule) {
                    
                    [del.xmpp newvCard];
                }
                XMPPvCardTemp * xmppvCardTemp =[ del.xmpp.xmppvCardTempModule fetchvCardTempForJID:[XMPPJID jidWithString:userInfo.userJid]];
                NSString*useSex =  [[[xmppvCardTemp elementForName:@"N"] elementForName:@"MIDDLE"] stringValue];
                userInfo.userSex = useSex;
                userInfo.userName =[self getTheJidStr:userInfo.userJid];
                NSLog(@"执行完成=== %d",i);
                //                [userInfo didSave];
            }
            
            NSLog(@"保存数据库");
            [self.managedObjectContext save:nil];
            NSLog(@"保存数据库完成");
            dispatch_async(dispatch_get_main_queue(), ^{
                if([userArray count]>0){
                    [self.friendsTableView reloadData];
                    NSLog(@"刷新tableView");
                    //                UIActivityIndicatorView* indicatiorView  =(UIActivityIndicatorView*)self.navigationItem.rightBarButtonItem;
                    //                [indicatiorView stopAnimating];
                    [userArray release];
                }
                
            });
            
            isCanRefresh = true;
        });
    }
    
    
}

-(NSString*)getTheJidStr:(NSString*)jid
{
    NSArray *arr =[jid componentsSeparatedByString:@"@"];
    NSLog(@"====[%@]",(NSString*)[arr objectAtIndex:0]);
    return (NSString*)[arr objectAtIndex:0];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [tableViewSearchBar resignFirstResponder];
}


#pragma mark -- UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.isSearch = YES;
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.friendsTableView.scrollEnabled = YES;
    return YES;
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    self.curFliterStr=searchText;
    [self fliterTheDataSources:searchText];
    //    if(currentTag == 102)
    //    {
    //        [self fliterTheDataSources:searchText];
    //    }
    //    else if(currentTag == 101)
    //    {
    //        //过滤字符
    //        [friendsSearchArray removeAllObjects];
    //        if (searchText != nil) {
    //
    //            NSArray *userArray = [self.userFetchedResultsController fetchedObjects];
    //            for(UserInfo *userInfo in userArray)
    //            {
    //                if ([userInfo.userName rangeOfString:searchText options:NSRegularExpressionSearch].location != NSNotFound || [userInfo.userJid rangeOfString:searchText options:NSRegularExpressionSearch].location != NSNotFound) {
    //                    if (!friendsSearchArray) {
    //                        friendsSearchArray  = [[NSMutableArray alloc]init];
    //                    }
    //
    //                    [friendsSearchArray addObject:userInfo];
    //
    //                }
    //            }
    //            [self.friendsTableView reloadData];
    //        }
    //    }
    //    else if(currentTag == 103)
    //    {
    //        [friendsSearchArray removeAllObjects];
    //        NSMutableArray *tempUserArray = [[NSMutableArray alloc]initWithCapacity:0];
    //        for(UserInfo *userInfo in [[self fetchedResultsController]fetchedObjects])
    //        {
    //            for (CollectedFriend *collected in collectedArray) {
    //                if([userInfo.userJid isEqualToString:collected.friendId])
    //                {
    //                    [tempUserArray addObject:userInfo];
    //                }
    //            }
    //        }
    //        for(UserInfo *userInfo in tempUserArray)
    //        {
    //            if ([userInfo.userName rangeOfString:searchText options:NSRegularExpressionSearch].location != NSNotFound || [userInfo.userJid rangeOfString:searchText options:NSRegularExpressionSearch].location != NSNotFound) {
    //                if (!friendsSearchArray) {
    //                    friendsSearchArray  = [[NSMutableArray alloc]init];
    //                }
    //
    //                [friendsSearchArray addObject:userInfo];
    //
    //            }
    //        }
    //        [tempUserArray release];
    //        [self.friendsTableView reloadData];
    //    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}


-(void)fliterTheDataSources:(NSString*) searchText{
    //过滤字符
    [friendsSearchArray removeAllObjects];
    if (searchText != nil) {
        for ( id <NSFetchedResultsSectionInfo> sectionInfo in [self.fetchedResultsController sections]) {
            for (UserInfo* userInfo in [sectionInfo objects]) {
                if ([userInfo.userName rangeOfString:searchText options:NSRegularExpressionSearch].location != NSNotFound || [userInfo.userJid rangeOfString:searchText options:NSRegularExpressionSearch].location != NSNotFound) {
                    if (!friendsSearchArray) {
                        friendsSearchArray  = [[NSMutableArray alloc]init];
                    }
                    
                    [friendsSearchArray addObject:userInfo];
                    
                }
            }
        }
        [self.friendsTableView reloadData];
    }
}


-(void)activateSearch{
    XMPPSearchViewController * searchViewController = [[XMPPSearchViewController alloc]initWithNibName:@"XMPPSearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
    [searchViewController release];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    
    self.friendsFetchedResultsController.delegate = nil;
    self.friendsFetchedResultsController = nil;
    
    self.userFetchedResultsController.delegate = nil;
    self.userFetchedResultsController=nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_friendsTableView release];
    AppDelegate *del = [self appDelegate];
    del.xmpp.chatDelegate = nil;
    
    [latestUserArray release];
    [friendsArray release];
    [friendsSearchArray release];
    [collectedArray release];
    latestUserArray=nil;
    friendsArray = nil;
    friendsSearchArray =nil;
    collectedArray = nil;
    
    [super dealloc];
}
- (void)viewDidUnload {
    
    [self setFriendsTableView:nil];
    [super viewDidUnload];
}


-(void)viewWillAppear:(BOOL)animated{
    
    if(currentTag ==101)
    {
        if([self.userFetchedResultsController fetchedObjects].count == 0)
        {
            currentTag =102;
            CGRect frame = bgView.frame;
            frame.origin.x = 107;
            bgView.frame =frame;
            self.title = @"所有好友";
            [((UIImageView *)[titleView viewWithTag:101]) setImage:[UIImage imageNamed:@"last_talk_friends_icon.png"]];
            [((UIImageView *)[titleView viewWithTag:102]) setImage:[UIImage imageNamed:@"all_friends_icon_clicked.png"]];
            [((UIImageView *)[titleView viewWithTag:103]) setImage:[UIImage imageNamed:@"add_friend_icon.png"]];
            
            //            mytitleLabel.text=@"所有好友";
            isFirstLoadUserInfo = true;
            [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(starRefresh) name:@"STARTRREFRESHTABLEVIEW" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(stopRefresh) name:@"STOPRREFRESHTABLEVIEW" object:nil];
            
            //            if ( [[self.fetchedResultsController sections] count]== 0) {
            //
            //                if ([[ShareAppDelegate xmpp] isConnected]) {
            //                    [[ShareAppDelegate xmpp] findFriendsList];
            //                    [SVProgressHUD showWithStatus:@"正在获取好友列表..."];
            //                }else{
            //                    [SVProgressHUD showErrorWithStatus:@"网络问题，稍后重试！" duration:1];
            //                }
            //            }
            [super viewWillAppear:animated];
            [friends removeAllObjects];
            [friendsArray removeAllObjects];
        }
        else
        {
            NSArray *array = [self.userFetchedResultsController fetchedObjects];
            if(array && array.count>0)
            {
                [latestUserArray removeAllObjects];
                [latestUserArray addObjectsFromArray:array];
                [self.friendsTableView reloadData];
            }
            
        }
    }
    else if(currentTag ==102)
    {
        isFirstLoadUserInfo = true;
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(starRefresh) name:@"STARTRREFRESHTABLEVIEW" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(stopRefresh) name:@"STOPRREFRESHTABLEVIEW" object:nil];
        
        if ( [[self.fetchedResultsController sections] count]== 0) {
            
            if ([[ShareAppDelegate xmpp] isConnected]) {
                [[ShareAppDelegate xmpp] findFriendsList];
                [SVProgressHUD showWithStatus:@"正在获取好友列表..."];
            }else{
                [SVProgressHUD showErrorWithStatus:@"网络问题，稍后重试！" duration:1];
            }
        }
        [super viewWillAppear:animated];
        [friends removeAllObjects];
        [friendsArray removeAllObjects];
        
    }
    else if(currentTag == 103)
    {
        for(CollectedFriend *friend in collectedArray)
        {
            for(UserInfo *user in [[self fetchedResultsController]fetchedObjects])
            {
                if([friend.friendId isEqualToString:user.userJid])
                {
                    user.isCollected = [NSNumber numberWithBool:YES];
                    [user save];
                }
            }
        }
        
    }
    
    //[[ShareAppDelegate xmpp] findFriendsList];
}

-(void)stopRefresh{
    isCanRefresh = false;
}
-(void)starRefresh{
    
    isCanRefresh = true;
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    dispatch_async(dispatch_get_main_queue(),  ^{
        [self.friendsTableView reloadData];
        [self getFriendsUserInfo];
    });
}

#pragma mark UITableViewDataSource

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        return 1;
    }
    if(currentTag ==102)
    {
        return [[self.fetchedResultsController sections] count];
    }
    return 1;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        return [friendsSearchArray count];
    }else{
        
        if(currentTag ==101)
        {
            return latestUserArray.count;
        }
        else if(currentTag == 102)
        {
            if (section != self.selectIndex) {
                return 0;
            }
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
        else if(currentTag ==103)
        {
            return collectedArray.count;
        }
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        return 52;
    }
    if(currentTag ==102)
    {
        if (indexPath.section == self.selectIndex) {
            return 52;
        }
    }
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IMFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMFrinedsCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IMFriendsCell" owner:self options:nil] objectAtIndex:0];
        UIImageView *cellBackImage = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"IM_list_bg.png"]];
        cellBackImage.frame = cell.frame;
        cell.backgroundView = cellBackImage;
        [cellBackImage release];
        cell.portraitImageView.image = [UIImage imageNamed:@"chatroom_unknow_outline.jpg"];
        UIImage *numImage = [[UIImage imageNamed:@"com_number_single"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        UIImageView *numView = [[UIImageView alloc]initWithImage:numImage];
        numView.tag = kNumViewTag;
        [cell.contentView addSubview:numView];
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 20, 20)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.font = [UIFont systemFontOfSize:14];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.tag = kNumLabelTag;
        [numView addSubview:numLabel];
        [numLabel release];
        [numView release];
    }
    [self configureCell:cell atIndexPath:indexPath];
    if(currentTag == 102)
    {
        if (indexPath.section == self.selectIndex || (self.isSearch &&self.curFliterStr.length !=0 )){
            cell.hidden = NO;
            
        }else{
            cell.hidden = YES;
        }
    }
    
    return cell;
    
}

-(void)queryAllCollectedFriend:(NSString*)userId
{
    [collectedArray removeAllObjects];
    NSString *url = [kServerURLString stringByAppendingFormat:@"/chat/show/%@",userId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    NSError *error = [request error];
    if(error)
    {
        if([self.friendsFetchedResultsController fetchedObjects].count>0)
        {
            NSArray *myFriendsArray = [self.friendsFetchedResultsController fetchedObjects];
            [collectedArray addObjectsFromArray:myFriendsArray];
        }
    }
    else
    {
        NSString *backStr = [request responseString];
        NSArray *dicArray  =[backStr objectFromJSONString];
        NSMutableArray *array = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
        if(dicArray && dicArray.count >0)
        {
            [array addObjectsFromArray:dicArray];
            if([self.friendsFetchedResultsController fetchedObjects].count>0)
            {
                NSArray *myFriendsArray = [self.friendsFetchedResultsController fetchedObjects];
                for(CollectedFriend *myFriend in myFriendsArray){
                    [myFriend remove];
                }
            }
            for (NSObject *obj in array){
                CollectedFriend *friend  = (CollectedFriend *)[NSEntityDescription insertNewObjectForEntityForName:@"CollectedFriend" inManagedObjectContext:self.managedObjectContext];
                friend.friendId = [obj valueForKey:@"jid"];
                friend.userId = [obj valueForKey:@"userId"];
                [collectedArray addObject:friend];
                //                [friend save];
            }
            [NSManagedObject save];
            
        }
        else
        {
            if([self.friendsFetchedResultsController fetchedObjects].count>0)
            {
                NSArray *myFriendsArray = [self.friendsFetchedResultsController fetchedObjects];
                [collectedArray addObjectsFromArray:myFriendsArray];
            }
        }
        
    }
    
}

-(void)collectEdFriends:(UITapGestureRecognizer*)sender
{
    IMFriendsCell *cell = (IMFriendsCell*)[[sender.view superview] superview];
    //    UserInfo *user = cell.user;
    if([cell.user.userJid isEqualToString:[[self appDelegate].xmpp.xmppStream.myJID bare]])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能收藏自己" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if([cell.user.isCollected intValue]== [[NSNumber numberWithBool:NO]intValue])
    {
        for(CollectedFriend *friend in collectedArray)
        {
            if([friend.friendId isEqualToString:cell.user.userJid])
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"好友已收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                [alertView release];
                return;
            }
        }
        [cell.collectedImageView setImage:[UIImage imageNamed:@"collected_icon_clicked.png"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self addFriendsToServer:cell.user];
        });
    }
    else if([cell.user.isCollected intValue]== [[NSNumber numberWithBool:YES]intValue])
    {
        [cell.collectedImageView setImage:[UIImage imageNamed:@"collected_icon.png"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self deleteFriendOnServer:cell.user];
        });
    }
    else
    {
        for(CollectedFriend *friend in collectedArray)
        {
            if([friend.friendId isEqualToString:cell.user.userJid])
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"好友已收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
        }
        [cell.collectedImageView setImage:[UIImage imageNamed:@"collected_icon_clicked.png"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self addFriendsToServer:cell.user];
        });
    }
}
/*
 chat/delete/userId/jid     get
 /chat/save/:jid/:username/:sex/:status/:userId     post
 /chat/show/:userId  get
 /chat/update/:jid/:status post
 
 */
//删除服务端的好友
-(void)deleteFriendOnServer:(UserInfo *)userInfo
{
    NSString *url = [kServerURLString stringByAppendingFormat:@"/chat/delete/%@/%@",[[[self appDelegate].xmpp xmppStream].myJID bare] ,userInfo.userJid];
    ASIHTTPRequest *request =[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request startSynchronous];
    NSError *error = [request error];
    if(error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除收藏好友失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        NSDictionary *dict = [[request responseString] objectFromJSONString];
        if(![[dict valueForKey:@"result"] isEqualToString:@"success"])
        {
            return ;
        }
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:collectedArray];
        for(CollectedFriend *friend in tmpArray)
        {
            if([friend.userId isEqualToString:[[[self appDelegate].xmpp xmppStream].myJID bare] ] && [friend.friendId isEqualToString:userInfo.userJid])
            {
                [collectedArray removeObject:friend];
                
                userInfo.isCollected = [NSNumber numberWithBool:NO];
                [userInfo save];
                [friend remove];
            }
        }
        //        collectedArray = tmpArray;
        //        [NSManagedObject save];
        //        [tmpArray release];
        if (currentTag == 103)
        {
            [self.friendsTableView reloadData];
        }
    }
    
}
//添加好友到服务端
-(void)addFriendsToServer:(UserInfo*)userInfo
{
    NSString *url = [kServerURLString stringByAppendingString:@"/chat/save"];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setPostValue:userInfo.userJid forKey:@"jid"];
    [request setPostValue:userInfo.userName forKey:@"username"];
    [request setPostValue:userInfo.userSex forKey:@"sex"];
    [request setPostValue:@"" forKey:@"statue"];
    [request setPostValue: [[[self appDelegate].xmpp xmppStream].myJID bare] forKey:@"userId"];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    NSError *error = [request error];
    if(error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏好友失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        NSDictionary *dict = [[request responseString] objectFromJSONString];
        if(![[dict valueForKey:@"result"] isEqualToString:@"success"])
        {
            return ;
        }
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"CollectedFriend" inManagedObjectContext:self.managedObjectContext];
        CollectedFriend *collectedFriend = (CollectedFriend*)newManagedObject;
        [collectedFriend setFriendId:userInfo.userJid];
        [collectedFriend setUserId:[[[self appDelegate].xmpp xmppStream].myJID bare]];
        userInfo.isCollected = [NSNumber numberWithBool:YES];
        [NSManagedObject save];
        [collectedArray addObject:collectedFriend];
        if (currentTag == 103)
        {
            [self.friendsTableView reloadData];
        }
    }
}


- (void)configureCell:(IMFriendsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UserInfo *object = nil;
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        object= [friendsSearchArray objectAtIndex:indexPath.row];
    }else{
        if(currentTag == 101)
        {
            object = [latestUserArray objectAtIndex:indexPath.row];
        }
        else if(currentTag ==102)
        {
            object= [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        else if(currentTag ==103)
        {
            CollectedFriend *collected = [collectedArray objectAtIndex:indexPath.row];
            for(UserInfo *user in [self.fetchedResultsController fetchedObjects])
            {
                if([user.userJid isEqualToString:collected.friendId])
                {
                    object = user;
                    user.isCollected = [NSNumber numberWithBool:YES];
                    [self.managedObjectContext save:nil];
                }
            }
        }
        
    }
    
    if ([object.userSex isEqualToString:@"female"]) {
        if ([object.userStatue length] > 0 ) {
            cell.portraitImageView.image = [UIImage imageNamed:@"chatroom_female_online.jpg"];
        }else{
            cell.portraitImageView.image = [UIImage imageNamed:@"chatroom_female_outline.jpg"];
        }
        
    }else if([object.userSex isEqualToString:@"male"]){
        if ([object.userStatue length] > 0 ) {
            cell.portraitImageView.image = [UIImage imageNamed:@"chatroom_male_online.jpg"];
        }else{
            cell.portraitImageView.image = [UIImage imageNamed:@"chatroom_male_outline.jpg"];
        }
    }else{
        if ([object.userStatue length] > 0 ) {
            cell.portraitImageView.image = [UIImage imageNamed:@"chatroom_unknow_online.jpg"];
        }
    }
    
    
    NSString * stringName =  [[object valueForKey:@"userName"] description];
    NSString * stringJid =  [[object valueForKey:@"userJid"] description];
    if([object.isCollected intValue]== [[NSNumber numberWithBool:NO]intValue])
    {
        [cell.collectedImageView setImage:[UIImage imageNamed:@"collected_icon.png"]];
    }
    else if([object.isCollected intValue] == [[NSNumber numberWithBool:YES]intValue])
    {
        [cell.collectedImageView setImage:[UIImage imageNamed:@"collected_icon_clicked.png"]];
    }
    else
    {
        [cell.collectedImageView setImage:[UIImage imageNamed:@"collected_icon.png"]];
    }
    [cell.collectedImageView setUserInteractionEnabled:YES];
    
    cell.user = object;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectEdFriends:)];
    
    [cell.collectedImageView addGestureRecognizer:gesture];
    [gesture release];
    NSRange range = [stringJid rangeOfString:@"@"];
    NSString * result = [stringJid substringToIndex:range.location];
    
    cell.nameLabel.text = stringName.length > 0 ?stringName:result;
    if (object.userLastMessage!= nil && ![object.userLastMessage isEqualToString:@""]) {
        cell.lastMessageLabel.text = object.userLastMessage;
        //显示 最后信息的发送时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
        cell.lastDateLabel.text=[dateFormatter stringFromDate:object.userLastDate];
        cell.lastDateLabel.hidden = NO;
        [dateFormatter release];
    }else{
        //        cell.lastMessageLabel.text = [[object valueForKey:@"userStatue"] description];
        cell.lastMessageLabel.text=@"";
        cell.lastDateLabel.text = @"";
        cell.lastDateLabel.hidden = YES;
    }
    
    if ( object.userMessageCount != nil && [object.userMessageCount intValue]>0) {
        //计算数字显示需要的frame
        NSString *numStr = [NSString stringWithFormat:@"%d",[object.userMessageCount intValue]];
        CGSize numSize = [numStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
        //因为红圈比文字大一圈
        //红圈显示在联系人头像的右上角
        UIImageView *numView = (UIImageView*)[cell.contentView viewWithTag:kNumViewTag];
        numView.frame = CGRectMake(45-numSize.width, 0, numSize.width+20, numSize.height+10);
        UILabel *numLabel = (UILabel*)[numView viewWithTag:kNumLabelTag];
        numLabel.frame = CGRectMake(10, 3, numSize.width, numSize.height);
        numLabel.text = numStr;
        numView.hidden = NO;
    }else{
        UIImageView *numView = (UIImageView*)[cell.contentView viewWithTag:kNumViewTag];
        numView.hidden = YES;
    }
    //判断UserId是否已经被收藏显示收藏按钮＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        return 0;
    }
    if(currentTag ==102)
    {
        return 41;
    }
    return 0;
}

//-(BOOL)isCollected:(NSString*)jid
//{
//    return [[collectedDictionary allKeys] containsObject:jid];
//}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfo *object = nil;
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    UITableViewCell* cell =  [tableView cellForRowAtIndexPath:indexPath];
    cell.selected  = NO;
    
    if(currentTag == 101 || currentTag == 103)
    {
        if(self.isSearch &&self.curFliterStr.length !=0)
        {
            object =[friendsSearchArray objectAtIndex:indexPath.row];
        }
        else
        {
            if(currentTag == 101)
            {
                object = [latestUserArray objectAtIndex:indexPath.row];
            }
            else if(currentTag == 103)
            {
                CollectedFriend *collected = [collectedArray objectAtIndex:indexPath.row];
                for(UserInfo *user in [self.fetchedResultsController fetchedObjects])
                {
                    if([user.userJid isEqualToString:collected.friendId])
                    {
                        object = user;
                        break;
                    }
                }
            }
        }
        
        //        if(object.userMessageCount != nil)
        //        {
        //            [self appDelegate].totalNum -= [object.userMessageCount intValue];
        //        }
        //        NSLog(@"===============%d",[self appDelegate].totalNum);
        object.userLastMessage = @"";
        object.userMessageCount = @"";
        //        object.userLastDate = nil;
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        chatUserName =object.userJid;
        /*
        if (chatController != nil) {
            chatController = nil;
        }
        chatController = [[XMPPTalkViewController  alloc]initWithNibName:@"XMPPTalkViewController_iphone" bundle:nil];
        chatController.chatWithUser = chatUserName;
        if (object.userName.length >0) {
            chatController.title = object.userName;
        }else{
            NSRange range = [object.userJid rangeOfString:@"@"];
            NSString * result = [object.userJid substringToIndex:range.location];
            chatController.title = result;
        }
        chatController.friendEntity = object;
        [tableViewSearchBar resignFirstResponder];
        chatController.isGroupChat = NO;
        [self.navigationController pushViewController:chatController animated:YES];
        [chatController release];
         */
        
        
        ChatMainViewController* controller=[[ChatMainViewController alloc] init];
        controller.chatWithUser = chatUserName;
        if (object.userName.length >0) {
            controller.title = object.userName;
        }else{
            NSRange range = [object.userJid rangeOfString:@"@"];
            NSString * result = [object.userJid substringToIndex:range.location];
            controller.title = result;
        }
        [tableViewSearchBar resignFirstResponder];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        
        
    }
    else if(currentTag ==102)
    {
        
        if (self.isSearch && self.curFliterStr.length !=0 ) {
            UserInfo *entity =[friendsSearchArray objectAtIndex:indexPath.row];
            NSEntityDescription *entityDescription = [[self.fetchedResultsController fetchRequest] entity];
            NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
            [request setEntity:entityDescription];
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"(userJid = %@ )",entity.userJid];
            [request setPredicate:pred];
            NSError *error = nil;
            NSArray *objects = [context executeFetchRequest:request error:&error];
            if (objects != nil && [objects count] != 0) {
                object = [objects lastObject];
            }
        }else{
            object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        //        if(object.userMessageCount != nil)
        //        {
        //            [self appDelegate].totalNum -= [object.userMessageCount intValue];
        //
        //        }
        object.userLastMessage = @"";
        object.userMessageCount = @"";
        //        object.userLastDate = nil;
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        chatUserName =object.userJid;
        if (!self.isSearch || self.curFliterStr.length ==0 ) {
            NSString *userGroup  = object.userGroup;
            NSArray* section =  [self.fetchedResultsController sections];
            for (int i= 0; i < [section count]; i++) {
                id <NSFetchedResultsSectionInfo> sectionInfo = [section objectAtIndex:i];
                if ([userGroup isEqualToString:[sectionInfo name]]) {
                    //获取到当前选中的
                    [self.friendsTableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                }
            }
        }
        /*
        if (chatController != nil) {
            chatController = nil;
        }
        chatController = [[XMPPTalkViewController  alloc]initWithNibName:@"XMPPTalkViewController_iphone" bundle:nil];
        chatController.chatWithUser = chatUserName;
        if (object.userName.length >0) {
            chatController.title = object.userName;
        }else{
            NSRange range = [object.userJid rangeOfString:@"@"];
            NSString * result = [object.userJid substringToIndex:range.location];
            chatController.title = result;
        }
        chatController.friendEntity = object;
        chatController.isGroupChat = NO;
        [tableViewSearchBar resignFirstResponder];
        [self.navigationController pushViewController:chatController animated:YES];
        [chatController release];
         */
        
        ChatMainViewController* controller=[[ChatMainViewController alloc] init];
        controller.chatWithUser = chatUserName;
        if (object.userName.length >0) {
            controller.title = object.userName;
        }else{
            NSRange range = [object.userJid rangeOfString:@"@"];
            NSString * result = [object.userJid substringToIndex:range.location];
            controller.title = result;
        }
        [tableViewSearchBar resignFirstResponder];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 1020)
    {
        UIControl* myControl = [[[UIControl alloc] initWithFrame:CGRectMake(0.0f, 90.0f, self.view.bounds.size.width, 41)]autorelease];
        [myControl addTarget:self action:@selector(expandGroup:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView* myView = [[[UIImageView alloc] init] autorelease];
        
        myView.backgroundColor = [UIColor colorWithRGBHex:0xFFFFFF];
        
        myView.frame = CGRectMake(0, 0, self.view.frame.size.width, 41);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 41)];
        titleLabel.textColor= [ UIColor colorWithRGBHex:0x535353];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text= @"我的群组";
        [myView addSubview:titleLabel];
        [titleLabel release];
        [myControl addSubview:myView];
        
        //根据组名来获取该组所有的未读信息
        UIImageView* arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_arrow.png"]];
        if(self.isGroupOpen)
        {
            arrowImageView.image  = [self imageTransform:arrowImageView.image rotation:UIImageOrientationRight];
        }
        arrowImageView.tag =201;
        if(currentTag == 101)
        {
            arrowImageView.frame= CGRectMake(300, 15, 10, 11);
        }
        else
        {
            arrowImageView.frame= CGRectMake(17, 15, 10, 11);
        }
        
        [myControl addSubview:arrowImageView];
        [arrowImageView release];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0,  myControl.frame.size.height-0.3,  myControl.frame.size.width, 0.3)];
        lineView.backgroundColor = [UIColor colorWithRGBHex:0x898989];
        [myView addSubview:lineView];
        [lineView release];
        return myControl;
        
    }
    if(currentTag ==102)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        UIControl* myControl = [[[UIControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 41)]autorelease];
        myControl.tag = section;
        [myControl addTarget:self action:@selector(headerIsTapEvent:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView* myView = [[[UIImageView alloc] init] autorelease];
        if (section %2 == 0) {
            myView.backgroundColor = [UIColor colorWithRGBHex:0xF7F7F7];
        }else{
            myView.backgroundColor = [UIColor colorWithRGBHex:0xFFFFFF];
        }
        
        myView.frame = myControl.frame;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 41)];
        titleLabel.textColor= [ UIColor colorWithRGBHex:0x535353];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text= NSLocalizedString([sectionInfo name], nil);
        [myView addSubview:titleLabel];
        [titleLabel release];
        [myControl addSubview:myView];
        
        //根据组名来获取该组所有的未读信息
        int messageCount = 0;
        for ( UserInfo* user  in  [sectionInfo objects]) {
            messageCount +=[user.userMessageCount intValue];
        }
        
        if (messageCount > 0) {
            UIImage *numImage = [[UIImage imageNamed:@"com_number_single"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            UIImageView *numView = [[UIImageView alloc]initWithImage:numImage];
            NSString *numStr = [NSString stringWithFormat:@"%d",messageCount];
            CGSize numSize = [numStr sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 10)];
            numView.frame = CGRectMake(290-numSize.width, 5, numSize.width+20, numSize.height+10);
            
            UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 20, 20)];
            numLabel.backgroundColor = [UIColor clearColor];
            numLabel.font = [UIFont systemFontOfSize:11];
            numLabel.textColor = [UIColor whiteColor];
            numLabel.frame = CGRectMake(10, 3, numSize.width, numSize.height);
            numLabel.text = numStr;
            [numView addSubview:numLabel];
            [myControl addSubview:numView];
            [numLabel release];
            [numView release];
        }
        UIImageView* arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_arrow.png"]];
        arrowImageView.frame= CGRectMake(17, 15, 10, 11);
        [myControl addSubview:arrowImageView];
        if (self.selectIndex == section) {
            arrowImageView.image  = [self imageTransform:arrowImageView.image rotation:UIImageOrientationRight];
        }
        
        [arrowImageView release];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0,  myControl.frame.size.height-0.3,  myControl.frame.size.width, 0.3)];
        lineView.backgroundColor = [UIColor colorWithRGBHex:0x898989];
        [myView addSubview:lineView];
        [lineView release];
        
        return myControl;
    }
    return nil;
    
    
}

-(void)headerIsTapEvent:(id)sender
{
    if (self.isSearch && self.curFliterStr.length !=0) {
        return;
    }
    UIControl* nowConrol = (UIControl*)sender;
    
    NSInteger secIndex = nowConrol.tag;
    
    
    if (!self.isOpen) {
        //没有展开
        self.selectIndex = secIndex;
        self.isOpen = YES;
        [self.friendsTableView reloadData];
        self.oldSelectIndex = self.selectIndex;
    }else if (secIndex != oldSelectIndex) {
        //展开了  然后点击选择的不内容相同
        self.oldSelectIndex = self.selectIndex;
        self.selectIndex = secIndex;
        [self.friendsTableView reloadData];
    }else{
        //展开了   点击的内容相同
        self.isOpen = NO;
        self.oldSelectIndex = -1;
        self.selectIndex = -1;
        [self.friendsTableView reloadData];
    }
}


- (UIImage *)imageTransform:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

- (IBAction)searchBtn:(id)sender {
    [self performSegueWithIdentifier:@"searchUser" sender:self];
}

//取得当前程序的委托
-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    return [[[self appDelegate] xmpp]xmppStream];
}

-(void)didDisConnect{}

-(void)showFriends:(NSXMLElement*)element{
    
    NSArray *items = [element elementsForName:@"item"];
    for (int textIndex=0 ; textIndex < [items count] ; textIndex ++)
    {
        NSXMLElement *item=(NSXMLElement *)[items objectAtIndex:textIndex];
        NSString *group=[[item elementForName:@"group"] stringValue];
        if (group == nil || [group isEqualToString:@""]) {
            group = @"好友列表";
        }
        //先判断jid是否存在
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        
        NSEntityDescription *entityDescription = [[self.fetchedResultsController fetchRequest] entity];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease];
        [request setEntity:entityDescription];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(userJid = %@ )",[[item attributeForName:@"jid"] stringValue],[[item attributeForName:@"group"] stringValue]];
        [request setPredicate:pred];
        NSError *error = nil;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        
        if (objects != nil && [objects count] != 0) {
            /*NSManagedObject *newManagedObject = [objects lastObject];
             [newManagedObject setValue:group forKey:@"userGroup"];
             [newManagedObject setValue:[[item attributeForName:@"name"] stringValue] forKey:@"userName"];
             [newManagedObject setValue:[[item attributeForName:@"subscription"] stringValue] forKey:@"userSubscription"];
             
             if (![context save:&error]) {
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
             abort();
             }*/
        }else{
            NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
            [newManagedObject setValue:group forKey:@"userGroup"];
            [newManagedObject setValue:[[item attributeForName:@"name"] stringValue] forKey:@"userName"];
            [newManagedObject setValue:[[item attributeForName:@"jid"] stringValue] forKey:@"userJid"];
            [newManagedObject setValue:[[item attributeForName:@"subscription"] stringValue] forKey:@"userSubscription"];
            // Save the context.
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    //排序
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"userGroup" ascending:YES] autorelease];
    NSSortDescriptor *sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"userStatue" ascending:NO] autorelease];
    NSSortDescriptor *sortDescriptor2 = [[[NSSortDescriptor alloc] initWithKey:@"userName" ascending:NO] autorelease];
    
    NSArray *sortDescriptors = @[sortDescriptor,sortDescriptor1,sortDescriptor2];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"userGroup" cacheName:@"userGroup"] autorelease];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return _fetchedResultsController;
}

-(NSFetchedResultsController*)friendsFetchedResultsController
{
    if(_friendsFetchedResultsController)
    {
        return _friendsFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CollectedFriend" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId=%@",[[self appDelegate].xmpp.xmppStream.myJID bare]];
    [fetchRequest setPredicate:predicate];
    //    [fetchRequest setFetchBatchSize:20];
    //排序
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"userId" ascending:YES] autorelease];
    //    NSSortDescriptor *sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"userStatue" ascending:NO] autorelease];
    //    NSSortDescriptor *sortDescriptor2 = [[[NSSortDescriptor alloc] initWithKey:@"userName" ascending:NO] autorelease];
    //
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
    aFetchedResultsController.delegate = self;
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    self.friendsFetchedResultsController = aFetchedResultsController;
    return _friendsFetchedResultsController;
}


-(NSFetchedResultsController *)userFetchedResultsController
{
    if (_userFetchedResultsController != nil) {
        return _userFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userLastDate !=nil"];
    [fetchRequest setFetchBatchSize:10];
    [fetchRequest setPredicate:predicate];
    //排序
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"userLastDate" ascending:NO] autorelease];
    //    NSSortDescriptor *sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"userStatue" ascending:NO] autorelease];
    //    NSSortDescriptor *sortDescriptor2 = [[[NSSortDescriptor alloc] initWithKey:@"userName" ascending:NO] autorelease];
    //
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
    aFetchedResultsController.delegate = self;
    
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    self.userFetchedResultsController = aFetchedResultsController;
    return _userFetchedResultsController;
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //    [self.friendsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        return;
    }
    // [self.friendsTableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.isSearch &&self.curFliterStr.length !=0  ) {
        return;
    }
    
    
    
    if(currentTag == 102)
    {
        if (!isCanRefresh) {
            return;
        }
        if (indexPath.section == self.selectIndex ) {
            UITableView *tableView = self.friendsTableView;
            switch(type) {
                case NSFetchedResultsChangeInsert:
                    if (indexPath.section == self.selectIndex ) {
                        [ tableView reloadData];
                    }
                    
                    
                    break;
                case NSFetchedResultsChangeUpdate:
                    
                    if (![tableView cellForRowAtIndexPath:indexPath]) {
                        //                    NSLog(@"===============fff");
                    }else{
                        //                    NSLog(@"===============ddddd");
                        [self configureCell:(IMFriendsCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                        
                    }
                    break;
            }
        }
    }
    else if(currentTag == 101)
    {
        //        if(type != NSFetchedResultsChangeDelete)
        //        {
        [self.friendsTableView reloadData];
        //        }
        
    }
    else if(currentTag == 102)
    {
        
    }
    
    
    //    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
    //  [self.friendsTableView endUpdates];
}

@end
