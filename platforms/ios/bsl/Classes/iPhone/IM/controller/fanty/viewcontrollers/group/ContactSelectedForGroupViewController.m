//
//  ContactSelectedForGroupViewController.m
//  cube-ios
//
//  Created by 肖昶 on 13-9-15.
//
//

#import "ContactSelectedForGroupViewController.h"
#import "UserInfo.h"
#import "TouchScroller.h"
#import "ImageUploaded.h"
#import "ContactCheckBoxCell.h"
#import "CustomNavigationBar.h"
#import "InputAlertView.h"
#import "SVProgressHUD.h"
#import "RoomService.h"
#import "XMPPRoom.h"
#import "RectangleChat.h"
@interface ContactSelectedForGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ImageUploadedDelegate,UIAlertViewDelegate>

-(void)filterClick;
-(void)backClick;
-(void)loadShowData;
-(void)createGroupAction:(NSString*)groupName;
@end

@implementation ContactSelectedForGroupViewController
@synthesize dicts;
- (id)init{
    self = [super init];
    if (self) {
        self.title=@"选择联系人";
        selectedUserInfos=[[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect rect=self.view.frame;
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        rect.size.width =CGRectGetHeight(self.view.frame)/2+2;
        rect.size.height= CGRectGetWidth(self.view.frame)-44.0f-self.navigationController.navigationBar.bounds.size.height;
    }
    else{

    }
    self.view.frame=rect;
    self.view.backgroundColor=[UIColor whiteColor];


    UINavigationItem* navItem=[[UINavigationItem alloc] initWithTitle:self.title];

    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        navItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backClick)];
        bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    }
    else{
        bar=[[CustomNavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];

        UIButton* backButton = [((CustomNavigationBar*)bar) backButtonWith:[UIImage imageNamed:@"nav_back@2x.png"] highlight:nil leftCapWidth:14.0];
        [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    }

    [bar pushNavigationItem:navItem animated:NO];
    
    [self.view addSubview:bar];
    
    rect=self.view.bounds;
    rect.origin.y=CGRectGetMaxY(bar.frame);
    rect.size.height-=rect.origin.y;
    
    tableView=[[TouchTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tableView];

    searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 44.0f)];
    searchBar.tintColor=[UIColor grayColor];
    searchBar.placeholder=@"输入关键字搜索";
    searchBar.delegate=self;
    tableView.tableHeaderView=searchBar;

    
    imageUploaded=[[ImageUploaded alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.0f)];
    imageUploaded.delegate=self;
    [self.view addSubview:imageUploaded];

    [self loadShowData];

}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    searchBar=nil;
    

    sortedKeys=nil;
    showDicts=nil;
    selectedUserInfos=nil;
    
}


#pragma mark method

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)filterClick{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect=bar.frame;
        rect.origin.y=0.0f;
        bar.frame=rect;
        
        rect=self.view.bounds;
        rect.origin.y=CGRectGetMaxY(bar.frame);
        rect.size.height=self.view.frame.size.height- rect.origin.y-imageUploaded.frame.size.height;
        tableView.frame=rect;
        
        rect=imageUploaded.frame;
        rect.origin.y=CGRectGetMaxY(tableView.frame);
        imageUploaded.frame=rect;

        fliterBg.alpha=0.0f;
    } completion:^(BOOL finish){
        [fliterBg removeFromSuperview];
        fliterBg=nil;
        [searchBar resignFirstResponder];
        
    }];
}

-(void)loadShowData{
    NSString* searchText=searchBar.text;
    
    if([searchText length]<1){
        sortedKeys = [dicts allKeys];
        showDicts=dicts;

    }
    else{
        NSMutableDictionary* newDict=[[NSMutableDictionary alloc] initWithCapacity:1];
        NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:3];
        [dicts enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL* stop){
            if([key length]>0){
                NSArray* _array=obj;
                for(UserInfo* model in _array){
                    if([[[model name] lowercaseString] rangeOfString:searchText].length>0){
                        [array addObject:model];
                    }
                }
            }
        }];
        sortedKeys=[NSArray arrayWithObjects:@"搜索结果", nil];
        [newDict setObject:array forKey:@"搜索结果"];
        showDicts=newDict;
        
    }
    
    fliterBg.hidden=([searchText length]>0);
    
    tableView.tableHeaderView=searchBar;
    CGRect rect=self.view.bounds;
    rect.origin.y=CGRectGetMaxY(bar.frame);
    rect.size.height=self.view.frame.size.height- rect.origin.y-imageUploaded.frame.size.height;
    tableView.frame=rect;

    rect=imageUploaded.frame;
    rect.origin.y=CGRectGetMaxY(tableView.frame);
    imageUploaded.frame=rect;
    [tableView reloadData];

}

