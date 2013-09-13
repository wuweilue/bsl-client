#import "XMPP.h"

#ifdef HAVE_XMPP_SUBSPEC_RECONNECT
#import "XMPPReconnect.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0045
#import "XMPPMUC.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0054
#import "XMPPvCardTempModule.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0100
#import "XMPPTransports.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0115
#import "XMPPCapabilities.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0136
#import "XMPPMessageArchiving.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0153
#import "XMPPvCardAvatarModule.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0199
#import "XMPPAutoPing.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0199
#import "XMPPPing.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0202
#import "XMPPAutoTime.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0202
#import "XMPPTime.h"
#endif
