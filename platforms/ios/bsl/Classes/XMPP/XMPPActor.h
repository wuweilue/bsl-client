//
//  XMPPActor.h
//  Cube-iOS
//
//  Created by Mr Right on 12-12-8.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import"XMPPPubSub.h"
#import "XMPPFramework.h"
//#import "Reachability.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "ConfigManager.h"
#import "RosterTableViewController.h"
#import "XMPPSearchModule.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import <CFNetwork/CFNetwork.h>
#import<AudioToolbox/AudioToolbox.h>
#import "GRAlertView.h"
#import "XMPPMUC.h"
#import "RoomChatViewController.h"
#import"UIViewController+YKPopViewController.h"

@class RosterTableViewController;
@class ChatViewController;
@class AppDatabase;

@protocol XmppActorDelegate <NSObject>

-(void)setupXmppSucces;
-(void)setupUnsucces;
-(void)setupError:(NSString*)aError;

@end

@interface XMPPActor : NSObject <  XMPPRosterDelegate,UIAlertViewDelegate>


{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPSearchModule *xmppSearchModule;
    XMPPMUC *xmppMUC;
    
    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    BOOL isRegister;

    NSString *password;
//    Reachability* hostReach;
    
}



@property (nonatomic,strong,readonly ) XMPPPubSub *pubSub;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readwrite) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic,strong,readonly)  XMPPSearchModule *xmppSearchModule;
@property(nonatomic,strong,readonly) XMPPMUC *xmppMUC;
@property (nonatomic) BOOL allowSelfSignedCertificates;
@property (nonatomic) BOOL allowSSLHostNameMismatch;
@property (nonatomic, strong) AppDatabase *database;
@property (nonatomic, strong) NSString *password;
@property (nonatomic,copy)void (^searchUserBlock)(NSArray*);

//@property (nonatomic,strong) Reachability *internetReachable;
@property (strong, nonatomic) RosterTableViewController *rosterTableViewController;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;
- (void)setupXmppStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;
-(void)userSearch:(NSString*)value;
-(void)askForFiled;
-(void)showTheNewChatMsg:(NSString*)Msg;
-(BOOL)isConnected;

@property(nonatomic,assign) id<XmppActorDelegate> delegate;

-(id)initWithDelegate:(id<XmppActorDelegate>) delegate;
@end
