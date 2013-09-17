//
//  XMPPIMActor.m
//  cube-ios
//
//  Created by 东 on 13-3-5.
//
//

#import "XMPPIMActor.h"
#import "UIDevice+IdentifierAddition.h"
#import "HTTPRequest.h"
#import "MessageRecord.h"
#import "Base64.h"
#import "TURNSocket.h"
#import "XMPPSqlManager.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "XMPPvCardTempModule.h"
#import "RectangleChat.h"

@interface XMPPIMActor ()

- (void)teardownStream;
@end

@implementation XMPPIMActor

@synthesize chatDelegate;
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize islogin;
@synthesize loginUserStr;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize xmppvCardTempModule = _xmppvCardTempModule;
@synthesize xmppvCardStorage = _xmppvCardStorage;

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule deactivate];
    
	[xmppStream disconnect];
    
    xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardStorage = nil;
}


- (id)initWithDelegate:(id<XMPPIMActorDelegate>)ad
{
    self = [super init];
    if (self)
    {
        _delegate = ad;
        islogin = false;
        // [self localTest];
        turnSockets = [[NSMutableArray alloc]init];
        
    }
    return self;
}


-(void)dealloc{
    [super dealloc];
    [self teardownStream];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    
}




-(void)newvCard{
    if(!xmppvCardTempModule){
        xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
        [xmppvCardTempModule activate:xmppStream];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupXmppStream
{
    //初始化XMPPStream
    if(!xmppStream){
        xmppStream = [[XMPPStream alloc] init];
        [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
        
    }
    // Setup roster
    
    if (!xmppvCardStorage) {
        xmppvCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    }
    
    if(!xmppRosterStorage){
        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    }
	
    if (!xmppRoster) {
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage: xmppRosterStorage];
        xmppRoster.autoFetchRoster = NO;
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        
        [xmppRoster activate:xmppStream];
        [xmppRoster addDelegate:self delegateQueue:dispatch_get_current_queue()];
    }
	
    
    if (!xmppReconnect) {
        xmppReconnect = [[XMPPReconnect alloc] init];
        [xmppReconnect activate:xmppStream];
    }
    
    [self connect];
    [xmppReconnect setAutoReconnect:YES];
    
}

-(XMPPvCardTempModule *)xmppvCardTempModule{
    
    return xmppvCardTempModule;
}



- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	[[self xmppStream] sendElement:presence];
}

- (void)goOffLine
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)isConnected{
    return [xmppStream isConnected];
}

-(void)disConnect{
    if ([xmppStream isConnected]) {
        [self goOffLine];
        [xmppStream disconnect];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XMPPSTREAMIMOFFLINE" object:nil];
    }
}

-(void)connectDriver{
    if ([xmppStream isConnected]) {
        [self goOffLine];
        
        [xmppStream disconnect];
    }
    islogin = NO;
    loginUserStr = @"";
    [self connect];
    
}

-(void)connectLoginUser:(NSString*)userName{
    if ([xmppStream isConnected]) {
        [self goOffLine];
        
        [xmppStream disconnect];
    }
    _persistentStoreCoordinator = nil;
    _managedObjectContext= nil;
    islogin = YES;
    loginUserStr = userName;
    [self connect];
}



- (BOOL)connect
{
	if ([xmppStream isConnected])
    {
		return YES;
	}
    
    NSString *uniqueDeviceIdentifier = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSLog(@"DeviceUUID=[%@]",uniqueDeviceIdentifier);
    
    passWord=loginUserStr;
    NSString *userId;
    if (!islogin) {
        userId=[NSString stringWithFormat:@"%@",uniqueDeviceIdentifier];
    }else{
        userId=loginUserStr;
    }
    userId = [userId stringByAppendingFormat:@"@%@",kXMPPDomin];
    
    [xmppStream setMyJID:[XMPPJID jidWithString:userId resource:@"Cube_Client11"]];
    
    [xmppStream setHostName:kXMPPHost];
	[xmppStream setHostPort:kXMPPPort];
    
    if (userId == nil || passWord == nil)
    {
        return NO;
        NSLog(@"xmppSever userName or pwd is nil");
    }
    
	NSError *error = nil;
    
	if (![xmppStream connect:&error])
	{
		return NO;
	}
    
    return YES;
}


- (void)disconnect
{
	[self goOffLine];
	[xmppStream disconnect];
}



