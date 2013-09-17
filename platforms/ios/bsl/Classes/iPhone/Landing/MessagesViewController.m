//
//  MessagesViewController.m
//  Cube-iOS
//
//  Created by Pepper's mpro on 12/10/12.
//
//

#import "MessagesViewController.h"
#import "MsgListCell.h"
#define MESSAGE_FILENAME @"CubeMessage.plist"
#define MESSAGE_FILEPATH @"com.foss.message"
#define kCUBEMESSAGE_Notification @"Notification_MESSAGE"

@interface MessagesViewController ()
@property (retain,nonatomic) NSMutableArray *resortedArray;
- (NSString *)CubeMessagePath;
-(void)saveData:(NSMutableArray *)array;
-(void)inverseArray;

@end

@implementation MessagesViewController
@synthesize datas = _datas;
@synthesize cell = _cell;
@synthesize resortedArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息推送";
    
    UITableView *table = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    self.tableView = table;
    [table release];
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone) {
            self.tableView.rowHeight = 78;
    }else{
            self.tableView.rowHeight = 110;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSLog(@"where the file------>%@",[self CubeMessagePath]);
    self.datas = [NSArray arrayWithContentsOfFile:[self CubeMessagePath]];
    self.resortedArray = [[[NSMutableArray alloc] initWithCapacity:20] autorelease];
    [self inverseArray];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageData) name:kCUBEMESSAGE_Notification object:nil];
    
    [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(removeAllData)] autorelease]];

//    NSLog(@"%d",self.datas.count);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)dealloc{
    self.datas=nil;
    self.cell=nil;

    [super dealloc];
}

-(void)reloadMessageData
{
    self.datas = [NSArray arrayWithContentsOfFile:[self CubeMessagePath]];
    [self inverseArray];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) inverseArray
{
    for(NSDictionary *item in self.datas){
        [self.resortedArray insertObject:item atIndex:0];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellTableIdentifier";
    MsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"iphoneMsgListCell" owner:self options:nil]objectAtIndex:0];
        }else{
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MsgListCell" owner:self options:nil]objectAtIndex:0];

        }

    }
    
    //UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"avatar_msg.png"];
    UIImage *img = [UIImage imageNamed:@"avatar_msg.png"];
    cell.headPhoto.image = img;
    cell.headText.text = @"系统";
    cell.msgTitle.text = [[self.resortedArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.msgContent.text = [[self.resortedArray objectAtIndex:indexPath.row] objectForKey:@"message"];
    cell.receiveTime.text = [[self.resortedArray objectAtIndex:indexPath.row] objectForKey:@"messageDate"];
    
    cell.rateView.rating = 5;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.datas removeObjectAtIndex:(self.datas.count - indexPath.row-1)];
        [self saveData:self.datas];
        self.datas = [NSArray arrayWithContentsOfFile:[self CubeMessagePath]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;  //是否需要删除图标
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)CubeMessagePath
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0];
    
    documentDir =[documentDir stringByAppendingPathComponent:MESSAGE_FILEPATH];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm isReadableFileAtPath:documentDir])
    {
        [fm createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [documentDir stringByAppendingPathComponent:MESSAGE_FILENAME];
}


-(void)saveData:(NSMutableArray *)array
{
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:[self CubeMessagePath]])
    {
        [fm createFileAtPath:[self CubeMessagePath] contents:nil attributes:nil];
        [array writeToFile:[self CubeMessagePath] atomically:YES];
    }else
    {
        [fm removeItemAtPath:[self CubeMessagePath] error:nil];
        [fm createFileAtPath:[self CubeMessagePath] contents:nil attributes:nil];
        [array writeToFile:[self CubeMessagePath] atomically:YES];
    }
}

-(void)removeAllData
{
     NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self CubeMessagePath]])
    {
        [fm removeItemAtPath:[self CubeMessagePath] error:nil];
        [self reloadMessageData];
    }
}

@end
