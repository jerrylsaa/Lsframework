//
//  NSData+Encrypt.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encrypt)
- (NSData *)AES256ParmEncryptWithKey:(NSString *)key ;
@end
