//
//  MessageRecordTableViewController.m
//  Cube-iOS
//
//  Created by chen shaomou on 2/1/13.
//
//

#import "MessageRecordTableViewController.h"
#import "CubeApplication.h"
#import "MessageRecordHeaderView.h"
#import "Cache.h"
#import "CubeModule.h"
#import "MessageRecord.h"
#import "MessageRecordTableViewCell.h"
#import "CubeWebViewController.h"
#import "AnnouncementTableViewController.h"
@interface MessageRecordTableViewController ()
-(void)delayLoadTimerEvent;

@end

@implementation MessageRecordTableViewController

@synthesize presentModulesDic,editing,expandDic;
@synthesize flagDictionary;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"消息推送";
       
        
       /* //覆盖屏蔽右边控制
        UIButton *navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 43, 30)];
        [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn@2x.png"] forState:UIControlStateNormal];
        [navRightButton setBackgroundImage:[UIImage imageNamed:@"nav_add_btn_active@2x.png"] forState:UIControlStateSelected];
        [navRightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [[navRightButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
        [navRightButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:navRightButton] autorelease];
        
        //[self.navigationItem setRightBarButtonItem:rightItem animated:YES];
        
        [navRightButton release];*/
        
        editing = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageRevice:) name:MESSAGE_RECORD_DID_SAVE_NOTIFICATION object:nil];
        
        //delete  by fanty
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRecord:) name:RECORD_DELETE object:nil];

    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self loadData];
     [self setExtraCellLineHidden:self.tableView];
    flagDictionary = [[NSMutableDictionary alloc]initWithCapacity:0];
    /*UIImageView* backgroundView  = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]autorelease];
     backgroundView.image = [UIImage imageNamed:@"homebackImg.png"];
     [self.tableView setBackgroundView:backgroundView];*/
}

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController.navigationBar setHidden:NO];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //这里的实现效率很差还会导致卡，更换FMDB后sql语句更新状态效率更高
    //TODO 待优化
    NSArray *systemRecords = [MessageRecord findSystemRecord];
    for(MessageRecord *record in systemRecords)
    {
        record.isRead = [NSNumber numberWithBool:YES];
        //        [record save];
    }
    for(CubeModule *each in [[CubeApplication currentApplication]modules]){
        if (![each.identifier isEqualToString:@"com.foss.chat"]) {
            
            NSArray *records = [MessageRecord findForModuleIdentifier:each.identifier];
            if([records count] > 0 ){
                for (MessageRecord * rec in records) {
                    rec.isRead = [NSNumber numberWithBool:YES];
                    //                        [rec save];
                }
            }
        }
    }
    [MessageRecord save];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)edit{
    
    if(editing){
        editing = NO;
        [self.tableView setEditing:NO animated:YES];
        
    }else{
        editing = YES;
        [self.tableView setEditing:YES animated:YES];
    }
    
}

-(void)loadData{
    
    NSArray *modules = [[CubeApplication currentApplication] modules];
    
    if(!presentModulesDic){
        
        presentModulesDic = [[NSMutableDictionary alloc] init];
    }
    
    if(!expandDic){
    
        expandDic = [[NSMutableDictionary alloc] init];
    }
    
    NSArray *systemRecords = [MessageRecord findSystemRecord];
    
    if(systemRecords && systemRecords.count > 0){
        [presentModulesDic setObject:systemRecords forKey:@"0system"];
    }
    
    
    //装入本地模块
    for(CubeModule *each in modules){
        if (![each.identifier isEqualToString:@"com.foss.chat"]) {
            if (each.local) {
                NSArray *records = [MessageRecord findForModuleIdentifier:each.identifier];
                if([records count] > 0 ){
                    [presentModulesDic setObject:records forKey:each.identifier];
                }
            }
        }
    }
    //再装入非本地模块
    for(CubeModule *each in modules){
        if (![each.identifier isEqualToString:@"com.foss.chat"]) {
            if (!each.local) {
                NSArray *records = [MessageRecord findForModuleIdentifier:each.identifier];
                
                if([records count] > 0 ){
                    [presentModulesDic setObject:records forKey:each.identifier];
                }
            }
            
        }
    }
    
    
    
}

