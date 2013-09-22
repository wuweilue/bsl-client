//
//  RoomService.m
//  cube-ios
//
//  Created by 肖昶 on 13-9-17.
//
//

#import "RoomService.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPRoom.h"
#import "RectangleChat.h"
#import "Base64.h"

@interface RoomService()<NSFetchedResultsControllerDelegate,XMPPRoomDelegate>


@end

@implementation RoomService

-(id)init{
    self=[super init];
    if(self){
        rooms=[[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return self;
}

-(void)dealloc{
    
    [self tearDown];
}

-(void)joinAllRoomService{
    [self tearDown];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RectangleChat" inManagedObjectContext:[ShareAppDelegate xmpp].managedObjectContext];
    [fetchRequest setEntity:entity];
    //排序
    
    NSSortDescriptor*sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"updateDate"ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ShareAppDelegate xmpp].managedObjectContext sectionNameKeyPath:nil cacheName:@"rectangleTalk"];
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    NSArray *contentArray = [fetchedResultsController fetchedObjects];
    
    for(RectangleChat* chat in contentArray){
        if([chat.isGroup boolValue]){
            [self joinRoomServiceWithRoomID:chat.receiverJid];
        }
    }
}

-(XMPPRoom*)findRoomByJid:(NSString*)roomId{
    for(XMPPRoom* room in rooms){
        NSString* roomJID=[room.roomJID bare];
        if([roomJID isEqualToString:roomId]){
            return room;
        }
    }
    return nil;
}


-(void)joinRoomServiceWithRoomID:(NSString*)__roomID{
    XMPPRoom* newRoom=[[XMPPRoom alloc]initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:[XMPPJID jidWithString:__roomID]];
    
    [rooms addObject:newRoom];
    
    [newRoom activate:[self getCurrentStream]];
    [newRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    if ([newRoom preJoinWithNickname:[self getCurrentUserName]]){
        [newRoom joinRoomUsingNickname:[self getCurrentUserName] history:nil];
    }
    
    //[self performSelector:@selector(ConfigureNewRoom:) withObject:newRoom afterDelay:3.0];
}


-(NSString*)createNewRoom{
    NSString* newJid=[self getGenerateUUID];
    XMPPRoom* newRoom=[[XMPPRoom alloc]initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:[XMPPJID jidWithString:newJid]];
    [rooms addObject:newRoom];
    [newRoom activate:[self getCurrentStream]];
    [newRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([newRoom preJoinWithNickname:[self getCurrentUserName]])
    {
        [newRoom joinRoomUsingNickname:[self getCurrentUserName] history:nil];
    }
    //    [self ConfigureNewRoom:_room];
    //[self performSelector:@selector(ConfigureNewRoom:) withObject:newRoom afterDelay:3.0f];
    return newJid;
}

-(void)removeNewRoom:(NSString*)roomId{
    [rooms enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL*stop){
        XMPPRoom* room=(XMPPRoom*)obj;
        NSString* roomJID=[room.roomJID bare];
        if([roomJID isEqualToString:roomId]){
            [room removeDelegate:self];
            [room deactivate];
            [rooms removeObject:room];
            *stop=YES;
            return;
        }

    }];
}

////配置room
-(void)ConfigureNewRoom:(XMPPRoom *)sender
{
    [sender fetchConfigurationForm];
    [sender configureRoomUsingOptions:nil];
}

-(NSString*)getGenerateUUID{
    XMPPStream *stream = [self getCurrentStream];
    NSString *newMUCStr =[NSString stringWithFormat:@"%@@%@",[stream generateUUID],kMUCSevericeDomin];
    return newMUCStr;
}

-(XMPPStream*)getCurrentStream{
    XMPPStream *stream = [ShareAppDelegate xmpp].xmppStream;
    return stream;
}

-(NSString*)getCurrentUserName{
    //NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //NSString* username= [defaults objectForKey:@"username"];
    return [[[[ShareAppDelegate xmpp] xmppStream] myJID] bare];
    //return username;
}



-(void)tearDown{
    for(XMPPRoom* room in rooms){
        [room removeDelegate:self];
        [room deactivate];
    }
    [rooms removeAllObjects];
}

#pragma RoomDelegate

- (void)xmppRoomDidCreate:(XMPPRoom *)sender{
//    self.roomID =[NSString stringWithFormat:@"%@",sender.myRoomJID.bare];
//    self.roomName=[NSString stringWithFormat:@"%@",sender.roomJID];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"XMPP_CREATEROOM_NOTIFICATION" object:sender];
    
}


- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
    
    /*
     if (self.roomDidJoinBlock) {
     self.roomDidJoinBlock();
     self.roomDidJoinBlock=nil;
     }
     */
    
    [self performSelector:@selector(ConfigureNewRoom:) withObject:sender afterDelay:2.0f];
}


- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult{
    //    if([iqResult.type isEqualToString:@"result"])
    //    {
    //
    //    }
    NSLog(@"认证成功");

}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    NSXMLElement* element=[presence elementForName:@"x"];
    element=[element elementForName:@"item"];
    

    NSString* jid=[[[element attributes] objectAtIndex:0] stringValue];
    
    NSRange range = [jid rangeOfString:@"/"];
    if (range.location ==NSNotFound) {
        return;
    }
    jid = [jid substringToIndex:range.location];

    NSLog(@"===[%@]",[NSString stringWithFormat:@"%@,加入了会议室", jid]);

    
    UserInfo* info=[[ShareAppDelegate xmpp] fetchUserFromJid:jid];
    if(info!=nil){
        [[ShareAppDelegate xmpp] addGroupRoomMember:[[sender roomJID] bare] memberId:jid sex:info.userSex status:info.userStatue username:info.userName];
    }
    else{
        NSRange range = [[[sender roomJID] bare] rangeOfString:@"@"];
        NSString * result1 = [[[sender roomJID] bare] substringToIndex:range.location];

        [[ShareAppDelegate xmpp] addGroupRoomMember:[[sender roomJID] bare] memberId:jid sex:@"" status:@"在线" username:result1];

    }
    
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    NSLog(@"离开了聊天室");
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    NSLog(@"聊天室更新");
}

- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult{
    NSLog(@"认证失败");
    
    /*
    <iq xmlns="jabber:client" type="error" id="F7723F4C-68E2-4076-8D57-81999F8E25F8" from="8850ca32-fd95-4857-a555-5ad014c088e1@conference.snda-192-168-2-32" to="guodong@snda-192-168-2-32/Cube_Client11"><query xmlns="http://jabber.org/protocol/muc#owner"><x xmlns="jabber:x:data" type="submit"></x></query><error code="403" type="auth"><forbidden xmlns="urn:ietf:params:xml:ns:xmpp-stanzas"></forbidden></error></iq>

     */
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items{
    NSLog(@"didFetchMembersList:[%@]",items);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items{
    NSLog(@"didFetchBanList:[%@]",items);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items{
    NSLog(@"didFetchModeratorsList:[%@]",items);
}


//for groupchat 来自群聊的消息
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{
    if([message isMessageWithBody]){
        NSRange range = [message.fromStr rangeOfString:@"/"];
        if (range.location ==NSNotFound) {
            return;
        }
        NSString *roomId = [message.fromStr substringToIndex:range.location];
        NSString *senderUser =  [message.fromStr substringFromIndex:range.location +1];
        if([senderUser isEqualToString:[sender myNickname]]){
            return;
        }
        
        NSString *uqID = [[message attributeForName:@"uqID"] stringValue];
        
        
        if([[ShareAppDelegate xmpp] fetchMessageFromUqID:uqID messageId:roomId]!=nil)
            return;
        
        @autoreleasepool {
            MessageEntity *messageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext: [ShareAppDelegate xmpp].managedObjectContext];
            
            messageEntity.uqID=uqID;
            messageEntity.messageId=roomId;
            messageEntity.sendUser=[NSString stringWithFormat:@"%@@@%@",senderUser,kXMPPDomin];
            messageEntity.receiveUser=[[[ShareAppDelegate xmpp].xmppStream myJID]bare];
            
            NSString* msg=[[message elementForName:@"body"] stringValue];
            
            RectangleChatContentType rectangleChatContentType=RectangleChatContentTypeMessage;
            
            if ([ [[message elementForName:@"subject"] stringValue] isEqualToString:@"voice"]) {
                //将字符串转换成nsdata
                NSData* fileData =  [Base64 decodeString:msg];
                NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex: 0];
                NSURL* urlVoiceFile= [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
                [fileData writeToURL:urlVoiceFile atomically:YES];
                messageEntity.content = [urlVoiceFile absoluteString];
                messageEntity.type = @"voice";
                rectangleChatContentType=RectangleChatContentTypeVoice;
            }
            else if ([ [[message elementForName:@"subject"] stringValue] isEqualToString:@"image"]) {
                messageEntity.content = msg;
                messageEntity.type = @"image";
                rectangleChatContentType=RectangleChatContentTypeImage;
            }else{
                messageEntity.content = msg;
                messageEntity.type = @"text";
            }
            
            messageEntity.flag_readed = [NSNumber numberWithBool:NO];
            messageEntity.sendDate = [NSDate date];
            messageEntity.receiveDate=[NSDate date];
            
            [messageEntity didSave];
            
            RectangleChat* rectChat=[[ShareAppDelegate xmpp] fetchRectangleChatFromJid:roomId isGroup:YES];
            
            if(rectChat==nil){
                [[ShareAppDelegate xmpp] newRectangleMessage:roomId name:@"" content:msg contentType:rectangleChatContentType isGroup:YES];
                [[ShareAppDelegate xmpp] saveContext];
                rectChat=[[ShareAppDelegate xmpp] fetchRectangleChatFromJid:roomId isGroup:YES];
            }
            
            rectChat.updateDate=[NSDate date];
            rectChat.content=msg;
            int noReadMsgNumber=[rectChat.noReadMsgNumber intValue]+1;
            rectChat.noReadMsgNumber=[NSNumber numberWithInt:noReadMsgNumber];
            rectChat.contentType=[NSNumber numberWithInt:rectangleChatContentType];
            [rectChat didSave];
        }
    }
    
}


@end
