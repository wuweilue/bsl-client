//
//  DES.h
//  Mcs
//
//  Created by Zhang Xiongjie on 9/6/10.
//  Copyright 2010 RYTong. All rights reserved.
//

#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface DES : NSObject {
    
}

+ (NSData *) doEncryptWithStringAndData:(NSString *)plainText key:(NSData *)key;

+ (NSData *) doDecryptWithStringAndData:(NSString *)cipherText key:(NSData *)key;

+ (NSData *) doEncryptWithData:(NSData *)plainData key:(NSData *)key;

+ (NSData *) doEncryptWithString:(NSString *)plainData key:(NSString *)key;

+ (NSData *) doDecryptWithData:(NSData *)cipherData key:(NSData *)key;

+ (NSData *) doDecryptWithString:(NSString *)cipherString key:(NSString *)key;

+ (NSData *) doDecryptWithData:(NSData *)cipherData keyStr:(NSString *)keyStr;

+ (NSData *) doCipher:(NSData *)plainText key:(NSData *)symmetricKey context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7;


@end