#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = @"localhost";
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    passWord = loginUserStr;
	isXmppConnected = YES;
    NSError *error=nil;
    if (![[self xmppStream] authenticateWithPassword:passWord error:&error])
    {
        [self connect];
    }
    
    
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    
    NSLog(@"认证通过");
	[self goOnline];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XMPPSTREAMIMONLINE" object:nil];
    //[self doRegisterPushService];
    
}



- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    passWord =loginUserStr;
    if (![[self xmppStream] registerWithPassword:passWord error:nil])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"网络繁忙,设备注册失败,请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    NSLog(@"认证不通过,错误信息为:%@",error);
    
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    passWord = loginUserStr;
    NSError *error=nil;
    if (![[self xmppStream] authenticateWithPassword:passWord error:&error])
    {
        [self connect];
    }
    NSLog(@"创建账号成功");
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"创建账号失败");
}



-(void)showLocalNotification:(NSString*)Msg
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertAction = @"知道了";
    //		localNotification.alertBody = aMsg;
    localNotification.alertBody = Msg;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    [localNotification release];
}

-(void)showTheMsg:(NSString*)aMsg
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
        
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"知道了";
        //		localNotification.alertBody = aMsg;
        localNotification.alertBody = @"您有新的消息，请注意查收！";
		localNotification.soundName = UILocalNotificationDefaultSoundName;
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        [localNotification release];
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error{
    DDXMLNode *errorNode = (DDXMLNode *)error;
    //遍历错误节点
    for(DDXMLNode *node in [errorNode children])
    {
        //若错误节点有【冲突】
        if([[node name] isEqualToString:@"conflict"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ShareAppDelegate showExit];
            });
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
	if ([message isChatMessageWithBody])
	{
        NSLog(@"message = %@",message);
        NSString *msg = [[message elementForName:@"body"] stringValue];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:from forKey:@"sender"];
        [dict setObject:msg forKey:@"msg"];
        
        NSRange range = [from rangeOfString:@"/"];
        NSString * result = [from substringToIndex:range.location];
        UserInfo * userInfo =[self fetchUserFromJid:result];
        RectangleChatContentType rectangleChatContentType=RectangleChatContentTypeMessage;
        if (userInfo != nil) {
            if (userInfo.userMessageCount != nil ) {
                userInfo.userMessageCount =[NSString stringWithFormat:@"%d",[userInfo.userMessageCount  intValue]+1];//[NSNumber numberWithInt:[userInfo.userMessageCount  intValue]+1];
            }else{
                userInfo.userMessageCount = @"1" ;
                
            }
            if ([[[message elementForName:@"subject"] stringValue] isEqualToString:@"voice"]) {
                userInfo.userLastMessage = @"发送了一段语音给您";
                rectangleChatContentType=RectangleChatContentTypeVoice;
                
            }
            else if ([[[message elementForName:@"subject"] stringValue] isEqualToString:@"image"]) {
                rectangleChatContentType=RectangleChatContentTypeImage;
            }
            else{
                userInfo.userLastMessage = msg;
            }
            userInfo.userLastDate = [NSDate date];
            
            [self saveContext];
            
        }else{
            //如果非好友 但是发送了信息 则添加进入到陌生人列表中
            
            userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext: self.managedObjectContext];
            userInfo.userMessageCount =  @"1";
            if ([[[message elementForName:@"subject"] stringValue] isEqualToString:@"voice"]) {
                userInfo.userLastMessage = @"发送了一段语音给您";
                
            }
            else if ([[[message elementForName:@"subject"] stringValue] isEqualToString:@"image"]) {
                rectangleChatContentType=RectangleChatContentTypeImage;
            }
            else{
                userInfo.userLastMessage = msg;
            }
            
            userInfo.userLastDate = [NSDate date];
            userInfo.userJid = result;
            
            NSRange range = [result rangeOfString:@"@"];
            NSString * result1 = [result substringToIndex:range.location];
            userInfo.userName = result1;
            userInfo.userGroup = @"陌生人";
            
        }
        [self newRectangleMessage:result name:[userInfo name] content:msg contentType:rectangleChatContentType isGroup:NO];
        [self newRectangleMessageNumberAdd:result addOrResetZero:YES isGroup:NO];
        
        //查询到数据库中未显示的消息条数
        [MessageRecord createModuleBadge:@"com.foss.chat" num: [XMPPSqlManager getMessageCount]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"module_badgeCount_change" object:self];
        
        MessageEntity *messageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext: self.managedObjectContext];
        
        if ([ [[message elementForName:@"subject"] stringValue] isEqualToString:@"voice"]) {
            //将字符串转换成nsdata
            NSData* fileData =  [Base64 decodeString:msg];
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(
                                                                    NSDocumentDirectory,
                                                                    NSUserDomainMask, YES) objectAtIndex: 0];
            NSURL* urlVoiceFile= [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
            [fileData writeToURL:urlVoiceFile atomically:YES];
            messageEntity.content = [urlVoiceFile absoluteString];
            messageEntity.type = @"voice";
        }
        else if ([ [[message elementForName:@"subject"] stringValue] isEqualToString:@"image"]) {
            messageEntity.content = msg;
            messageEntity.type = @"image";
        }else{
            messageEntity.content = msg;
            messageEntity.type = @"text";
        }
        messageEntity.sendUser = result;
        messageEntity.receiver = [[self.xmppStream myJID]bare];
        messageEntity.flag_readed = [NSNumber numberWithBool:NO];
        messageEntity.sendDate = [NSDate date];
        messageEntity.receiveDate=[NSDate date];
        
        [messageEntity didSave];
        
    }
}

