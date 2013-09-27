//
//  UpdateChecker.m
//  AMP
//
//  Created by Justin Yip on 8/14/12.
//
//

#import "UpdateChecker.h"
#import "JSONKit.h"
#import "ServerAPI.h"
#import "HTTPRequest.h"

@implementation UpdateChecker
@synthesize delegate;
//@synthesize newApp;
@synthesize downloadUrl;

- (id)initWithDelegate:(id<CheckUpdateDelegate>)ad
{
    self = [super init];
    if (self) {
        delegate = ad;
    }
    return self;
}

-(void)dealloc
{
    [request clearDelegatesAndCancel];
//    self.newApp = nil;
    
}

-(void)check
{
    [request cancel];
    NSString* updateUrl = [ServerAPI urlForAppUpdate];
    updateUrl =  [updateUrl stringByAppendingString:[NSString stringWithFormat:@"&appKey=%@",kAPPKey]];
    request = [HTTPRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.delegate = self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest*)ar{
    id json = [[ar responseData] objectFromJSONData];
    if (json == nil || [json count]<1) {
        [self requestFailed:ar];
        return;
    }
    
    NSString* result=[json objectForKey:@"result"];
    if([result isEqualToString:@"error"]){
        [self requestFailed:ar];
        return;
    }
    
    //current
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSInteger currentBuild = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] integerValue];
    
    //new version
    NSInteger build = [[json objectForKey:@"build"] integerValue];
    NSString *version = [json objectForKey:@"version"];
    NSString *bundle = [json objectForKey:@"plist"];
    NSString *releaseNote = [json objectForKey:@"releaseNote"];
    
    self.downloadUrl = [ServerAPI urlForAttachmentId:bundle];
    if (currentBuild < build) {
        NSString *message = [NSString stringWithFormat:@"当前版本:%@\n最新版本:%@\n版本说明:\n%@", currentVersion, version, releaseNote];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:version forKey:@"newVersion"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:[ NSString stringWithFormat:@"%@平台版本更新",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ] message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
        [av show];
    } else {
        NSLog(@"没有更新");
        if (delegate) {
            [delegate updateUnavailable];
        }
    }
    request=nil;

}

-(void)requestFailed:(ASIHTTPRequest*)ar{
    request=nil;

    NSLog(@"更新出错:%@", [ar error]);
    if (delegate) {
        [delegate updateError:[ar error]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *urlString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", [NSString stringWithFormat:@"%@%@appKey%@%@",self.downloadUrl,@"%3F",@"%3D",kAPPKey]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        //发送更新记录
        //南航移动应用自有业务
        if([[[NSBundle mainBundle]bundleIdentifier]isEqualToString:@"com.csair.impc"])
        {
            [self updateDownloadRecord];
        }
        
    }
}
//下载完成后更新服务端计数
-(void)updateDownloadRecord
{
    NSString *version = [[NSUserDefaults standardUserDefaults] valueForKey:@"newVersion"];
    NSString *url = [ServerAPI urlForAppUpdateRecord];
    url = [[url stringByAppendingString:version]stringByAppendingFormat:@"?appKey=%@",kAPPKey ];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    request = [HTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setCompletionBlock:^{
        NSLog(@"[更新下载记录=success]");
        
    }];
    [request setFailedBlock:^{
        NSLog(@"更新下载记录失败");
        
    }];
    [request startAsynchronous];
    
}

@end
