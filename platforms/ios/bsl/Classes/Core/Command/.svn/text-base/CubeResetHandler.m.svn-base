//
//  CubeResetHandler.m
//  Cube-iOS
//
//  Created by Justin Yip on 2/2/13.
//
//

#import "CubeResetHandler.h"
#import "NSFileManager+Extra.h"

@implementation CubeResetHandler

-(BOOL)shouldHandleCommand:(NSString*)aCommand
{
    if (aCommand != NULL && [aCommand hasPrefix:@"reset"]) {
        return YES;
    } else {
        return NO;
    }
}

-(void)execute:(NSDictionary*)params
{
    [[params objectForKey:@"REQUEST"] boolValue];
    
    NSError *error = nil;
    
    NSURL *configURL = [[NSFileManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cube.json"];
    if ([FS fileExistsAtPath:[configURL absoluteString]]) {
        if(![FS removeItemAtURL:configURL error:&error]) {
            NSLog(@"重置失败！%@", error);
            return;
        }
    }
    
    NSURL *www = [NSFileManager wwwRuntimeDirectory];
    if ([FS fileExistsAtPath:[www absoluteString]]) {
        if(![FS removeItemAtURL:www error:&error]) {
            NSLog(@"重置失败！%@", error);
        }
    } else {
        UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"提示" message:@"平台重置成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msg show];
        [msg release];
    }
}

@end