-(int)getMessageCount{
    return 0;
}



//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] bare];
    //在线用户
    NSString *presenceFromUser = [[presence from] bare];
    if ([presenceType isEqualToString:@"unavailable"]) {
        UserInfo * userStatue =[self fetchUserFromJid:presenceFromUser];
        if (userStatue != nil) {
            userStatue.userStatue = @"";
        }
    }else if (![presenceFromUser isEqualToString:userId]) {
        //在线状态
        UserInfo * userStatue =[self fetchUserFromJid:presenceFromUser];
        if (userStatue != nil) {
            userStatue.userStatue = [presence status];
            if (!userStatue.userStatue.length >0) {
                userStatue.userStatue = @"在线";
            }
        }
    }
}

#pragma mark XMPP
-(UserInfo*)fetchPerson:(NSString*)userName{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName==%@",userName];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedPersonArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    UserInfo *fetchedPerson = nil;
    if (fetchedPersonArray.count>0) {
        fetchedPerson = [fetchedPersonArray objectAtIndex:0];
    }
    return fetchedPerson;
}

-(RectangleChat*)fetchRectangleChatFromJid:(NSString*)userJid isGroup:(BOOL)isGroup{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"receiverJid == \"%@\"",userJid]];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RectangleChat"];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedPersonArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    RectangleChat *fetchedPerson = nil;
    if (fetchedPersonArray.count>0) {
        fetchedPerson = [fetchedPersonArray objectAtIndex:0];
    }
    return fetchedPerson;
}

-(void)newRectangleMessageNumberAdd:(NSString*)receiverJid addOrResetZero:(BOOL)addOrResetZero isGroup:(BOOL)isGroup{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    RectangleChat* rectangleChat = [appDelegate.xmpp fetchRectangleChatFromJid:receiverJid isGroup:isGroup];
    int number=[rectangleChat.noReadMsgNumber intValue];
    if(addOrResetZero)
        number++;
    else
        number=0;
    rectangleChat.noReadMsgNumber=[NSNumber numberWithInt:number];

}

-(void)newRectangleMessage:(NSString*)receiverJid name:(NSString*)name content:(NSString*)content contentType:(RectangleChatContentType)contentType isGroup:(BOOL)isGroup{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RectangleChat"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"receiverJid == \"%@\"",receiverJid]];
    NSError *error=nil;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext* context=[appDelegate xmpp].managedObjectContext;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:&error];
    if(!error){
        for(id obj in fetchResult){
            [context deleteObject:obj];
        }
    }
    
    
    
    NSManagedObject *newManagedObject=[NSEntityDescription insertNewObjectForEntityForName:@"RectangleChat" inManagedObjectContext:context];
    
    [newManagedObject setValue:[NSNumber numberWithInt:2] forKey:@"chatMemberCount"];
    [newManagedObject setValue:name forKey:@"name"];
    [newManagedObject setValue:content forKey:@"content"];
    [newManagedObject setValue:[NSNumber numberWithInt:RectangleChatContentTypeMessage] forKey:@"contentType"];
    [newManagedObject setValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare] forKey:@"createrJid"];
    [newManagedObject setValue:receiverJid forKey:@"receiverJid"];
    [newManagedObject setValue:[NSNumber numberWithBool:isGroup] forKey:@"isGroup"];
    [newManagedObject setValue:[NSDate date] forKey:@"updateDate"];
    [newManagedObject setValue:[NSNumber numberWithInt:0] forKey:@"noReadMsgNumber"];
    
    
    
}



