//
//  XMPPActor.m
//  AMP
//
//  Created by Mr Right on 12-9-12.
//
//

#import "XMPPActor.h"
#import "XmppMessge.h"
#import "UIDevice+IdentifierAddition.h"
#import "XMPPMessage+XEP_0184.h"
#import "AppDatabase.h"
#import "ChatMessage.h"
#import "AJNotificationView.h"
#import "ASIHTTPRequest.h"
#import "MessageRecord.h"

@interface XMPPActor ()

- (void)teardownStream;
- (void)goOnline;
- (void)goOffline;
@end

@implementation XMPPActor


@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppvCardStorage;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppSearchModule;
@synthesize pubSub;
@synthesize delegate;
//@synthesize internetReachable;
@synthesize allowSelfSignedCertificates;
@synthesize allowSSLHostNameMismatch;
@synthesize database;
@synthesize rosterTableViewController ;
@synthesize password;
@synthesize searchUserBlock;
@synthesize xmppMUC;
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

- (id)initWithDelegate:(id<XmppActorDelegate>)ad
{
    self = [super init];
    if (self)
    {
        delegate = ad;
        // [self localTest];
    }
    return self;
}


- (void) dealloc
{
    [self teardownStream];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupXmppStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
	// Setup Database
	[self setupDatabase];
    // Setup reconnect
	xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
	{
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage: xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    //Setup xmppSearchModule
    xmppSearchModule =[[XMPPSearchModule alloc]initWithDispatchQueue:dispatch_get_current_queue()];
    xmppSearchModule.searchHost =@"search.snda-192-168-2-32";
    
    //Setup XMPPMUC
    xmppMUC =[[XMPPMUC alloc]initWithDispatchQueue:dispatch_get_current_queue()];
    
    
	[xmppRoster            activate:xmppStream];
    [xmppSearchModule activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    [xmppMUC activate:xmppStream];
    [xmppReconnect         activate:xmppStream];
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppSearchModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppMUC addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
    
    [self connect];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name: kReachabilityChangedNotification
//                                               object: nil];
//    
//    hostReach = [Reachability reachabilityWithHostName: kXMPPHost];
//    [hostReach startNotifier];
    [xmppReconnect setAutoReconnect:YES];

}

-(void)setupDatabase
{
    // setup database
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    self.database = [[AppDatabase alloc] initWithMigrations];
    // create table Message when not exist in database
    if (![[self database] checkTableWithName: @"ChatMessage"])
    {
        [[self database] createMyTable];
    }
}

- (void)teardownStream
{
    [self goOffline];
	[xmppStream removeDelegate:self];
    [xmppSearchModule removeDelegate:self];
    [xmppRoster removeDelegate:self];
    [xmppMUC removeDelegate:self];
    
	[xmppReconnect         deactivate];
	[pubSub deactivate];
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	[xmppSearchModule deactivate];
	[xmppStream disconnect];
    [xmppMUC deactivate];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
    xmppSearchModule = nil;
    xmppMUC =nil;

}


- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
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


- (BOOL)connect
{
	if ([xmppStream isConnected])
    {
		return YES;
	}
  
    NSString *uniqueDeviceIdentifier = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSLog(@"DeviceUUID=[%@]",uniqueDeviceIdentifier);
    
    password= [NSString stringWithFormat:@"%@",uniqueDeviceIdentifier];
    NSString *userId =[NSString stringWithFormat:@"%@",uniqueDeviceIdentifier];
//    password= [NSString stringWithFormat:@"%@",@"123"];
//    NSString *userId =[NSString stringWithFormat:@"%@",@"yanghui"];

    userId = [userId stringByAppendingFormat:@"@%@",kXMPPDomin];
    
     [xmppStream setMyJID:[XMPPJID jidWithString:userId resource:@"AndroidpnClient"]];
    
    [xmppStream setHostName:kXMPPHost];
	[xmppStream setHostPort:kXMPPPort];
    
    if (userId == nil || password == nil)
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
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
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
  DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	isXmppConnected = YES;
	
    NSError *error=nil;
    if (![[self xmppStream] authenticateWithPassword:password error:&error])
    {
        [self connect];
    }
//    if (![[self xmppStream] registerWithPassword:password error:&error])
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"网络繁忙,设备注册失败,请稍后再试"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//     
//    }
    
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"认证通过");
	[self goOnline];
    [self doRegisterPushService];
    
}

- (void)doRegisterPushService{

    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:[NSString stringWithFormat:@"%@@%@",[[UIDevice currentDevice] uniqueDeviceIdentifier],kXMPPDomin] forKey:@"tokenId"];
    
    [json setObject:kAPPName forKey:@"applicationId"];
    
    [json setObject:@"Openfire" forKey:@"deviceChannel"];
    
    [json setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"deviceId"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONReadingMutableContainers error:nil];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kPushServerRegisterUrl]];
    
    [request appendPostData:jsonData];
    
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    if (![[self xmppStream] registerWithPassword:password error:nil])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"网络繁忙,设备注册失败,请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
  DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
     NSLog(@"认证不通过,错误信息为:%@",error);

}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSError *error=nil;
    if (![[self xmppStream] authenticateWithPassword:password error:&error])
    {
        [self connect];
    }
    NSLog(@"创建账号成功");
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
   NSLog(@"创建账号失败");
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq elementID]);

    NSString *Meg =[[NSString alloc]initWithFormat:@"%@",iq];
    if (![Meg isEqualToString:@""])
    {
        XmppMessge *xmPPMsg = [[XmppMessge alloc]init];
        [xmPPMsg parseResponse:Meg];
    }
    
	NSLog(@"didReceiveIQ: %@", iq);
	
	return NO;
}

