//
//  AnnouncementTableViewController.m
//  Cube-iOS
//
//  Created by chen shaomou on 2/5/13.
//
//

#import "AnnouncementTableViewController.h"
#import "AnnouncementTableViewCell.h"
#import "NSManagedObject+Repository.h"
#import "Announcement.h"
#import "MessageRecord.h"

#define RECORD_DELETE @"RECORD_DELETE"
@interface AnnouncementTableViewController ()<UITableViewDataSource,UITableViewDelegate>
-(void)createRrightNavItem;
-(void)rightNavClick;
@end

@implementation AnnouncementTableViewController

@synthesize list;
@synthesize recordId;
- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.navigationItem setTitle:@"公告"];
        //覆盖屏蔽右边控制
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:ANNOUNCEMENT_DID_SAVE_NOTIFICATION object:nil];

    }
    return self;
}


-(void)rightNavClick{
//    tableView.editing=!tableView.editing;
    [tableView setEditing:!tableView.editing animated:YES];
    [self createRrightNavItem];

}

-(void)createRrightNavItem{
    if([self.list count]<1){
        self.navigationItem.rightBarButtonItem=nil;
        return;
    }
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        NSString* title=(tableView.editing?@"取消":@"编辑");
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(rightNavClick)];
    }
    else{
        UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 43, 30)];
        //navRightButton.style = UIBarButtonItemStyleBordered;
        [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn.png"] forState:UIControlStateNormal];
        [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn_active.png"] forState:UIControlStateSelected];
        [navRightButton setTitle:(tableView.editing?@"取消":@"编辑") forState:UIControlStateNormal];
        [[navRightButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
        [navRightButton addTarget:self action:@selector(rightNavClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightButton];
    }

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
    
    tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"homebackImg.png"]];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:246/256.0 green:246/256.0 blue:246/256.0 alpha:1.0]];
    
    self.list=[NSMutableArray arrayWithArray:[Announcement findAllOrderByReviceTime]];
    
    //跳转到对应的公告记录
    if([self.recordId length]>0){
        __block int slideIndex = -1;
        [self.list enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL* stop){
            Announcement *announcement=obj;
            if([announcement.recordId isEqualToString:self.recordId]){
                slideIndex = index;
                *stop=YES;
            }
        }];
        if(slideIndex>-1){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:slideIndex];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    
    [self createRrightNavItem];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    for (Announcement *announcement in list) {
        [announcement setIsRead:[NSNumber numberWithBool:YES]];
    }
    [[Announcement managedObjectContext] save:nil];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)delayLoadTimerTimerEvent{
    [delayLoadTimer invalidate];
    delayLoadTimer=nil;
    
    self.list=[NSMutableArray arrayWithArray:[Announcement findAllOrderByReviceTime]];
    [self createRrightNavItem];

    [tableView reloadData];
    

}

- (void)loadData{
    
    [delayLoadTimer invalidate];
    delayLoadTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayLoadTimerTimerEvent) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor whiteColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)__tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Announcement* announcent = [list objectAtIndex:[indexPath section]];

    return [AnnouncementTableViewCell cellHeight:announcent.content width:__tableView.frame.size.width editing:__tableView.editing];
}


- (UITableViewCell *)tableView:(UITableView *)__tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    AnnouncementTableViewCell *cell = [__tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AnnouncementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    Announcement* announcent = [list objectAtIndex:[indexPath section]];
    cell.editing=__tableView.editing;
    [cell title:announcent.title content:announcent.content time:announcent.reviceTime isRead:[announcent.isRead boolValue]];
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)__tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(__tableView.editing)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)__tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //        获取选中删除行索引值
        int index=[indexPath section];
        
        Announcement* announcent=[self.list objectAtIndex:index];
        [announcent remove];
        [self.list removeObjectAtIndex:index];
        
        [__tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        if([self.list count]<1)
            self.navigationItem.rightBarButtonItem=nil;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)__tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [__tableView deselectRowAtIndexPath:indexPath animated:YES];
    int index=[indexPath section];
    Announcement* announcent=[self.list objectAtIndex:index];
    if(![announcent.isRead boolValue]){
        announcent.isRead=[NSNumber numberWithBool:YES];
        [announcent save];
        
        MessageRecord* messageRecord=[MessageRecord findMessageRecordByAnounceId:announcent.recordId];
        messageRecord.isIconBadge=[NSNumber numberWithInt:0];
        messageRecord.isRead=[NSNumber numberWithBool:YES];
        messageRecord.isMessageBadge=[NSNumber numberWithInt:0];

        [messageRecord save];
        
        [__tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"module_badgeCount_change" object:nil];
    }


}
@end
