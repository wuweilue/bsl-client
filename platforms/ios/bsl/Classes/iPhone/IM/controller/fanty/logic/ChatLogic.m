//
//  ChatLogic.m
//  cube-ios
//
//  Created by apple2310 on 13-9-7.
//
//

#import "ChatLogic.h"
#import "HTTPRequest.h"
#import "JSONKit.h"
#import "RectangleChat.h"

@interface ChatLogic()
@end

@implementation ChatLogic

-(void)dealloc{
    [request setFailedBlock:nil];
    [request setCompletionBlock:nil];
    [request cancel];

}

-(void)sendMessage:(NSString* )content chatWithUser:(NSString*)chatWithUser name:(NSString*)name{
    //拼写xml格式的xmpp消息
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:content];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message" ];
    //[message addAttributeWithName:@"type" stringValue:@"chat"];
    //消息发送者
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"from" stringValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare]];
    //消息接受者
    [message addAttributeWithName:@"to" stringValue:chatWithUser];
    [message addChild:body];
    NSLog(@"friendEntity.name:%@",chatWithUser);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    
    
    
    //新建消息的entity
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext:appDelegate.xmpp.managedObjectContext];
    
    NSXMLNode* subject = [NSXMLNode elementWithName:@"subject" stringValue:@"text"];//告诉接受方 传送的是文件 还是 聊天内容
    [message addChild:subject];
        
    [newManagedObject setValue:content forKey:@"content"];
    [newManagedObject setValue:@"text" forKey:@"type"];
        
    [newManagedObject setValue:[NSDate date] forKey:@"sendDate"];
    [newManagedObject setValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare] forKey:@"sendUser"];
    [newManagedObject setValue:chatWithUser forKey:@"receiver"];
    [newManagedObject setValue:[NSDate date] forKey:@"receiveDate"];

    [appDelegate.xmpp newRectangleMessage:chatWithUser name:name  content:content contentType:RectangleChatContentTypeMessage isGroup:NO];
    [appDelegate.xmpp saveContext];


    
    //XMPPElementReceipt *receipt;
    //发送消息
    [appDelegate.xmpp.xmppStream sendElement:message];
}

-(void)sendfile:(NSString* )content path:(NSString*)path chatWithUser:(NSString*)chatWithUser name:(NSString*)name{
    //拼写xml格式的xmpp消息
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:content];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message" ];
    //[message addAttributeWithName:@"type" stringValue:@"chat"];
    //消息发送者
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"from" stringValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare]];
    //消息接受者
    [message addAttributeWithName:@"to" stringValue:chatWithUser];
    [message addChild:body];
    NSLog(@"friendEntity.name:%@",chatWithUser);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //新建消息的entity
    
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext:appDelegate.xmpp.managedObjectContext];
    
    NSXMLNode* subject = [NSXMLNode elementWithName:@"subject" stringValue:@"image"];//告诉接受方 传送的是文件 还是 聊天内容
    [message addChild:subject];
    [newManagedObject setValue:path forKey:@"content"];
    [newManagedObject setValue:@"image" forKey:@"type"];
    [newManagedObject setValue:[NSDate date] forKey:@"sendDate"];
    [newManagedObject setValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare] forKey:@"sendUser"];
    [newManagedObject setValue:chatWithUser forKey:@"receiver"];

    [appDelegate.xmpp newRectangleMessage:chatWithUser name:name content:content contentType:RectangleChatContentTypeImage isGroup:NO];
    [appDelegate.xmpp saveContext];

    
    
    //XMPPElementReceipt *receipt;
    //发送消息
    [appDelegate.xmpp.xmppStream sendElement:message];
}


