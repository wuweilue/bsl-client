//
//  CallPhonePlugin.h
//  cube-ios
//
//  Created by 东 on 13-4-10.
//
//

#import <Cordova/CDVPlugin.h>

@interface CallPhonePlugin : CDVPlugin<UIAlertViewDelegate>


- (void)callPhoneNum:(CDVInvokedUrlCommand*)command;


@end