-(void)showLocalNotification:(NSString*)Msg
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertAction = @"知道了";
    //		localNotification.alertBody = aMsg;
    localNotification.alertBody = Msg;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
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
	}
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    //如果是由cube_dmin发送过来的则是推送的消息
    if([[message fromStr] hasPrefix:[NSString stringWithFormat:@"%@@%@",kXMPPPusher,kXMPPDomin]]){
    
        [MessageRecord createByJSON:[[message elementForName:@"body"] stringValue]];
    
        return;
    }
    
    
	if ([message isChatMessageWithBody])
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                                  xmppStream:xmppStream
                                                        managedObjectContext:[self managedObjectContext_roster]];
		
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *jidStr = [user jidStr];
        
        // save into database
        ChatMessage *msg = [[ChatMessage alloc] init];
        msg.direction = 0;
        msg.receiver = xmppStream.myJID.bare;
        msg.sender = jidStr;
        msg.content = body;
        msg.time = [[NSDate date] timeIntervalSince1970];
        [msg save];
        //播放声音
        [self playNewMsgAudio];
        //消失消息
        NSString *showMsg =[NSString stringWithFormat:@"%@说:%@",[self InterceptionName:msg.sender],msg.content];
        [self showTheNewChatMsg:showMsg];
        //聊天界面
        if (rosterTableViewController)
        {
            [rosterTableViewController newMsgCome];
        }
	}
}


- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    NSLog(@" presence=[%@]",presence);

}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	 NSLog(@" error=[%@]",error);
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags;
{
    NSLog(@"网络断开-----连接丢失[%d]",connectionFlags);
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags;
{
    //[self connect];
    // [xmppReconnect setAutoReconnect:YES];
    NSLog(@"尝试重连---------[%d]",reachabilityFlags);
    return YES;
}

/////search 
- (void)searchModel:(XMPPSearchModule*)searchModul result:(XMPPSearchReported*)result userData:(id)userData
{
    NSLog(@"search result : %@", result.items );
    if (searchUserBlock) {
        searchUserBlock(result.items);
    }
}

- (void)searchModelGetFields:(XMPPSearchModule *)searchModul
{
    NSLog(@"Get fields : %@", searchModul.result);
    [searchModul.result copyForSingleFields];
}

-(void)askForFiled
{
    [xmppSearchModule askForFields];

}
-(void)userSearch:(NSString*)aValue
{
    NSLog(@"search name=[%@]",aValue);
//    XMPPSearchSingleNode *search = [[XMPPSearchSingleNode alloc] init];
//    XMPPSearchBoolNode *name = [[XMPPSearchBoolNode alloc] init];
//    name.name = @"Username";
//    name.boolValue = YES;
//    
//    search.name = @"search";
//    search.value = aValue;
//
//    [xmppSearchModule searchWithFields:@[search,name]
//                           userData:nil];
    XMPPSearchStringSingleNode *search = [[XMPPSearchStringSingleNode alloc] init];
    search.value = aValue;
    search.name = @"search";
    
    XMPPSearchBoolNode *name = [[XMPPSearchBoolNode alloc] init];
    name.name = @"Username";
    name.boolValue = YES;
    
    [xmppSearchModule searchWithFields:@[search, name]
                           userData:nil];
}

////MUC

- (void)xmppMUC:(XMPPMUC *)sender didReceiveRoomInvitation:(XMPPMessage *)message
{
    NSLog(@"didReceiveRoomInvitation-[%@]=",message);
    NSString *reason =[message stringValue];
    NSString *roomName =[NSString stringWithFormat:@"来自%@的会议室", [message fromStr]];
    [[NSUserDefaults standardUserDefaults]setObject:[message fromStr] forKey:@"roomName"];
    [self alartRoomInvite:reason andTitle:roomName];
}
- (void)xmppMUC:(XMPPMUC *)sender didReceiveRoomInvitationDecline:(XMPPMessage *)message
{
    NSLog(@"didReceiveRoomInvitationDecline-[%@]=",message);
    NSString *reason =[message stringValue];
    NSString *roomTitle =@"拒绝了你的会议邀请";
    [self alartRoomInvite:reason andTitle:roomTitle];
}

-(void)alartRoomInvite:(NSString*)msg andTitle:(NSString*)title
{
    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"拒绝"
                                          otherButtonTitles:@"同意", nil];
    alert.style = GRAlertStyleInfo;
    alert.animation=1;
    alert.tag=10008;
    [alert show];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
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
        [self playNewMsgAudio];
	    GRAlertView *alert = [[GRAlertView alloc] initWithTitle:@"请求添加为好友"
                                                        message:body
                                                       delegate:self
                                              cancelButtonTitle:@"拒绝"
                                              otherButtonTitles:@"同意", nil];
        alert.style = GRAlertStyleInfo;
        alert.animation=1;
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
    }
    
    if (alertView.tag==10008)
    {
        if (buttonIndex==0)
        {
            NSLog(@"拒绝");
        }else
        {
            NSLog(@"同意");
            [self goForAchatRoom];
        }
    }
}

