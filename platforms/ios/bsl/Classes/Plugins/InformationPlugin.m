
//  InformationPlugin.m
//  cube-ios
//
//  Created by hibad(Alfredo) on 13/3/18.
//
//

#import "InformationPlugin.h"
#import "JSONKit.h"
#import "UIDevice+IdentifierAddition.h"

@implementation InformationPlugin

- (void)getInformation:(CDVInvokedUrlCommand*)command{
    @autoreleasepool {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSString *username = [defaults objectForKey:@"username"];
        NSString *token = [defaults objectForKey:@"token"]; 
        //设备类型
        NSString *device;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            device = @"iPhone";
        }else{
            device = @"iPad";
        }
        //系统版本
        NSString *osVersion = [[UIDevice currentDevice] systemVersion];
        //应用版本
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        //应用identifier/build
        NSString *app = [[NSBundle mainBundle] bundleIdentifier];

        NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        NSMutableDictionary *json = [NSMutableDictionary dictionary];
        [json setValue:token forKey:@"token"];
        [json setValue:device forKey:@"device"];
        [json setValue:osVersion forKey:@"osVersion"];
        [json setValue:appVersion forKey:@"appVersion"];
        [json setValue:app forKey:@"app"];
        [json setValue:build forKey:@"build"];
        [json setValue:kAPPKey forKey:@"appKey"];
        [json setValue:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"deviceId"];
        
        [json setValue:[defaults objectForKey:@"loginUsername"] forKey:@"username"];
        [json setValue:[defaults objectForKey:@"loginPassword"] forKey:@"password"];
        
        CDVPluginResult* pluginResult = nil;
        
        if (json) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:json];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
    }
}

@end
