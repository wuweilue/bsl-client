//
//  voiceIQ.m
//  cube-ios
//
//  Created by 东 on 13-4-1.
//
//

#import "voiceIQ.h"
#import "XMPPIQ.h"
#import "NSXMLElement+XMPP.h"

@implementation voiceIQ

+(XMPPIQ *)createFileRequest:(NSString*)filePath fileName:(NSString*)fileName fileType:(NSString*)type fileSize:(NSString*)size to:(NSString*)toUserJid  from:(NSString* )fromUerid{
    
    XMPPIQ * iq = [[XMPPIQ alloc]init];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addAttributeWithName:@"to" stringValue:toUserJid];
//    [iq addAttributeWithName:@"xmlns" stringValue:@"jabber:client"];
//    [iq addAttributeWithName:@"from" stringValue:fromUerid];
    [iq addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"iq_%ld",random()]];//创建一个随机数作为ID

    //组装si xml结构
    NSXMLElement* siNode = [NSXMLElement elementWithName:@"si" xmlns:@"http://jabber.org/protocol/si"];
    [siNode addAttributeWithName:@"profile" stringValue:@"http://jabber.org/protocol/si/profile/file-transfer"];
    [siNode addAttributeWithName:@"id" stringValue:[NSString stringWithFormat:@"jsi_%ld",random()]];//创建一个随机数作为ID
    [siNode addAttributeWithName:@"mime-type" stringValue:type];

    
    NSXMLElement* file = [NSXMLElement elementWithName:@"file" xmlns:@"http://jabber.org/protocol/si/profile/file-transfer"];
    [file addAttributeWithName:@"name" stringValue:fileName];
    [file addAttributeWithName:@"size" stringValue:size];
    
    
    NSXMLNode* desc = [NSXMLNode elementWithName:@"desc" stringValue:@"Sending file"];
    [file addChild:desc];
    [siNode addChild:file];
    
    NSXMLElement* feature  = [NSXMLElement elementWithName:@"feature" xmlns:@"http://jabber.org/protocol/feature-neg"];
    
    NSXMLElement* x =  [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"form"];
    
    NSXMLElement* field = [NSXMLElement elementWithName:@"field"  ];
    [field addAttributeWithName:@"var" stringValue:@"stream-method"];
    [field addAttributeWithName:@"type" stringValue:@"list-single"];
    
    NSXMLElement* option1 = [NSXMLElement elementWithName:@"option"];
    NSXMLNode* valueNode = [NSXMLNode elementWithName:@"value" stringValue:@"http://jabber.org/protocol/bytestreams"];
    [option1 addChild:valueNode];
    
    NSXMLElement* option2 = [NSXMLElement elementWithName:@"option"];
    NSXMLNode* valueNode2 = [NSXMLNode elementWithName:@"value" stringValue:@"http://jabber.org/protocol/ibb"];
    [option2 addChild:valueNode2];
    
    [field addChild:option1];
    [field addChild:option2];
    
    [x addChild:field];
    [feature addChild:x];
    [siNode addChild:feature];
    [iq addChild:siNode];
   

    return [iq autorelease];
}


@end