-(void)goForAchatRoom
{ 
    RoomChatViewController *chatRoom =nil;
    if (isiPad)
    {
        chatRoom=[[RoomChatViewController alloc]initWithNibName:@"RoomChatViewController_iPad" bundle:nil];
    }else
    {
       chatRoom=[[RoomChatViewController alloc]initWithNibName:@"RoomChatViewController_iPhone" bundle:nil];
    }
    chatRoom.joinAchatRoomName =[[[NSUserDefaults standardUserDefaults]objectForKey:@"roomName"]mutableCopy];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatRoom];
        [window.rootViewController presentModalViewController:nav animated:YES];
    
    
}
-(void)playNewMsgAudio
{
    NSString *path = [NSString stringWithFormat: @"%@/%@",
                      [[NSBundle mainBundle] resourcePath], @"NewMsg.caf"];
    
    NSURL* filePath = [NSURL fileURLWithPath: path isDirectory: NO];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
}

-(void)showTheNewChatMsg:(NSString*)Msg
{
    	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
    if (isiPad)
    {
        float msgOffset;
        if ([self isHeightChange])
        {
            msgOffset=0;
        }else
        {
            msgOffset=20;
        }
        [AJNotificationView showNoticeInView:[(AppDelegate *)[[UIApplication sharedApplication] delegate] window].rootViewController.view
                                        type:AJNotificationTypeGreen
                                       title:Msg
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2 offset:msgOffset];
    }else
    {
        [AJNotificationView showNoticeInView:[(AppDelegate *)[[UIApplication sharedApplication] delegate] window].rootViewController.view
                                        type:AJNotificationTypeGreen
                                       title:Msg
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:2];
    }
        }else
        {
            [self showLocalNotification:Msg];
        }
}

-(BOOL)isHeightChange
{
     if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] window].rootViewController.view.frame.size.width==748)
     {
         return YES;
     }else
    {
        return NO;
    }
}

-(NSString*)InterceptionName:(NSString*)fullName
{
    NSArray *array = [fullName componentsSeparatedByString:@"@"];
    NSString *peer=(NSString*)[array objectAtIndex:0];
    return peer;
}
-(NSString*)myJIDStr
{
    NSString *jid =[[[[ShareAppDelegate xmpp]xmppStream]myJID]bare];
    return jid;
}

//-(void)reachabilityChanged:(NSNotification*)note
//{
//    Reachability * reach = [note object];
//    
//    if([reach isReachable])
//    {
//        NSLog( @"Notification Says 网络可用");
//    }
//    else
//    {
//        
//		if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
//		{
//			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//			localNotification.alertAction = @"知道了";
//            localNotification.soundName = UILocalNotificationDefaultSoundName;
//			localNotification.alertBody = @"无可用网络，ICube连接已断开，请重新登录客户端";
//            
//			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//		}else
//        {
//            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发生错误"
//            //                                                                message:@"无可用网络，连接已断开"
//            //                                                               delegate:nil
//            //                                                      cancelButtonTitle:@"关闭"
//            //                                                      otherButtonTitles:nil];
//            //			[alertView show];
//            //            [alertView release];
//        }
//        
//        NSLog( @"Notification Says 网络不可用");
//        [xmppStream.asyncSocket disconnect];
//    }
//}
@end
