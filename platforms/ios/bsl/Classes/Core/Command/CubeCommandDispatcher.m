//
//  CubeCommandDispatcher.m
//  Cube-iOS
//
//  Created by Justin Yip on 12/8/12.
//
//

#import "CubeCommandDispatcher.h"
#import "CubeCommandHandler.h"
#import "JSONKit.h"

@implementation CubeCommandDispatcher

@synthesize commands;

#pragma mark - Init

+(id)instance
{
    static CubeCommandDispatcher *instance;
    @synchronized(self) {
        if (nil == instance) {
            instance = [[CubeCommandDispatcher alloc] init];
        }
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSMutableArray *cmdArray = [[NSMutableArray alloc] init];
        
        NSURL *cmdConfigURL = [[NSBundle mainBundle] URLForResource:@"CubeCommands" withExtension:@"plist"];
        NSArray *commandClasses = [NSArray arrayWithContentsOfURL:cmdConfigURL];
        for (NSString *commandClass in commandClasses) {
            Class cls = NSClassFromString(commandClass);
            id<CubeCommandHandler> commandInstance = [[cls alloc] init];
            [cmdArray addObject:commandInstance];
            commandInstance=nil;
        }
        
        self.commands = cmdArray;
        cmdArray=nil;
        
    }
    return self;
}

-(void)executeCommand:(NSDictionary*)command
{
    NSString *commandString = [command objectForKey:@"command"];
    NSDictionary *commandPayload = [[command objectForKey:@"content"]objectFromJSONString];
    for (id<CubeCommandHandler> handler in self.commands)
    {
        if ([handler shouldHandleCommand:commandString])
        {
            [handler execute:commandPayload];
        }
    }
}

@end