-(void)createGroupAction:(NSString*)groupName{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    RoomService *roomS =[[RoomService alloc]init];
    roomS.roomName =groupName;
    roomS.roomDidCreateBlock =^(XMPPRoom* room){
        
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appDelegate.xmpp newRectangleMessage:roomS.roomID name:groupName content:@"我新建了一个群组" contentType:RectangleChatContentTypeMessage isGroup:YES];

        
        //先向自己发送一个邀请
        NSString* name=[[appDelegate.xmpp.xmppStream myJID] bare];
        
        int index=[name rangeOfString:@"@"].location;
        name= [name substringToIndex:index];

        
        [appDelegate.xmpp addGroupRoomMember:roomS.roomID memberId:[[appDelegate.xmpp.xmppStream myJID] bare] sex:[[NSUserDefaults standardUserDefaults] valueForKey:@"sex"] status:@"在线" username:name];
        
        [room inviteUser:[appDelegate.xmpp.xmppStream myJID] withMessage:@"我新建了一个群组"];        
        
        //然后向选择的朋友发送邀请
        for(UserInfo* info in selectedUserInfos){
            [appDelegate.xmpp addGroupRoomMember:roomS.roomID memberId:info.userJid sex:info.userSex status:info.userStatue username:[info name]];
            
            [room inviteUser:[XMPPJID jidWithString:info.userJid] withMessage:@"我新建了一个群组"];

        }
        
        [appDelegate.xmpp saveContext];
        
        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
    };
    [roomS initRoomServce];

}

#pragma mark  tableview delegate

- (void)tableView:(UIScrollView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event{
    [searchBar resignFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [searchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [sortedKeys count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if([searchBar.text length]<1)
        return sortedKeys;
    else
        return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor whiteColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString* key=[sortedKeys objectAtIndex:section];
    UIImageView* view =[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 40.0f)];
    view.image=[UIImage imageNamed:@"table_header.png"];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, view.frame.size.width-20.0f, 24.0f)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.shadowColor=[UIColor blackColor];
    titleLabel.shadowOffset=CGSizeMake(0.0f, 0.5f);
    titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text=key;
    [view addSubview:titleLabel];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ContactCheckBoxCell height];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString* key=[sortedKeys objectAtIndex:section];
    
    NSArray* array=[showDicts objectForKey:key];
    
    return [array count];
}

-(UITableViewCell*)tableView:(UITableView *)__tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactCheckBoxCell *cell = (ContactCheckBoxCell*)[__tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[ContactCheckBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString* key=[sortedKeys objectAtIndex:[indexPath section]];
    
    NSArray* array=[showDicts objectForKey:key];

    UserInfo* user=[array objectAtIndex:[indexPath row]];
    [cell headerUrl:@"" nickname:[user name]];
    [cell setChecked:[selectedUserInfos containsObject:user] animate:NO];
    return cell;
    
}

-(void)tableView:(UITableView *)__tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [__tableView deselectRowAtIndexPath:indexPath animated:YES];
    [searchBar resignFirstResponder];

    NSString* key=[sortedKeys objectAtIndex:[indexPath section]];
    
    NSArray* array=[showDicts objectForKey:key];

    UserInfo* user=[array objectAtIndex:[indexPath row]];

    
    ContactCheckBoxCell* cell=(ContactCheckBoxCell*)[__tableView cellForRowAtIndexPath:indexPath];
    if([selectedUserInfos containsObject:user]){
        [cell setChecked:NO animate:YES];
        [selectedUserInfos removeObject:user];
        [imageUploaded removeImage:user.userJid];
    }
    else{
        [cell setChecked:YES animate:YES];
        [selectedUserInfos addObject:user];
        
        [imageUploaded addNewImage:user.userJid url:@""];
    }
}

#pragma mark searchbar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)_searchBar{
    

    [searchBar setShowsCancelButton:YES animated:YES];
    if(fliterBg==nil){
        fliterBg=[UIButton buttonWithType:UIButtonTypeCustom];
        [fliterBg addTarget:self action:@selector(filterClick) forControlEvents:UIControlEventTouchUpInside];
        fliterBg.backgroundColor=[UIColor blackColor];
        fliterBg.frame=CGRectMake(0.0f, searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:fliterBg];
    }
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
    
        CGRect rect=bar.frame;
        rect.origin.y=-44.0f;
        bar.frame=rect;
        
        rect=self.view.bounds;
        rect.origin.y=CGRectGetMaxY(bar.frame);
        rect.size.height=self.view.frame.size.height- rect.origin.y-imageUploaded.frame.size.height;
        tableView.frame=rect;
        
        rect=imageUploaded.frame;
        rect.origin.y=CGRectGetMaxY(tableView.frame);
        imageUploaded.frame=rect;

        
    } completion:^(BOOL finish){
    }];
    fliterBg.alpha=0.0f;
    [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationOptionCurveLinear animations:^{
        
        fliterBg.alpha=0.7f;
    } completion:^(BOOL finish){
    }];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText{
    [self loadShowData];
    [searchBar becomeFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    [self filterClick];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    searchBar.text=nil;
    [tableView reloadData];
    [self filterClick];
}


#pragma mark imageupload delegate

-(void)didConfirmImageUploaded:(ImageUploaded*)imageUploaded{
    InputAlertView* alertView=[[InputAlertView alloc] init];
    alertView.callback=self;
    [alertView showTitle:@"请为你的群组起个名字"];
    [alertView showTextField];
    [alertView addButtonWithTitle:@"取消"];
    [alertView addButtonWithTitle:@"确定"];
    [alertView show];
}

#pragma mark alertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        InputAlertView* alert=(InputAlertView*)alertView;
        [self createGroupAction:[alert textFieldText]];
    }
}

@end
