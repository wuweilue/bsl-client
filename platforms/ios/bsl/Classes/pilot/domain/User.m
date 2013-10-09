//
//  User.m
//  pilot
//
//  Created by wuzheng on 12/6/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "User.h"
#import "NSManagedObject+Repository.h"

@implementation User

@dynamic password;
@dynamic workNo;
@dynamic result;
@dynamic baseCode;
@dynamic pilotFlag;

+ (User *)currentUser{
    return [User first:@"workNo=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"default_user"]];
    
}

+ (void)setCurrentUser:(User *)user{
    
    [[NSUserDefaults standardUserDefaults] setValue:user.workNo forKey:@"default_user"];
    
}

-(BOOL)verifyPassword:(NSString *)enterPassword{
    
    if([self password] && enterPassword){
        
        return  [[self password] isEqualToString:enterPassword];
        
    }else{
        
        return FALSE;
    }
    
}

@end
