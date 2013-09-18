//
//  LocalDBPlugin.h
//  cube-ios
//
//  Created by chen shaomou on 4/11/13.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface LocalDBPlugin : CDVPlugin

-(void)executeQuery:(CDVInvokedUrlCommand*)command;

@end
