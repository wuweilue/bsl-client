//
//  RecentTalkView.m
//  cube-ios
//
//  Created by apple2310 on 13-9-12.
//
//

#import "RecentTalkView.h"
#import "RectangleChat.h"
#import "RectangleCell.h"

@interface RecentTalkView()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>{
    NSManagedObjectContext *managedObjectContext;
    
    NSFetchedResultsController *fetchedResultsController;

}

-(void)delayReloadTimeEvent;
@end

@implementation RecentTalkView
@synthesize rectentDelegate;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.dataSource=self;
        self.delegate=self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        list=[[NSMutableArray alloc] initWithCapacity:2];
        managedObjectContext = [ShareAppDelegate xmpp].managedObjectContext;
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"RectangleChat" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchBatchSize:20];
        //排序
        
        NSSortDescriptor*sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"updateDate"ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"rectangleTalk"];
        fetchedResultsController.delegate = self;
        
        
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

        
        NSArray *contentArray = [fetchedResultsController fetchedObjects];

        int i=0;
        for(id obj in contentArray){
            [list addObject:obj];
            if(i>=20)break;
            i++;
        }

        
    }
    return self;
}

- (void)dealloc{
    [laterReloadTimer invalidate];
    fetchedResultsController.delegate=nil;
}

#pragma mark method

-(void)loadData{
    
}

-(void)delayReloadTimeEvent{
    [laterReloadTimer invalidate];
    laterReloadTimer=nil;
    [self reloadData];
}

#pragma mark tableview delegate  datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RectangleCell height];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RectangleCell *cell = (RectangleCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[RectangleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    RectangleChat* model=[list objectAtIndex:[indexPath row]];
    [cell headerUrl:@"" title:model.name content:model.content date:model.updateDate];
    [cell number:[model.noReadMsgNumber intValue]];
    RectangleCellType type=RectangleCellTypeMessage;
    if([model.contentType intValue]==RectangleChatContentTypeImage)
        type=RectangleCellTypeImage;
    else if([model.contentType intValue]==RectangleChatContentTypeVoice)
        type=RectangleCellTypeVoice;
    [cell rectangleType:type];
    return cell;
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RectangleChat* model=[list objectAtIndex:[indexPath row]];

    if([self.rectentDelegate respondsToSelector:@selector(rectentTalkViewDidSelected:rectangleChat:)])
        [self.rectentDelegate rectentTalkViewDidSelected:self rectangleChat:model];
}


#pragma mark  fetchedresultscontroller  delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    if(![anObject isKindOfClass:[RectangleChat class]])return;
    if (type==NSFetchedResultsChangeInsert) {
        
        RectangleChat* removeChat=(RectangleChat*)anObject;
        for(RectangleChat* chat in list){
            if([chat.receiverJid isEqualToString:removeChat.receiverJid]){
                [list removeObject:chat];
                break;
            }
        }

        [list insertObject:anObject atIndex:0];
        while([list count]>20){
            [list removeLastObject];
        }

        [laterReloadTimer invalidate];
        laterReloadTimer=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(delayReloadTimeEvent) userInfo:nil repeats:NO];

    }else if (type==NSFetchedResultsChangeUpdate) {
        RectangleChat* updateChat=(RectangleChat*)anObject;
        [list enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL* stop){
            RectangleChat* chat=obj;
            if([chat.receiverJid isEqualToString:updateChat.receiverJid]){
                *stop=YES;
                [list removeObject:chat];
                [list insertObject:updateChat atIndex:index];
                return ;
            }
        }];
        [laterReloadTimer invalidate];
        laterReloadTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayReloadTimeEvent) userInfo:nil repeats:NO];
    }
    else if(type==NSFetchedResultsChangeDelete){
//        [laterReloadTimer invalidate];
//        laterReloadTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayReloadTimeEvent) userInfo:nil repeats:NO];
    }
    else if(type==NSFetchedResultsChangeMove){
        
    }
}

@end
