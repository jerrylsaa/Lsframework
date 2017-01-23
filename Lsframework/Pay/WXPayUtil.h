//
//  WXPayUtil.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/10.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WXPayCallback)();


@interface WXPayUtil : NSObject

@property (nonatomic, copy) WXPayCallback callback;

+(instancetype)sharedManager;


+(void)payWithWXParames:(NSDictionary*) wxParames callback:(WXPayCallback) callback;



@end
