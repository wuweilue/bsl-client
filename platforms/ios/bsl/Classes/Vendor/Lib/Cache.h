//
//  Cache.h
//  Cube-iOS
//
//  Created by Justin Yip on 10/28/12.
//
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject

+(id)instance;
-(void)setData:(NSData*)aData forKey:(NSString*)aKey;
-(NSData*)dataForKey:(NSString*)aKey;

@end
