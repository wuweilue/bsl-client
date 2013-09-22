//
//  GroupMemberManagerViewController.m
//  cube-ios
//
//  Created by 肖昶 on 13-9-18.
//
//

#import "GroupMemberManagerViewController.h"
#import "GroupPanel.h"
#import "GroupRoomUserEntity.h"
#import "InputAlertView.h"
#import "ContactSelectedForGroupViewController.h"


NSInteger groupMemberContactListViewSort(id obj1, id obj2,void* context){
    UserInfo* info=(UserInfo*)obj1;
    if([info.userStatue length]>0)
        return (NSComparisonResult)NSOrderedAscending;
    else
        return (NSComparisonResult)NSOrderedDescending;
};


@interface GroupMemberManagerViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UIAlertViewDelegate,GroupPanelDelegate,UIPopoverControllerDelegate,ContactSelectedForGroupViewControllerDelegate>
-(void)initGroupPanel;
-(void)loadLocalData;
-(void)initQuitButton;
@end

@implementation GroupMemberManagerViewController
@synthesize delegate;
-(id)init{
    self=[super init];
    if(self){
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ChatBackground_00.jpg"]];
    self.title=self.chatName;

    CGRect rect=self.view.frame;
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        rect.size.width =CGRectGetHeight(self.view.frame)/2+2;
        rect.size.height= CGRectGetWidth(self.view.frame)-self.navigationController.navigationBar.bounds.size.height;
    }
    else{
        rect.size.height-=44.0f;
    }
    self.view.frame=rect;

    [self loadLocalData];
    
    tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    list=nil;
    tableView=nil;
    groupPanel=nil;
    quitButton=nil;
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];

    fetchedResultsController.delegate=nil;
    self.messageId=nil;
    self.chatName=nil;
}

#pragma method

-(void)loadLocalData{
    list=[[NSMutableArray alloc] initWithCapacity:2];
    
    managedObjectContext = [ShareAppDelegate xmpp].managedObjectContext;
    
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roomId = %@",self.messageId];
    NSFetchRequest *fetechRequest = [NSFetchRequest fetchRequestWithEntityName:@"GroupRoomUserEntity"];
    [fetechRequest setPredicate:predicate];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"jid" ascending:YES];
    [fetechRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetechRequest managedObjectContext:appDelegate.xmpp.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:NULL];
    
    //把消息都保存在messageArray中
    NSArray *contentArray = [fetchedResultsController fetchedObjects];
    
    for(id obj in contentArray){
        [list addObject:obj];
    }
}

-(void)initGroupPanel{
    if(groupPanel==nil){
        groupPanel=[[GroupPanel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, tableView.frame.size.width-20.0f, 0.0f)];
        groupPanel.delegate=self;
        [groupPanel setArray:list];

    }
}

-(void)initQuitButton{
    if(quitButton==nil){
        quitButton=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* img=[UIImage imageNamed:@"btn_red.png"];
        [quitButton setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width*0.5f topCapHeight:img.size.height*0.5f] forState:UIControlStateNormal];
        [quitButton setTitle:@"退出群组" forState:UIControlStateNormal];
        quitButton.frame=CGRectMake(10.0f, 0.0f, tableView.frame.size.width-20.0f, 44.0f);
    }
}

#pragma mark table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==0){
        [self initGroupPanel];
        return groupPanel.frame.size.height+20.0f;
    }
    else if([indexPath section]==1){
    }
    else if([indexPath section]==2){
        [self initQuitButton];        
    }

    return 44.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==0)
        cell.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
    else if([indexPath section]==2){
        cell.backgroundColor=[UIColor clearColor];
        cell.backgroundView=nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellName=@"cell";
    if([indexPath section]==1)
        cellName=@"cell1";
    else if([indexPath section]==2)
        cellName=@"cell2";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] ;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
    if([indexPath section]==0){
        [self initGroupPanel];
        [cell addSubview:groupPanel];
    }
    else if([indexPath section]==1){
        cell.textLabel.text=[NSString stringWithFormat:@"群组名：%@",self.chatName];
    }
    else if([indexPath section]==2){
        [self initQuitButton];
        [cell addSubview:quitButton];
    }
    
    cell.accessoryType=([indexPath section]==1?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone);
    cell.selectionStyle=([indexPath section]==1?UITableViewCellSelectionStyleBlue:UITableViewCellSelectionStyleNone);

    return cell;
    
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if([indexPath section]==1){
        InputAlertView* alertView=[[InputAlertView alloc] init];
        alertView.callback=self;
        [alertView showTitle:@"请起个你要修改的群组名"];
        [alertView showTextField];
        [alertView addButtonWithTitle:@"取消"];
        [alertView addButtonWithTitle:@"确定"];
        [alertView show];
    }
}

#pragma mark alertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        InputAlertView* alert=(InputAlertView*)alertView;
        if([[alert textFieldText] length]>0){
            self.chatName=[alert textFieldText];
            self.title=self.chatName;
            
            
            
            
            
            if([self.delegate respondsToSelector:@selector(updateMemberName:memberName:)])
                [self.delegate updateMemberName:self memberName:self.chatName];
            [tableView reloadData];
        }
    }
}


#pragma mark  fetchedresultscontroller  delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    if(![anObject isKindOfClass:[GroupRoomUserEntity class]])return;
    if (type==NSFetchedResultsChangeInsert) {
        [list addObject:anObject];
        [groupPanel setArray:list];
        [tableView reloadData];
    }else if (type==NSFetchedResultsChangeUpdate) {
    }
    else if(type==NSFetchedResultsChangeDelete){
    }
    else if(type==NSFetchedResultsChangeMove){
        
    }
}

#pragma mark grouppanel  delegate

-(void)addGroupClick:(GroupPanel*)groupPanel{
    ContactSelectedForGroupViewController* controller=[[ContactSelectedForGroupViewController alloc] init];
    controller.existsGroupJid=self.messageId;
    controller.groupName=self.chatName;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetechRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
        
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userGroup" ascending:YES];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"userStatue" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"userName" ascending:NO];
    
    NSArray *sortDescriptors = @[sortDescriptor,sortDescriptor1,sortDescriptor2];
    [fetechRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController* fetchController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetechRequest managedObjectContext:appDelegate.xmpp.managedObjectContext sectionNameKeyPath:@"userGroup" cacheName:@"userGroup"];
    [fetchController performFetch:NULL];
    

    NSMutableDictionary* friendsListDict=[[NSMutableDictionary alloc] initWithCapacity:1];
    
    for(id<NSFetchedResultsSectionInfo> sectionInfo in [fetchController sections]){
        NSString* key=NSLocalizedString([sectionInfo name],nil);
        NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:2];
        for(UserInfo* info in [fetchController fetchedObjects]){
            if([info.userGroup isEqualToString:key]){
                BOOL isAdding=NO;
                for(GroupRoomUserEntity* entity in list){
                    if([entity.jid isEqualToString:info.userJid]){
                        isAdding=YES;
                        break;
                    }
                }
                if(!isAdding)
                    [array addObject:info];
            }
        }
        if([array count]>0){
            NSArray* __array=[array sortedArrayUsingFunction:groupMemberContactListViewSort context:nil];
            [friendsListDict setObject:__array forKey:key];
        }

    }
    
    
    
    
    
    controller.dicts=friendsListDict;
    
    
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        controller.delegate=self;
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
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
    
}

#pragma mark contactselectedby group delegate

-(void)dismiss:(ContactSelectedForGroupViewController *)controller{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:YES];
    popover=nil;
    
}

#pragma mark imagepicker delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    popover=nil;
    return YES;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    popover=nil;
}



@end
