//
//  ProgressUtil.m
//  PublicHealth
//
//  Created by Tom on 16/3/25.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "ProgressUtil.h"
#import <SVProgressHUD.h>

@implementation ProgressUtil

+(void)show{
    [SVProgressHUD show];
}

+(void)showWithStatus:(NSString *)info{
    [SVProgressHUD showWithStatus:info];
}

+ (void)showError:(NSString *)info{
    [SVProgressHUD showErrorWithStatus:info];
}

+ (void)showInfo:(NSString *)info{
    [SVProgressHUD showInfoWithStatus:info];
}

+ (void)showSuccess:(NSString *)info{
    [SVProgressHUD showSuccessWithStatus:info];
}

+(void)showProgress:(CGFloat)grogress{
    [SVProgressHUD showProgress:grogress];

}

+ (void)showProgress:(CGFloat)grogress withStatus:(NSString *)info{
    [SVProgressHUD showProgress:grogress status:info];
}

+ (void)dismiss{
    [SVProgressHUD dismiss];
}

@end
