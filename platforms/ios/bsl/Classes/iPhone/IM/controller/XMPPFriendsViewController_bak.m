//
//  XMPPFriendsViewController.m
//  cube-ios
//
//  Created by 东 on 13-3-5.
//
//

#import "XMPPFriendsViewController.h"
#import "UIColor+expanded.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPSqlManager.h"
#import "SVProgressHUD.h"
#import "XMPPvCardTempModule.h"
#import "MessageRecord.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "IMFriendsCell.h"

#import "ChatMainViewController.h"

#define kNumViewTag 100
#define kNumLabelTag 101

@interface XMPPFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,ChatDelegate,NSFetchedResultsControllerDelegate,UISearchBarDelegate>{
    NSMutableArray * friendsArray;
    NSMutableArray * friendsSearchArray;
    NSMutableDictionary *friends;
    NSString * chatUserName;
    BOOL isFirstLoadUserInfo;
    
    UISearchBar* tableViewSearchBar;
    BOOL isCanRefresh;
}
@property (strong, nonatomic) IBOutlet UITableView *friendsTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign)BOOL isOpen;
@property (assign)BOOL isSearch;
@property (assign)BOOL isChange;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,assign)NSInteger oldSelectIndex;
@property (nonatomic,strong)NSString* curFliterStr;

@end

@implementation XMPPFriendsViewController
@synthesize fetchedResultsController=_fetchedResultsController;
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

- (void)viewDidLoad{
    [super viewDidLoad];
    friendsArray = [[NSMutableArray alloc]init];
    friendsSearchArray = [[NSMutableArray alloc]init];
    _friendsTableView.delegate = self;
    _friendsTableView.dataSource = self;
    
    AppDelegate *del = [self appDelegate];
    del.xmpp.chatDelegate = self;
    
    self.title = @"即时通讯";
    _friendsTableView.separatorStyle = NO;
    
    self.selectIndex = -1;
    
    //添加当前好友搜索
    
    UIView *searchBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? self.view.frame.size.width : 520 , 40)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:searchBarView.frame];
    imageView.image=[UIImage imageNamed:@"bg_search_lightgray"];
    [searchBarView addSubview:imageView];
    
    tableViewSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 0, UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone ? 310 : 510, 40)];
    [[tableViewSearchBar.subviews objectAtIndex:0]removeFromSuperview];
    tableViewSearchBar.delegate = self;
    tableViewSearchBar.placeholder = @"搜索好友";
    [searchBarView addSubview:tableViewSearchBar];
    
    [self.view addSubview:searchBarView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ( [[self.fetchedResultsController sections] count]== 0) {
        if ([[ShareAppDelegate xmpp] isConnected]) {
            [[ShareAppDelegate xmpp] findFriendsList];
            [SVProgressHUD showWithStatus:@"正在获取好友列表..."];
        }else{
            [SVProgressHUD showErrorWithStatus:@"即时通讯没有连接！" ];
        }
    }else if(!isFirstLoadUserInfo){
        if ([[ShareAppDelegate xmpp] isConnected]) {
            [[ShareAppDelegate xmpp] findFriendsList];
            [SVProgressHUD showWithStatus:@"正在获取好友列表..."];
        }else{
            [SVProgressHUD showErrorWithStatus:@"即时通讯没有连接！"] ;
        }
    }
    isFirstLoadUserInfo = true;
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(starRefresh) name:@"STARTRREFRESHTABLEVIEW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(stopRefresh) name:@"STOPRREFRESHTABLEVIEW" object:nil];
    [friends removeAllObjects];
    [friendsArray removeAllObjects];
    [friendsSearchArray removeAllObjects];
    //[[ShareAppDelegate xmpp] findFriendsList];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.friendsTableView=nil;
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.curFliterStr=nil;
    AppDelegate *del = [self appDelegate];
    del.xmpp.chatDelegate = nil;
    
    
    friendsArray=nil;
    friendsSearchArray=nil;
    friends=nil;
    chatUserName=nil;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    self.fetchedResultsController.delegate = nil;
    AppDelegate *del = [self appDelegate];
    del.xmpp.chatDelegate = nil;
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
            
            //开异步读取好友VCard
            AppDelegate *del = [self appDelegate];
            for (UserInfo* userInfo in userArray) {
                if(self.view.superview==nil)break;
                if (!del.xmpp.xmppvCardTempModule) {
                    [del.xmpp newvCard];
                }
                XMPPvCardTemp * xmppvCardTemp =[ del.xmpp.xmppvCardTempModule fetchvCardTempForJID:[XMPPJID jidWithString:userInfo.userJid]];
                NSString*useSex =  [[[xmppvCardTemp elementForName:@"N"] elementForName:@"MIDDLE"] stringValue];
                if([useSex length]>0)
                    userInfo.userSex = useSex;
                
            }
            if(self.view.superview!=nil)
                [self.managedObjectContext save:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([userArray count]>0){
                    if(self.view.superview!=nil)
                        [self.friendsTableView reloadData];
                }
            });
            
            isCanRefresh = true;
        });
    }
    else{
    }
    
    
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
    return [[self.fetchedResultsController sections] count];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        return [friendsSearchArray count];
    }else{
        if (section != self.selectIndex) {
            return 0;
        }
        
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        return 52;
    }
    if (indexPath.section == self.selectIndex) {
        return 52;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IMFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMFrinedsCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IMFriendsCell" owner:self options:nil] objectAtIndex:0];
        if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
            cell.nameLabel.frame = CGRectMake(60, 10, 139+200, 21);
        }
        UIImageView *cellBackImage = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"IM_list_bg.png"]];
        cellBackImage.frame = cell.frame;
        cell.backgroundView = cellBackImage;
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
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    if (indexPath.section == self.selectIndex || (self.isSearch &&self.curFliterStr.length !=0 )){
        cell.hidden = NO;
        
    }else{
        cell.hidden = YES;
    }
    return cell;
}
- (void)configureCell:(IMFriendsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UserInfo *object = nil;
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        object= [friendsSearchArray objectAtIndex:indexPath.row];
    }else{
        object= [self.fetchedResultsController objectAtIndexPath:indexPath];
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
    }else{
        cell.lastMessageLabel.text = [[object valueForKey:@"userStatue"] description];
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
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        return 0;
    }
    return 41;
}


