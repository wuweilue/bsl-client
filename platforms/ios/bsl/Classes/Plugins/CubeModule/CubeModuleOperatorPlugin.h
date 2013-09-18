//
//  CubeModuleOperatorPlugin.h
//  cube-ios
//
//  Created by 东 on 6/6/13.
//
//

#import <Cordova/CDVPlugin.h>

@interface CubeModuleOperatorPlugin : CDVPlugin{
    CDVInvokedUrlCommand* cdvCommand;
}

@property (nonatomic,strong)  CDVInvokedUrlCommand* cdvCommand;
@end
