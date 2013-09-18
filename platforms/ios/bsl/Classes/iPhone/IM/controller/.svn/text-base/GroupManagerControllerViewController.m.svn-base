//
//  GroupManagerControllerViewController.m
//  cube-ios
//
//  Created by Mr Right on 13-8-13.
//
//

#import "GroupManagerControllerViewController.h"
#import "MultiSelectTableViewCell.h"
#import "NSMutableArray+Additions.h"
#import "GroupPeopleViewViewController.h"

@interface GroupManagerControllerViewController ()


@end

@implementation GroupManagerControllerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)editSportAction:(UIBarButtonItem *)barButton
{
    [_GroupManagerTable setEditing:!_GroupManagerTable.editing animated:YES];
    
    if (_GroupManagerTable.editing)
    {
        barButton.title = @"完成";
    }
    else
    {
        barButton.title = @"编辑";
        [self editingEnd];
        //save data opertation
    }
    
}

-(void)editingEnd
{
    [_groupChatUserArr removeAllObjects];
    [_groupChatUserArr addObjectsFromArray:groupChatArrCopy];
    [_GroupManagerTable reloadData];
}

- (void)viewDidLoad
{
 [super viewDidLoad];

    [_GroupManagerTable setBackgroundColor:[UIColor clearColor]];
    _GroupManagerTable.allowsSelectionDuringEditing = YES;
    
//    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"+"
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:self
//                                                                     action:@selector(editSportAction:)];
//    self.navigationItem.rightBarButtonItem = editBarButton;
//    [editBarButton release];
    
    //关闭添加好友方法
    UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 43, 30)];
    [navRightButton setImage:[UIImage imageNamed:@"btn_add@2x.png"] forState:UIControlStateNormal];
//     [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn_active@2x.png"] forState:UIControlStateSelected];
//     [navRightButton setTitle:@"搜索" forState:UIControlStateNormal];
     [[navRightButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
     [navRightButton addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:navRightButton] autorelease];
     [navRightButton release];
    
    _groupChatUserArr = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 5; i++)
    {
        [_groupChatUserArr addObject:[NSNumber numberWithInt:i]];
    }
    groupChatArrCopy=[[NSMutableArray alloc]init];
    [groupChatArrCopy addObjectsFromArray:_groupChatUserArr];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark -
#pragma mark Table view data source

-(void)addUser
{
    
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return (nil == _groupChatUserArr) ? 0 : _groupChatUserArr.count;
  
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MultiSelectTableViewCell1";
    
    MultiSelectTableViewCell *cell = (MultiSelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MultiSelectTableViewCell" owner:self options:nil]objectAtIndex:0];
    }

    cell.detailLabel.text =[NSString stringWithFormat:@"Row %d", [[_groupChatUserArr objectAtIndex:indexPath.row] integerValue]];
 
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
//      toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    [_groupChatUserArr moveObjectFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 51;

}


#pragma mark -
#pragma mark Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        [groupChatArrCopy removeObject:[_groupChatUserArr objectAtIndex:indexPath.row]];

    }
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return @"删除";

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
         [groupChatArrCopy addObject:[_groupChatUserArr objectAtIndex:indexPath.row]];
       
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_groupChatUserArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationRight];
    }
    [tableView endUpdates];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_GroupManagerTable release];
    [groupChatArrCopy release];
    [_groupChatUserArr release];
    [_ExitButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setGroupManagerTable:nil];
    [self setExitButton:nil];
    [self setGroupChatUserArr:nil];
    [super viewDidUnload];
}
- (IBAction)ExitAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}





@end