-(UserInfo*)fetchUserFromJid:(NSString*)userJid{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userJid==%@",userJid];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserInfo"];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedPersonArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    UserInfo *fetchedPerson = nil;
    if (fetchedPersonArray.count>0) {
        fetchedPerson = [fetchedPersonArray objectAtIndex:0];
    }
    return fetchedPerson;
}


//查询好友的列表
-(void)findFriendsList{
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"xmlns" stringValue:@"jabber:client"];
    //消息类型
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    NSString *userId = [[[self xmppStream] myJID] bare];
//    u[serId =[userId stringByAppendingFormat:@"@snda-192-168-2-32"];
    [iq addAttributeWithName:@"from" stringValue:userId];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:roster"];
    [iq addChild:query];
    [[self xmppStream] sendElement:iq];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    if( [[[iq attributeForName:@"type"] stringValue] isEqualToString:@"result"]){
        
        //发送通知  告诉列表不刷新数据
        
        NSXMLElement *query = [iq elementForName:@"query"];
        NSArray *items = [query elementsForName:@"item"];
        if ([items count]>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPRREFRESHTABLEVIEW" object:nil];
            
            for (int textIndex=0 ; textIndex < [items count] ; textIndex ++)
            {
                NSXMLElement *item=(NSXMLElement *)[items objectAtIndex:textIndex];
                NSString *group=[[item elementForName:@"group"] stringValue];
                if (group == nil || [group isEqualToString:@""]) {
                    group = @"好友列表";
                }
                NSString * jidStr = [[item attributeForName:@"jid"] stringValue];
                UserInfo *entity = [self fetchUserFromJid:jidStr];
                if (entity != nil) {
                    entity.userGroup = group;
                    entity.userSubscription = [[item attributeForName:@"subscription"] stringValue];
                    entity.userName = [[item attributeForName:@"name"] stringValue];
                    //                    [self.managedObjectContext save:nil];
                }else{
                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo"inManagedObjectContext:self.managedObjectContext];
                    [newManagedObject setValue:group forKey:@"userGroup"];
                    [newManagedObject setValue:[[item attributeForName:@"name"] stringValue] forKey:@"userName"];
                    [newManagedObject setValue:[[item attributeForName:@"jid"] stringValue] forKey:@"userJid"];
                    [newManagedObject setValue:[[item attributeForName:@"subscription"] stringValue] forKey:@"userSubscription"];
                    //                    [self.managedObjectContext save:nil];
                }
            }
            //发送通知列表可以刷新了
            [[NSNotificationCenter defaultCenter] postNotificationName:@"STARTRREFRESHTABLEVIEW" object:nil];
        }else{

            //remove by fanty 
            //[SVProgressHUD showErrorWithStatus:@"没有好友" ];
            
        }
    }else  if( [[[iq attributeForName:@"type"] stringValue] isEqualToString:@"set"]){
        //删除了好友 或者 增加好友
        NSArray *items = [[iq elementForName:@"query"] elementsForName:@"item"];
        for (int textIndex=0 ; textIndex < [items count] ; textIndex ++)
        {
            NSXMLElement *item=(NSXMLElement *)[items objectAtIndex:textIndex];
            if ([[[item attributeForName:@"subscription"] stringValue] isEqualToString: @"remove"]) {
                
                //先判断jid是否存在
                NSManagedObjectContext *context =self.managedObjectContext;
                NSString * jidStr = [[item attributeForName:@"jid"] stringValue];
                
                
                UserInfo *entity = [self fetchUserFromJid:jidStr];
                
                [context deleteObject:entity];
            }else if ([[[item attributeForName:@"subscription"] stringValue] isEqualToString: @"to"]) {
                
                NSString *group=[[item elementForName:@"group"] stringValue];
                if (group == nil || [group isEqualToString:@""]) {
                    group = @"好友列表";
                }
                
                NSString * jidStr = [[item attributeForName:@"jid"] stringValue];
                UserInfo *entity = [self fetchUserFromJid:jidStr];
                if (entity != nil) {
                    entity.userGroup = group;
                    entity.userSubscription = [[item attributeForName:@"subscription"] stringValue];
                    entity.userName = [[item attributeForName:@"name"] stringValue];
                    
                    [self.managedObjectContext save:nil];
                    
                }else{
                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo"inManagedObjectContext:self.managedObjectContext];
                    [newManagedObject setValue:group forKey:@"userGroup"];
                    [newManagedObject setValue:[[item attributeForName:@"name"] stringValue] forKey:@"userName"];
                    [newManagedObject setValue:[[item attributeForName:@"jid"] stringValue] forKey:@"userJid"];
                    [newManagedObject setValue:[[item attributeForName:@"subscription"] stringValue] forKey:@"userSubscription"];
                    
                    // Save the context.
                    NSError * error;
                    if (![self.managedObjectContext save:&error]) {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
            }
            
        }
        
        
    }else{
    
    }
    return YES;
    
}

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil) {
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
}

