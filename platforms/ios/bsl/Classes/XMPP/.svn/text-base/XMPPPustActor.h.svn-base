//
//  XMPPPustActor.h
//  cube-ios
//
//  Created by 东 on 13-3-23.
//
//

#import <Foundation/Foundation.h>

#import "XMPP.h"
#import "XMPPReconnect.h"

@interface XMPPPustActor : NSObject<XMPPStreamDelegate>{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    
    NSString * passWord;
    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
    
    BOOL isXmppConnected;
    BOOL isRegister;

}
@property(nonatomic,retain) XMPPStream* xmppStream;

-(void)setXmppStream;

-(void)teardownStream;

@end
