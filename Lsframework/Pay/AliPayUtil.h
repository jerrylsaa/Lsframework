//
//  AliPayUtil.h
//  FamilyPlatForm
//
//  Created by tom on 16/6/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AlipayCallback)(NSDictionary * dict);

@interface AliPayUtil : NSObject

@property (nonatomic, copy) AlipayCallback callback;

+(instancetype)sharedManager;

+(void)payWithTitle:(NSString*)title withDetail:(NSString*)detail withOrderNum:(NSString*)orderNum withPrice:(CGFloat)price callback:(AlipayCallback)callback;

+(void)payWithTitle:(NSString *)title withDetail:(NSString *)detail withOrderNum:(NSString*)orderNum withPrice:(CGFloat)price  healthServiceCallback:(AlipayCallback)callback;

@end
