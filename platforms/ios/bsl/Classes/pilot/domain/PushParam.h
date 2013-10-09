//
//  PushParam.h
//  pilot
//
//  Created by wuzheng on 9/26/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushParam : NSObject{
    NSString            *pushToken;
    NSString            *pushWorkNo;
    NSString            *pushType;
}

@property (nonatomic, retain) NSString *pushToken;
@property (nonatomic, retain) NSString *pushWorkNo;
@property (nonatomic, retain) NSString *pushType;

@end
