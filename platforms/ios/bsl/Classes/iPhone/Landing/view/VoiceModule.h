//
//  VoiceModule.h
//  TestVoiceView
//
//  Created by Mr.幸 on 12-12-8.
//  Copyright (c) 2012年 Mr.幸. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceModule : NSObject

@property (nonatomic,copy) NSString* module;
@property (nonatomic,copy) NSString* fileName;
@property (nonatomic,copy) NSString* url;
@property (nonatomic,copy) NSURL* localUrl;
@property (nonatomic,copy) NSString* dateAndtime;
@property (nonatomic,assign) BOOL isUser;

@end