-(void)sendVoice:(NSString* )content urlVoiceFile:(NSURL*)urlVoiceFile chatWithUser:(NSString*)chatWithUser name:(NSString*)name{
    //拼写xml格式的xmpp消息
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:content];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message" ];
    //[message addAttributeWithName:@"type" stringValue:@"chat"];
    //消息发送者
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"from" stringValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare]];
    //消息接受者
    [message addAttributeWithName:@"to" stringValue:chatWithUser];
    
    [message addChild:body];
    NSLog(@"friendEntity.name:%@",chatWithUser);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //新建消息的entity
    
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext:appDelegate.xmpp.managedObjectContext];
    
    NSXMLNode* subject = [NSXMLNode elementWithName:@"subject" stringValue:@"voice"];//告诉接受方 传送的是文件 还是 聊天内容
    [message addChild:subject];
        
    [newManagedObject setValue:[urlVoiceFile absoluteString] forKey:@"content"];
    [newManagedObject setValue:@"voice" forKey:@"type"];
    [newManagedObject setValue:[NSDate date] forKey:@"sendDate"];
    [newManagedObject setValue:[[[[ShareAppDelegate xmpp]xmppStream] myJID]bare] forKey:@"sendUser"];
    [newManagedObject setValue:chatWithUser forKey:@"receiver"];
    
    
    [appDelegate.xmpp newRectangleMessage:chatWithUser name:name content:content contentType:RectangleChatContentTypeVoice isGroup:NO];
    [appDelegate.xmpp saveContext];

    //XMPPElementReceipt *receipt;
    //发送消息
    [appDelegate.xmpp.xmppStream sendElement:message];
}

-(BOOL)isInFaviorContacts:(NSString*)chatWithUser{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userJid == \"%@\"",chatWithUser]];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FaviorUserInfo"];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedPersonArray = [appDelegate.xmpp.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return ([fetchedPersonArray count]>0);
}

-(void)addFaviorInContacts:(NSString*)chatWithUser{

    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    UserInfo* userInfo=[appDelegate.xmpp fetchUserFromJid:chatWithUser];
    
    NSManagedObject *newManagedObject=[NSEntityDescription insertNewObjectForEntityForName:@"FaviorUserInfo" inManagedObjectContext:appDelegate.xmpp.managedObjectContext];
    
    [newManagedObject setValue:userInfo.userGroup forKey:@"userGroup"];
    [newManagedObject setValue:userInfo.userName forKey:@"userName"];
    [newManagedObject setValue:userInfo.userJid forKey:@"userJid"];
    [newManagedObject setValue:userInfo.userSubscription forKey:@"userSubscription"];
    [newManagedObject setValue:userInfo.userSex forKey:@"userSex"];
    [newManagedObject setValue:userInfo.userStatue forKey:@"userStatue"];
    
    [appDelegate.xmpp saveContext];
}

-(void)removeFaviorInContacts:(NSString*)chatWithUser{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FaviorUserInfo"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userJid == \"%@\"",chatWithUser]];
    NSError *error=nil;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext* context=[appDelegate xmpp].managedObjectContext;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:&error];
    if(!error){
        for(id obj in fetchResult){
            [context deleteObject:obj];
        }
    }
    [appDelegate.xmpp saveContext];

}


-(void)uploadImageToServer:(UIImage*)image finish:(void (^)(NSString* id,NSString* path))finish{
    [request setFailedBlock:nil];
    [request setCompletionBlock:nil];
    [request cancel];
    
    @autoreleasepool {
        NSData *imageData = UIImagePNGRepresentation(image);
         NSString* token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSURL *requestURL = [NSURL URLWithString:[kFileUploadUrl stringByAppendingFormat:@"?sessionKey=%@&&appKey=%@",token,kAPPKey]];
  
        request = [FormDataRequest requestWithURL:requestURL];
        request.delegate = self;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dict setObject:imageData forKey:@"file"];
        [request setUserInfo:dict];
        [request setData:imageData forKey:@"file"];

        [request setCompletionBlock:^{
            
            [request setFailedBlock:nil];
            
            NSString *resultStr = [request responseString];
            NSData *imageData = [[request userInfo] valueForKey:@"file"];
            NSDictionary *dict = [resultStr objectFromJSONString];
            NSString *fileId = [dict valueForKey:@"id"];
            NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"sendFiles"];
            NSFileManager *manager = [NSFileManager defaultManager];
            if(![manager fileExistsAtPath:path]){
                [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            path = [[path stringByAppendingPathComponent:fileId] stringByAppendingString:@".png"];
            
            [imageData writeToFile:path atomically:YES];
                    
            if(finish!=nil)
                finish(fileId,path);
            
            request=nil;
        }];
        
        [request setFailedBlock:^{
            [request setCompletionBlock:nil];
            if(finish!=nil)
                finish(nil,nil);
            request=nil;
        }];
        
        [request startAsynchronous];
    
    }
}


@end
