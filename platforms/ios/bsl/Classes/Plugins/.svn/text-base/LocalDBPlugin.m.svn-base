//
//  LocalDBPlugin.m
//  cube-ios
//
//  Created by chen shaomou on 4/11/13.
//
//

#import "LocalDBPlugin.h"
#import "MessageRecordManager.h"

@implementation LocalDBPlugin

-(void)executeQuery:(CDVInvokedUrlCommand*)command{

    NSString *sql = [command.arguments objectAtIndex:0];
        
    NSArray *resultSet = [[MessageRecordManager sharedMessageRecordManager] excuteQuery:sql];
    
    CDVPluginResult* pluginResult = nil;
    
    if (resultSet) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultSet];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


@end
