//
//  ProgressUtil.h
//  PublicHealth
//
//  Created by Tom on 16/3/25.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressUtil : NSObject

+ (void)show;

+ (void)showWithStatus:(NSString*)info;

+ (void)showInfo:(NSString*)info;

+ (void)showError:(NSString*)info;

+ (void)showSuccess:(NSString*)info;

+ (void)showProgress:(CGFloat) grogress;

+ (void)showProgress:(CGFloat)grogress withStatus:(NSString*) info;

+ (void)dismiss;

@end
