//
//  RoomService.m
//  cube-ios
//
//  Created by 肖昶 on 13-9-17.
//
//

#import "RoomService.h"
#import "XMPPRoom.h"
#import "XMPPRoomCoreDataStorage.h"


@implementation RoomService


-(id)init
{
    self =[super init];
    if (self)
    {
        
    }
    return self;
}


-(void)joinRoomServiceWithRoomID:(NSString*)roomID
{
    _room =[[XMPPRoom alloc]initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:[XMPPJID jidWithString:roomID]];
    [_room activate:[self getCurrentStream]];
    [_room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([_room preJoinWithNickname:[self getCurrentUserName]])
    {
        [_room joinRoomUsingNickname:[self getCurrentUserName] history:nil];
    }
    
    [self performSelector:@selector(ConfigureNewRoom:) withObject:_room afterDelay:0];
}


-(void)initRoomServce
{
    
    _room =[[XMPPRoom alloc]initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:[XMPPJID jidWithString:[self getGenerateUUID]]];
    [_room activate:[self getCurrentStream]];
    [_room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([_room preJoinWithNickname:[self getCurrentUserName]])
    {
        [_room joinRoomUsingNickname:[self getCurrentUserName] history:nil];
    }
    //    [self ConfigureNewRoom:_room];
    [self performSelector:@selector(ConfigureNewRoom:) withObject:_room afterDelay:1];
}

////配置room
-(void)ConfigureNewRoom:(XMPPRoom *)sender
{
    [sender fetchConfigurationForm];
    [sender configureRoomUsingOptions:nil];
    _roomID =[NSString stringWithFormat:@"%@",sender.myRoomJID.bare];
    _roomName=[NSString stringWithFormat:@"%@",sender.roomJID];
}

-(NSString*)getGenerateUUID
{
    XMPPStream *stream = [self getCurrentStream];
    NSString *newMUCStr =[NSString stringWithFormat:@"%@@%@",[stream generateUUID],kMUCSevericeDomin];
    return newMUCStr;
}

-(XMPPStream*)getCurrentStream
{
    XMPPStream *stream = [ShareAppDelegate xmpp].xmppStream;
    return stream;
}

-(NSString*)getCurrentUserName
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"username"];
}



-(void)dealloc
{
    [self tearDown];
    [super dealloc];
}

-(void)tearDown
{
    [_room removeDelegate:self];
    [_room deactivate];
    _room=nil;
}

#pragma RoomDelegate

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    if (_roomDidCreateBlock) {
        _roomDidCreateBlock(sender);
    }
}
- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult
{
    //    if([iqResult.type isEqualToString:@"result"])
    //    {
    //
    //    }
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    if (_roomDidJoinBlock) {
        _roomDidJoinBlock(sender);
    }
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    
    NSString* msg =[NSString stringWithFormat:@"%@,加入了会议室", [occupantJID bare]];
    NSLog(@"===[%@]",msg);
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    
}

- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult
{
    NSLog(@"认证失败");
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    NSLog(@"didFetchMembersList:[%@]",items);
}
- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    NSLog(@"didFetchBanList:[%@]",items);
}
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    NSLog(@"didFetchModeratorsList:[%@]",items);
}

@end
