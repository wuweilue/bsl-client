//
//  NSData+DES.m
//  pilot
//
//  Created by chen shaomou on 9/5/12.
//  Copyright (c) 2012 chen shaomou. All rights reserved.
//

#import "NSData+DES.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Base64.h"


#define kChosenCipherBlockSize	kCCBlockSizeDES
#define kChosenCipherKeySize	kCCKeySize3DES


@implementation NSData (DES)

- (NSData *) doEncryptWithKey:(NSString *)key{
   
    CCOptions pad = kCCOptionECBMode | kCCOptionPKCS7Padding;
    NSData *data = [self doCipher:[key dataUsingEncoding:NSUTF8StringEncoding] context:kCCEncrypt padding:&pad];
    return data;

}
- (NSData *) doDecryptWithKey:(NSString *)key{
    
    CCOptions pad = kCCOptionECBMode|kCCOptionPKCS7Padding;
    NSData *data = [self doCipher:[key dataUsingEncoding:NSUTF8StringEncoding] context:kCCDecrypt padding:&pad];
    return data;

}

- (NSData *) doCipher:(NSData *)symmetricKey context:(CCOperation)encryptOrDecrypt padding	:(CCOptions *)pkcs7 {    
    CCCryptorStatus ccStatus = kCCSuccess;
    CCCryptorRef thisEncipher = NULL;
    NSData * cipherOrPlainText = nil;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t remainingBytes = 0;
    size_t movedBytes = 0;
    size_t plainTextBufferSize = 0;
    size_t totalBytesWritten = 0;
    uint8_t * ptr;
    uint8_t iv[kChosenCipherBlockSize];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    plainTextBufferSize = [self length];
    ccStatus = CCCryptorCreate(	encryptOrDecrypt,
                               kCCAlgorithm3DES,
                               *pkcs7,
                               (const void *)[symmetricKey bytes],
                               kChosenCipherKeySize,
                               (const void *)iv,
                               &thisEncipher
                               );
    
    
    if (ccStatus != kCCSuccess) {
        NSLog(@"Problem creating the context, ccStatus == %d.", ccStatus);
    }
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    ptr = bufferPtr;
    remainingBytes = bufferPtrSize;
    ccStatus = CCCryptorUpdate( thisEncipher,
                               (const void *) [self bytes],
                               plainTextBufferSize,
                               ptr,
                               remainingBytes,
                               &movedBytes
                               );
    
    
    if (ccStatus != kCCSuccess) {
        NSLog(@"Problem with CCCryptorUpdate, ccStatus == %d.", ccStatus);
    }
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;
    ccStatus = CCCryptorFinal(thisEncipher,
                              ptr,
                              remainingBytes,
                              &movedBytes
                              );
    totalBytesWritten += movedBytes;
    if(thisEncipher) {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }
    if (ccStatus != kCCSuccess) {
        NSLog(@"Problem with encipherment ccStatus == %d", ccStatus);
    }
    cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length
											 :(NSUInteger)totalBytesWritten];
    if(bufferPtr) free(bufferPtr);
    return cipherOrPlainText;
}


@end