-(void)delayLoadTimerEvent{
    [delayLoadTimer invalidate];
    delayLoadTimer=nil;
    [self loadData];
    
    [[self tableView] reloadData];

}

-(void)newMessageRevice:(NSNotification*)notification{
    
    //  MessageRecord *record =  (MessageRecord *)notification.object;
    
    [delayLoadTimer invalidate];
    delayLoadTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayLoadTimerEvent) userInfo:nil repeats:NO];
}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[presentModulesDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //[[self.expandDic objectForKey:moduleId] isEqualToNumber:[NSNumber numberWithBool:YES] ]
    
    if([[self.expandDic objectForKey:[NSNumber numberWithInteger:section]] isEqualToNumber:[NSNumber numberWithBool:YES]]){
        
        return [[presentModulesDic objectForKey:[[presentModulesDic allKeys] objectAtIndex:section]] count];
    
    }
    
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MessageRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    MessageRecord *messageRecord = [[presentModulesDic objectForKey:[[presentModulesDic allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    CubeModule *module = [[CubeApplication currentApplication] moduleForIdentifier:messageRecord.module ];
    
    if(module){
        [cell configureWithModuleName:module.name reviceTime:messageRecord.reviceTime alert:messageRecord.alert];
    }else{
        [cell configureWithModuleName:messageRecord.alert reviceTime:messageRecord.reviceTime alert:messageRecord.content];
    }
    if([messageRecord.isRead intValue] == 0)
    {
        cell.isReadLabel.text = @"未读";
    }
    else
    {
        cell.isReadLabel.text = @"";
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
    
    //    return 82.0;
}

-(void)shouldShowCellInModule:(NSString *)moduleId atIndex:(NSInteger)section{
    
    [flagDictionary setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",section]];
    int sectionIndex =  [[presentModulesDic  allKeys] indexOfObject:moduleId];
    if([[self.expandDic objectForKey:[NSNumber numberWithInteger:sectionIndex]] isEqualToNumber:[NSNumber numberWithBool:YES] ]){
        
        [self.expandDic setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:sectionIndex]];
    }else{
    
        [self.expandDic setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:sectionIndex]];
    }

    [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MessageRecordHeaderView *headerView = [[MessageRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 36)];
    headerView.delegate = self;
    headerView.section = section;
    
    CubeModule *module = [[CubeApplication currentApplication] moduleForIdentifier:[[presentModulesDic allKeys] objectAtIndex:section]];
    
    headerView.moduleId = module.identifier;
    
    int msgcount = 0;
    NSArray *array = [presentModulesDic objectForKey:[[presentModulesDic allKeys]objectAtIndex:section]];
    for(MessageRecord *msr in array)
    {
        if([flagDictionary valueForKey:[NSString stringWithFormat:@"%d",section]] != [NSNumber numberWithBool:YES])
        {
            if([msr.isRead intValue] == 0)
            {
                msgcount ++;
            }
        }
        
    }
    if(module){
        [headerView configureWithIconUrl:module.iconUrl moduleName:module.name messageCount:[NSString stringWithFormat:@"%d",[[presentModulesDic objectForKey:[[presentModulesDic allKeys] objectAtIndex:section]] count]] sectionIndenx:section withUnReadCount:[NSString stringWithFormat:@"%d",msgcount ]];
        
    }else{
        headerView.moduleId = @"0system";
        [headerView configureWithIconUrl:nil moduleName:@"系统" messageCount:[NSString stringWithFormat:@"%d",[[presentModulesDic objectForKey:[[presentModulesDic allKeys] objectAtIndex:section]] count]] sectionIndenx:section withUnReadCount:[NSString stringWithFormat:@"%d",msgcount ]];
        
    }
    
    headerView.tag = section + 10;
    
    
    UIImageView* arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xmpp_arrow.png"]];
    arrowImageView.frame= CGRectMake(17, 15, 10, 11);
    if([[self.expandDic objectForKey:[NSNumber numberWithInteger:section]] isEqualToNumber:[NSNumber numberWithBool:YES]]){
        arrowImageView.image  = [self imageTransform:arrowImageView.image rotation:UIImageOrientationRight];
    }
    [headerView addSubview:arrowImageView];

    return headerView;
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


-(void)deleteModuleData:(NSString* )moduleIdendity{
    
    NSArray *moduleRecords = [presentModulesDic objectForKey:moduleIdendity];
   
    for ( int i = 0; i<  [moduleRecords count]; i++) {
        MessageRecord *record = [moduleRecords objectAtIndex:i];
        if (i+1 == [moduleRecords count]) {
            [record remove];
        }else{
            [record removeNoSave];
        }
    }
    
   int section =  [[presentModulesDic  allKeys] indexOfObject:moduleIdendity];
    
    [presentModulesDic removeObjectForKey:moduleIdendity];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
   
    [self.expandDic setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:section]];
    
    [self.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    
    //保存数据
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSMutableArray *moduleRecords = [presentModulesDic objectForKey:[[presentModulesDic allKeys] objectAtIndex:indexPath.section]];
        
                
        NSArray *newModuleRecords = [MessageRecord findForModuleIdentifier:[[presentModulesDic allKeys] objectAtIndex:indexPath.section]];
        //删除的是本地模块
        MessageRecord *record = [moduleRecords objectAtIndex:indexPath.row];
         [record remove];
        
        if(newModuleRecords.count == 0 ){
           [presentModulesDic setObject:[MessageRecord findSystemRecord] forKey:[[presentModulesDic allKeys] objectAtIndex:indexPath.section]];
           

        }else{
           

            [presentModulesDic setObject:newModuleRecords forKey:[[presentModulesDic allKeys] objectAtIndex:indexPath.section]];
            
            MessageRecordHeaderView *headerView  = (MessageRecordHeaderView *)[tableView viewWithTag:indexPath.section + 100];
            
            headerView.messageCountLabel.text = [NSString stringWithFormat:@"%d",[newModuleRecords count]];
            
            
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CubeModule *module = [[CubeApplication currentApplication] moduleForIdentifier:[[presentModulesDic allKeys] objectAtIndex:indexPath.section]];
    MessageRecord *messageRecord = [[presentModulesDic objectForKey:[[presentModulesDic allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if(module.local  && ![module.identifier isEqualToString:@"com.foss.announcement"]){
        NSString* iphoneLocal;
        if ([module.local isEqualToString:@"DetailViewController"]) {
            iphoneLocal = @"iphoneVoiceMasterViewController";
        }else{
            iphoneLocal = module.local;
        }
        UIViewController *localController = (UIViewController *)[[NSClassFromString(iphoneLocal) alloc] init];
        
        [self.navigationController.navigationBar setHidden:NO ];
        [self.navigationController pushViewController:localController animated:YES];
        
        
        return;
    }
    else if(module.local  && [module.identifier isEqualToString:@"com.foss.announcement"])
    {
//        NSString* iphoneLocal = module.local;
        
        AnnouncementTableViewController *localController = (AnnouncementTableViewController *)[[NSClassFromString(@"AnnouncementTableViewController") alloc] init];
        NSString *recordId = messageRecord.recordId;
        localController.recordId = recordId;
        [self.navigationController.navigationBar setHidden:NO ];
        [self.navigationController pushViewController:localController animated:YES];
        
        return;
    }
    
    
    
    //判断不是本地模块
    if ( [module.pushMsgLink isEqualToString:@"1"]) {
        @autoreleasepool {
            NSDictionary *missingModules = [module missingDependencies];
            NSArray *needInstall = [missingModules objectForKey:kMissingDependencyNeedInstallKey];
            NSArray *needUpgrade = [missingModules objectForKey:kMissingDependencyNeedUpgradeKey];
            
            if ([needInstall count] > 0 || [needUpgrade count] > 0) {
                NSMutableString *message = [[NSMutableString alloc] init];
                
                if([needInstall count] > 0){
                    
                    [message appendString:@"需要安装以下模块:\n"];
                    for ( NSString *dependency in needInstall) {
                        CubeModule *m = [[CubeApplication currentApplication] availableModuleForIdentifier:dependency];
                        if(m!=nil)
                            [message appendFormat:@"%@(build:%d)\n", m.name,m.build];
                        else
                            [message appendFormat:@"%@\n", dependency];
                    }
                    
                }
                
                if( [needUpgrade count] > 0){
                    
                    [message appendString:@"需要升级以下模块:\n"];
                    for ( NSString *dependency in needUpgrade) {
                        CubeModule *m = [[CubeApplication currentApplication] moduleForIdentifier:dependency];
                        if(m!=nil)
                            [message appendFormat:@"%@(build:%d)\n", m.name,m.build];
                        else
                            [message appendFormat:@"%@\n", dependency];
                    }
                    
                }
                
                self.selectedModule = module.identifier;
                UIAlertView *dependsAlert = [[UIAlertView alloc] initWithTitle:@"缺少依赖模块"
                                                                       message:message
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定" otherButtonTitles:/*@"安装", */nil];
                [dependsAlert show];
                return;
            }
        }
        
        //植入界面
        if (!cubeWebViewController) {
            cubeWebViewController  = [[CubeWebViewController alloc] init];
        }
        cubeWebViewController.title=module.name;
        
        MessageRecord *messageRecord = [[presentModulesDic objectForKey:[[presentModulesDic allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        
        NSString * moduleIndex = [[[module runtimeURL] URLByAppendingPathComponent:@"index.html"] absoluteString];
        
        if(!messageRecord.recordId || messageRecord.recordId.length == 0 ){
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"旧数据不支持跳转" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        cubeWebViewController.startPage = [NSString stringWithFormat:@"%@?recordId=%@", moduleIndex, messageRecord.recordId];
        
        [cubeWebViewController loadWebPageWithModuleIdentifier:module.identifier didFinishBlock: ^(){
            NSLog(@"finish loading");
            [self.navigationController.navigationBar setHidden:NO];
            
            [self.navigationController pushViewController:cubeWebViewController animated:YES];
            
            
            cubeWebViewController = nil;
        }   didErrorBlock:^(){
            NSLog(@"error loading");
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"消息模块加载失败。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            cubeWebViewController = nil;
        }];
    }
    
    

}

//修改删除按钮的文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        CubeModule *module = [[CubeApplication currentApplication] moduleForIdentifier:self.selectedModule];
        //需要下载的模块
        NSArray *missingModules = [[module missingDependencies] objectForKey:kMissingDependencyNeedInstallKey];
        for (NSString *missingModule in missingModules) {
            CubeModule *am = [[CubeApplication currentApplication] availableModuleForIdentifier:missingModule];
            am.isDownloading = YES;
            [[CubeApplication currentApplication] installModule:am];
        }
        
        //需要升级的模块
        NSArray *needUpgradeModules = [[module missingDependencies] objectForKey:kMissingDependencyNeedUpgradeKey];
        for (NSString *needUpgradeModule in needUpgradeModules) {
            CubeModule *am = [[CubeApplication currentApplication] updatableModuleModuleForIdentifier:needUpgradeModule];
            am.isDownloading = YES;
            [[CubeApplication currentApplication] installModule:am];
        }
    }
}



@end
