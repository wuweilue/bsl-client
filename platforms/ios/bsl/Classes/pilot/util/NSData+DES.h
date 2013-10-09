//
//  NSData+DES.h
//  pilot
//
//  Created by chen shaomou on 9/5/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (DES)

- (NSData *) doEncryptWithKey:(NSString *)key;
- (NSData *) doDecryptWithKey:(NSString *)key;

@end
