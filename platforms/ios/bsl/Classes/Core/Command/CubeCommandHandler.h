//
//  CubeCommand.h
//  Cube-iOS
//
//  Created by Justin Yip on 12/8/12.
//
//

#import <Foundation/Foundation.h>

@protocol CubeCommandHandler <NSObject>

-(BOOL)shouldHandleCommand:(NSString*)aCommand;

-(void)execute:(NSDictionary*)params;

@end
