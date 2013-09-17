//
//  CallPhonePlugin.m
//  cube-ios
//
//  Created by 东 on 13-4-10.
//
//

#import "CallPhonePlugin.h"
#import "AppDelegate.h"

@interface CallPhonePlugin(){
    NSString* telPhoneNum;
}
@end


@implementation CallPhonePlugin

-(void)callPhoneNum:(CDVInvokedUrlCommand *)command{
    NSArray* array =  command.arguments;
    UIAlertView* alertView =  [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否拨打%@ ？", [array objectAtIndex:0]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
    [alertView release];
    
    [telPhoneNum release];
    telPhoneNum= [[NSString stringWithFormat:@"tel://%@", [array objectAtIndex:0]] retain];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1 ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telPhoneNum]];
        [telPhoneNum release];
        telPhoneNum=nil;
    }
}

@end
