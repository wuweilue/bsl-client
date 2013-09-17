//
//  FriendMainViewController.m
//  cube-ios
//
//  Created by apple2310 on 13-9-12.
//
//

#import "FriendMainViewController.h"
#import "HeadTabView.h"
#import "RecentTalkView.h"
#import "ContactListView.h"
#import "FaviorContactView.h"
#import "ChatMainViewController.h"
#import "ContactSelectedForGroupViewController.h"
#import "SVProgressHUD.h"
#import "RectangleChat.h"
#import "ChatLogic.h"
@interface FriendMainViewController ()<ContactListViewDelegate,HeadTabViewDelegte,RecentTalkViewDelegate,FaviorContactViewDelegate,UIPopoverControllerDelegate>
-(void)initTabBar;
-(void)filterClick;
-(void)openOrCreateListView:(int)tab;
-(void)addGroupChatClick;
-(void)createRrightNavItem;
@property(nonatomic,retain) UISearchBar*  selectedSearchBar;

@end

@implementation FriendMainViewController
@synthesize selectedSearchBar;

-(id)init{
    self=[super init];
    if(self){
        self.title=@"即时通讯";
    }
    
    
    return  self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    CGRect rect=self.view.frame;
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        rect.size.width =CGRectGetHeight(self.view.frame)/2+2;
        rect.size.height= CGRectGetWidth(self.view.frame)-self.navigationController.navigationBar.bounds.size.height;        
    }
    else{
        rect.size.height-=44.0f;
    }
    self.view.frame=rect;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initTabBar];
    [self openOrCreateListView:1];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.selectedSearchBar=nil;
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(tabView.selectedIndex==0){
        
    }
    else if(tabView.selectedIndex==1){
        [contactListView loadData];
    }
    else{
    }
}

#pragma mark method


-(void)createRrightNavItem{
    UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 43, 30)];
    //navRightButton.style = UIBarButtonItemStyleBordered;
    [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn@2x.png"] forState:UIControlStateNormal];
    [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn_active@2x.png"] forState:UIControlStateSelected];
    if(tabView.selectedIndex==2){
        [navRightButton setTitle:(faviorContactView.editing?@"取消":@"编辑") forState:UIControlStateNormal];
    }
    else{
        [navRightButton setTitle:@"群聊" forState:UIControlStateNormal];

    }
    [[navRightButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
    [navRightButton addTarget:self action:@selector(addGroupChatClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:navRightButton] autorelease];
    [navRightButton release];

}

-(void)initTabBar{
    tabView=[[HeadTabView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.0f)];
    tabView.delegate=self;
    [self.view addSubview:tabView];
    [tabView release];
    
    [tabView setTabNameArray:[NSArray arrayWithObjects:@"最近聊天",@"好友列表",@"好友收藏", nil]];
    tabView.selectedIndex=1;
}

-(void)openOrCreateListView:(int)tab{
    recentTalkView.hidden=YES;
    contactListView.hidden=YES;
    faviorContactView.hidden=YES;
    [self filterClick];
    if(tab==0){
        if(recentTalkView==nil){
            recentTalkView=[[RecentTalkView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(tabView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(tabView.frame)) style:UITableViewStylePlain];
            recentTalkView.rectentDelegate=self;
            [self.view addSubview:recentTalkView];
            [recentTalkView release];
        }
        recentTalkView.hidden=NO;
    }
    else if(tab==1){
        if(contactListView==nil){
            contactListView=[[ContactListView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(tabView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(tabView.frame))];
            contactListView.delegate=self;
            [self.view addSubview:contactListView];
            [contactListView release];
            
        }
        contactListView.hidden=NO;
        [contactListView loadData];
    }
    else if(tab==2){
        if(faviorContactView==nil){
            faviorContactView=[[FaviorContactView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(tabView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(tabView.frame)) style:UITableViewStylePlain];
            faviorContactView.faviorDelegate=self;
            [self.view addSubview:faviorContactView];
            [faviorContactView release];
        }
        faviorContactView.hidden=NO;
    }
    
    [self createRrightNavItem];

}

-(void)filterClick{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.selectedSearchBar setShowsCancelButton:NO animated:YES];
    [self.selectedSearchBar resignFirstResponder];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        fliterBg.alpha=0.0f;
    } completion:^(BOOL finish){
        [fliterBg removeFromSuperview];
        fliterBg=nil;
        [self.selectedSearchBar resignFirstResponder];
        self.selectedSearchBar=nil;
    }];
}

-(void)addGroupChatClick{
    
    if(tabView.selectedIndex==2){
        
        [faviorContactView setEditing:!faviorContactView.editing animated:YES];
        [faviorContactView layoutTableCell];
        [self createRrightNavItem];
        return;
    }
    
    AppDelegate* appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![[appDelegate xmpp] isConnected]) {
        [SVProgressHUD showErrorWithStatus:@"即时通讯没有连接！"];
        return;
    }

    ContactSelectedForGroupViewController* controller=[[ContactSelectedForGroupViewController alloc] init];
    controller.dicts=[contactListView friendsList];
    
    
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        [popover release];
        popover=nil;
        popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        popover.delegate=self;        
        popover.popoverContentSize=self.view.frame.size;
        [popover presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    }
    else{
        
        [self presentViewController:controller animated:YES completion:^{
            
        }];
        
    }
    
    [controller release];
}

#pragma mark imagepicker delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;
    return YES;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;
    
}


#pragma mark  headtab delegate

-(void)tabDidSelected:(HeadTabView*)tabView index:(int)index{
    [self openOrCreateListView:index];
}

#pragma mark contactlist delegate

-(void)contactListDidTouch:(ContactListView*)contactList{
    [self filterClick];
}

-(void)contactListDidSearchShouldBeginEditing:(ContactListView*)contactList searchBar:(UISearchBar*)searchBar{
    self.selectedSearchBar=searchBar;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.selectedSearchBar setShowsCancelButton:YES animated:YES];
    if(fliterBg==nil){
        fliterBg=[UIButton buttonWithType:UIButtonTypeCustom];
        [fliterBg addTarget:self action:@selector(filterClick) forControlEvents:UIControlEventTouchUpInside];
        fliterBg.backgroundColor=[UIColor blackColor];
        fliterBg.frame=CGRectMake(0.0f, tabView.frame.size.height+self.selectedSearchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:fliterBg];
    }
    fliterBg.alpha=0.0f;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        fliterBg.alpha=0.6f;
    } completion:^(BOOL finish){
    }];
}

