//
//  MD5Hash.m
//  BuyShooting
//
//  Created by YinHao on 13-1-18.
//
//

#import "MD5Hash.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5Hash
// md5(salt+password)
+(NSString *)getMD5Password:(NSString *)password secondKid:(NSString *)randomNumber{
    
    NSLog(@"%@ %@",password,randomNumber);
    NSMutableString *appendPassword = [[NSMutableString alloc] initWithString:randomNumber];
    [appendPassword appendString:password];
    NSString *tempPassword = [NSString stringWithString:appendPassword];
    return [self get32MD5Hash:tempPassword];
}
// md5(md5(salt+password)+T)
+(NSString *)getRequestPassword:(NSString *)MD5Password secondKid:(NSString *)localTime{
    NSMutableString *appendPassword = [[NSMutableString alloc] initWithString:MD5Password];
    [appendPassword appendString:localTime];
    NSString *tempPassword = [NSString stringWithString:appendPassword];
    return [self get32MD5Hash:tempPassword];
}

+(NSString *)get32MD5Hash:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]lowercaseString];
}

+(NSString *)get16MD5Hash:(NSString *)str {
    return [[self get32MD5Hash:str] substringWithRange:NSMakeRange(8,16)];
}

@end
