//
//  NSString+Verification.h
//  Mcs
//
//  Created by wuzheng on 11/3/11.
//  Copyright 2011 RYTong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_Verification)

-(BOOL)isPureInt:(NSString*)string;
-(BOOL)isIdCard;

-(NSString *)checkSpecChar;

-(BOOL)hasSpecChar; 

-(NSString *)clearSpecChar;

- (BOOL)isValidateddEmail;

- (BOOL)isValidatedPhoneNumber;

- (BOOL)isValidatedNumberString;

- (BOOL)isValidatedNumberStringWithLength:(NSUInteger)l;

- (BOOL)isDateString;

- (NSString *)encodeToPercentEscapeString;

@end