-(void)contactListSearchBarSearchButtonClicked:(ContactListView*)contactList searchBar:(UISearchBar*)searchBar{
    [self filterClick];

}

-(void)contactListSearchBarCancelButtonClicked:(ContactListView*)contactList searchBar:(UISearchBar*)searchBar{
    [self filterClick];

}

-(void)contactListSearchBarTextChanged:(ContactListView*)contactList searchBar:(UISearchBar*)searchBar{

    fliterBg.hidden=([searchBar.text length]>0);

}



-(void)contactListDidSelected:(ContactListView*)contactList userInfo:(UserInfo*)userInfo{
    AppDelegate* appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![[appDelegate xmpp] isConnected]) {
        [SVProgressHUD showErrorWithStatus:@"即时通讯没有连接！"];
        return;
    }

    ChatMainViewController* controller=[[ChatMainViewController alloc] init];
    controller.chatWithUser=userInfo.userJid;
    controller.chatName=[userInfo name];
    controller.title=[userInfo name];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark rectangle talk delegate

-(void)rectentTalkViewDidSelected:(RecentTalkView *)recentTalkView rectangleChat:(RectangleChat *)rectangleChat{
    AppDelegate* appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![[appDelegate xmpp] isConnected]) {
        [SVProgressHUD showErrorWithStatus:@"即时通讯没有连接！"];
        return;
    }
    ChatMainViewController* controller=[[ChatMainViewController alloc] init];
    controller.chatWithUser=rectangleChat.receiverJid;
    controller.chatName=rectangleChat.name;
    controller.title=[rectangleChat name];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

}

#pragma mark favior view delegate

-(void)faviorContactViewDidSelected:(FaviorContactView *)recentTalkView userInfo:(UserInfo *)userInfo{
    AppDelegate* appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![[appDelegate xmpp] isConnected]) {
        [SVProgressHUD showErrorWithStatus:@"即时通讯没有连接！"];
        return;
    }
    
    
    
    ChatMainViewController* controller=[[ChatMainViewController alloc] init];
    controller.chatWithUser=userInfo.userJid;
    controller.chatName=[userInfo name];

    controller.title=[userInfo name];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

}

-(void)faviorContactViewDidDelete:(FaviorContactView*)recentTalkView userInfo:(UserInfo*)userInfo{
    ChatLogic* logic=[[ChatLogic alloc] init];
    [logic removeFaviorInContacts:userInfo.userJid];
    [logic release];
}
@end
