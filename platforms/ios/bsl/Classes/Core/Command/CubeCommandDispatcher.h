//
//  CubeCommandDispatcher.h
//  Cube-iOS
//
//  Created by Justin Yip on 12/8/12.
//
//

#import <UIKit/UIKit.h>

@interface CubeCommandDispatcher : NSObject

@property(nonatomic,retain)NSArray *commands;

+(id)instance;

-(void)executeCommand:(NSDictionary*)command;

@end