//发送添加好友请求
-(void)addFrindFromUsers:(NSString *)jid{
    [xmppRoster addUser:[XMPPJID jidWithString:jid] withNickname:nil];
}


//处理添加好友的请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    NSLog(@"didReceiveBuddyRequest presence=[%@]",presence);
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
    NSString *nick =[user nickname];
	NSString *body = nil;
    [[NSUserDefaults standardUserDefaults]setObject:jidStrBare forKey:@"rosterJID"];
	
	if ([nick isEqualToString:@""])
    {
        nick=@"不详";
    }
    if ([displayName isEqualToString:@""])
    {
        displayName=@"不详";
    }
    body = [NSString stringWithFormat:@"姓名:%@\n昵称:%@\nID:%@",nick,displayName,jidStrBare];
    
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
        //[self playNewMsgAudio];
	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求添加为好友"
                                                        message:body
                                                       delegate:self
                                              cancelButtonTitle:@"拒绝"
                                              otherButtonTitles:@"同意", nil];
        alert.tag=10009;
        NSArray *subViewArray = alert.subviews;
        int labelCount=0;
        
        for (UILabel *label in subViewArray)
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                labelCount++;
                if (labelCount>1){
                    label.textAlignment=UITextAlignmentLeft;
                }
            }
        }
        [alert show];
        
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"知道了";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        [localNotification release];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10009)
    {
        NSString *rosterJID =[[[NSUserDefaults standardUserDefaults]objectForKey:@"rosterJID"] mutableCopy];
        if (buttonIndex==0)
        {
            [xmppRoster rejectPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:rosterJID]];
            
        }else if (buttonIndex==1)
        {
            [xmppRoster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithString:rosterJID] andAddToRoster:YES];
            
        }
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rosterJID"];
        [rosterJID release];
    }
    
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    NSUserDefaults* userDefaluts = [NSUserDefaults standardUserDefaults];
    NSString* loginUserStr1  = [userDefaluts objectForKey:@"LoginUser"];
    oldLoginUser = [userDefaluts objectForKey:@"oldLoginUser"];
    if (_managedObjectContext != nil  && loginUserStr1 != nil && [loginUserStr1 isEqualToString:oldLoginUser]) {
        return _managedObjectContext;
    }
    [userDefaluts setValue:loginUserStr1 forKey:@"oldLoginUser"];
    [userDefaluts synchronize];
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XMPP_Model" withExtension:@"momd"];
    if (modelURL == nil) {
        NSLog(@" 数据库模板地址为空");
    }
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSUserDefaults * userDefaluts = [NSUserDefaults standardUserDefaults];
    
    NSString* version =  [userDefaluts objectForKey:@"XMPPDataVersion"];
     NSString* loginUser = [userDefaluts objectForKey:@"LoginUser"];
    
    //oldLoginUser 用来判断数据切换的用户是否相同
    if (_persistentStoreCoordinator != nil && [oldLoginUser  isEqualToString:loginUser]) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: [NSString stringWithFormat:@"XMPPIM_%@.sqlite",loginUser]];
    NSError *error = nil;
    
    
    oldLoginUser = loginUser;
    
    
    //先判断数据库是否需要做删除
    if (([version intValue] != kXMPPDataVersion   && kXMPPDataVersion > [version floatValue])) {
        NSString* host = [userDefaluts objectForKey:@"XMPPHost"];
        //删除数据库文件
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtURL:storeURL  error:&error] != YES){
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }else{
            NSLog(@"删除数据库成功");
        }
        host = [xmppStream hostName];
        version = [NSString stringWithFormat:@"%d",kXMPPDataVersion];
        [userDefaluts setValue:version forKey:@"XMPPDataVersion"];
        [userDefaluts setValue:host forKey:@"XMPPHost"];
        [userDefaluts synchronize];
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
