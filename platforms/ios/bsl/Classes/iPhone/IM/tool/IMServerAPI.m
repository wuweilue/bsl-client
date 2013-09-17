//
//  IMServerAPI.m
//  cube-ios
//
//  Created by dong on 13-9-17.
//
//

#import "IMServerAPI.h"
#import "AFAppDotNetAPIClient.h"

@implementation IMServerAPI

-(void)collectIMFriend:(UserInfo*)user myJid:(NSString*)_myJid block:(void (^)(BOOL statue))_block{
    NSString* urlStr = @"";
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:user.userJid forKey:@"jid"];
    [parameters setValue:user.userName forKey:@"username"];
    [parameters setValue:user.userSex forKey:@"sex"];
    [parameters setValue:user.userStatue forKey:@"statue"];
    [parameters setValue:_myJid forKey:@"userId"];
    [[AFAppDotNetAPIClient sharedClient]getPath:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _block(true);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _block(false);
    }];
}

-(void)updateCollectIMFriendStatue:(UserInfo*)user block:(void (^)(BOOL statue))_block{
    NSString* urlStr = @"";
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:user.userStatue forKey:@"statue"];
    [parameters setValue:user.userJid forKey:@"jid"];
    [[AFAppDotNetAPIClient sharedClient]getPath:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _block(true);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _block(false);
    }];
}


-(void)getCollectIMFriends:(NSString*)myUserId block:(void (^)(BOOL statue,NSArray* friends))_block{
    NSString* urlStr = @"";
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:myUserId forKey:@"userId"];
    [[AFAppDotNetAPIClient sharedClient]getPath:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* friends = responseObject;
        _block(true,friends);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _block(false,nil);
    }];
}


-(void)deleteCollectIMFriend:(NSString*)myUserId deleteUser:(UserInfo*)_delUserInfo block:(void (^)(BOOL statue))_block{
    NSString* urlStr = @"";
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:myUserId forKey:@"userId"];
    [parameters setValue:_delUserInfo.userJid forKey:@"jid"];
    [[AFAppDotNetAPIClient sharedClient]getPath:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         _block(true);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _block(false);
    }];
}






@end
