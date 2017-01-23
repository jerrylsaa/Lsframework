//
//  MD5Hash.h
//  BuyShooting
//
//  Created by YinHao on 13-1-18.
//
//

#import <Foundation/Foundation.h>

@interface MD5Hash : NSObject

+ (NSString *)getMD5Password:(NSString *)password secondKid:(NSString *)randomNumber;
+ (NSString *)getRequestPassword:(NSString *)MD5Password secondKid:(NSString *)localTime;

+ (NSString *)get32MD5Hash:(NSString *)str;
+ (NSString *)get16MD5Hash:(NSString *)str;

@end
