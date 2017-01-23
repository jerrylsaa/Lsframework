//
//  LoginPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "LoginPresenter.h"
#import "NSString+Category.h"
#import "JMFoundation.h"


@implementation LoginPresenter

-(void)loginWithUserName:(NSString *)userName withPasswd:(NSString *)passwd{
    
    if (userName == nil || userName.length == 0) {
        [_delegate onLoginComplete:NO info:@"请输入手机号码"];
        return;
    }
    if (passwd == nil || passwd.length == 0) {
        [_delegate onLoginComplete:NO info:@"请输入密码"];
        return;
    }
    
    passwd = [NSString stringWithFormat:@"%@%@", userName, passwd];

    passwd = [JMFoundation encryptForFamilyPaltForm:passwd];
    
    NSDictionary * params = @{@"phone":userName, @"password":passwd};

    [[FPNetwork POST:API_LOGIN withParams:params] addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
//            kCurrentUser.phone = userName;
            [kCurrentUser mj_setKeyValues:response.data];
            kCurrentUser.token = response.token;
        
            [_delegate onLoginComplete:YES info:response.message];
        }else{
            [_delegate onLoginComplete:NO info:response.message];
        }
    }];
}

- (void)loginWithWeChatCode:(NSString *)codeStr{
    NSDictionary * params = @{@"code":codeStr};
    [[FPNetwork POSTtigerhuang007:@"Login" withParams:params] addCompleteHandler:^(FPResponse* response) {
        [ProgressUtil dismiss];
        if(response.isSuccess){
            //            kCurrentUser.phone = userName;
            [kCurrentUser mj_setKeyValues:response.data];
            kCurrentUser.token = response.token;
            
            [_delegate onLoginWeChatComplete:YES info:response.message Dictionary:nil];
        }else if(response.status ==201){
            [_delegate onLoginWeChatComplete:YES info:response.message Dictionary:response.data];
        }else if(response.status ==500){
            [_delegate onLoginWeChatComplete:NO info:response.message Dictionary:nil];
        }else{
            [_delegate onLoginWeChatComplete:NO info:@"绑定失败" Dictionary:nil];
        }
    }];
}

- (void)registerWithPhone:(NSString *) phoneNumber identifyingCode:(NSString *) code{
    if ([self checkPhone:phoneNumber] == 0) {
        [ProgressUtil showError:@"手机号格式不正确"];
        return;
    }
    if (code.length == 0) {
        [ProgressUtil showError:@"请输入验证码"];
        return;
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uuid =[defaults objectForKey:@"MyWeChatUuid"];
    if (uuid ==nil) {
        
        [ProgressUtil showError:@"您的账号已过期,请重新授权"];
        return;
    }
    NSDictionary * params = @{@"uuid":uuid,@"phone":phoneNumber,@"phoneCode":code};
    [[FPNetwork POSTtigerhuang007:@"BindWxToUser" withParams:params] addCompleteHandler:^(FPResponse* response) {
        
        if(response.status ==200){
            [kCurrentUser mj_setKeyValues:response.data];
            kCurrentUser.token = response.token;
            
            [_delegate onBindWeChatComplete:YES info:response.message];
        }else if(response.status ==201){
            [_delegate onBindWeChatComplete:NO info:response.message];
            
        }else if(response.status ==500){
            [_delegate onBindWeChatComplete:NO info:response.message];
            
        }else{
            [_delegate onBindWeChatComplete:NO info:@"网络不可用,请重试"];
        }
    }];

    
}

- (void)sendIdentifyingCodeToPhone:(NSString *)phoneNumber{
    
    NSLog(@"%d",[self checkPhone:phoneNumber]);
    
    if(phoneNumber.length == 0){
        [ProgressUtil showError:@"请输入手机号"];
        return ;
    }
    
    if ([self checkPhone:phoneNumber] == 1) {
        [self sendToPhone:phoneNumber];
    }else{
        [ProgressUtil showError:@"手机号格式不正确"];
    }
}

- (void)sendToPhone:(NSString *) phone{
    
    NSDictionary *parameters = @{@"phone":phone,@"IdentifyingCode":@3};
    [[FPNetwork POST:API_PHONE_INDENTIFYING_CODE withParams:parameters] addCompleteHandler:^(FPResponse* response) {
        if (response != nil) {
            if (response.isSuccess) {
                [ProgressUtil showSuccess:response.message];
                if ([self.delegate respondsToSelector:@selector(sendIdentifyingCodeComplete:)]) {
                    [self.delegate sendIdentifyingCodeComplete:YES];
                }
            }else{
                [ProgressUtil showError:response.message];
                if ([self.delegate respondsToSelector:@selector(sendIdentifyingCodeComplete:)]) {
                    [self.delegate sendIdentifyingCodeComplete:NO];
                }
            }
        }
    }];
}

- (BOOL )checkPhone:(NSString *)phone {
    if ([phone length] != 11) {
        return NO;
    }
    
    NSString *phoneRegex =  @"^[0-9]+$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if ([phonePredicate evaluateWithObject:phone]){
        return YES;
    }else{
        return NO;
    }
    
    return YES;
}

@end