#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![[self xmppStream]isConnected]) {
        [SVProgressHUD showErrorWithStatus:@"即时通讯没有连接！"] ;
        return;
    }
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    UITableViewCell* cell =  [tableView cellForRowAtIndexPath:indexPath];
    cell.selected  = NO;
    UserInfo *object = nil;
    if (self.isSearch && self.curFliterStr.length !=0 ) {
        UserInfo *entity =[friendsSearchArray objectAtIndex:indexPath.row];
        NSEntityDescription *entityDescription = [[self.fetchedResultsController fetchRequest] entity];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
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
    
    object.userLastMessage = @"";
    object.userMessageCount =@"0";
    object.userLastDate = nil;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [MessageRecord createModuleBadge:@"com.foss.chat" num: [XMPPSqlManager getMessageCount]];
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
    
    /* remove  by fanty
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
    controller.chatName=controller.title;
    
    [tableViewSearchBar resignFirstResponder];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    UIControl* myControl = [[UIControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 41)];
    myControl.tag = section;
    [myControl addTarget:self action:@selector(headerIsTapEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* myView = [[UIImageView alloc] init];
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
    [myControl addSubview:myView];
    
    //根据组名来获取该组所有的未读信息
    int messageCount = 0;
    for ( UserInfo* user  in  [sectionInfo objects]) {
        if ([user.userMessageCount intValue] >0) {
            messageCount = messageCount + [user.userMessageCount intValue]; ;
        }
        
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
    }
    UIImageView* arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_arrow.png"]];
    arrowImageView.frame= CGRectMake(17, 15, 10, 11);
    [myControl addSubview:arrowImageView];
    if (self.selectIndex == section) {
        arrowImageView.image  = [self imageTransform:arrowImageView.image rotation:UIImageOrientationRight];
    }
    
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0,  myControl.frame.size.height-0.3,  myControl.frame.size.width, 0.3)];
    lineView.backgroundColor = [UIColor colorWithRGBHex:0x898989];
    [myView addSubview:lineView];
    
    return myControl;
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
    UIGraphicsEndImageContext();
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
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    //排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userGroup" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"userStatue" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"userName" ascending:NO];
    
    NSArray *sortDescriptors = @[sortDescriptor,sortDescriptor1,sortDescriptor2];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"userGroup" cacheName:@"userGroup"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return _fetchedResultsController;
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
                    
                }else{
                    [self configureCell:(IMFriendsCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                    
                }
                break;
        }
    }
    
    //    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
    //  [self.friendsTableView endUpdates];
}

@end
