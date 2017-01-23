//
//  RegisterPresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RegisterPresenter.h"
#import "ProgressUtil.h"
#import "JMFoundation.h"

@interface RegisterPresenter (){
    
}

@property(nonatomic,copy) NSString* phoneNum;

@property(nonatomic,copy) NSString* psw;

@end

@implementation RegisterPresenter

-(instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
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

- (void)registerWithPhone:(NSString *) phoneNumber identifyingCode:(NSString *) code password:(NSString *) password rePassword:(NSString *) rePassword{
    self.phoneNum = phoneNumber;
    self.psw = password;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(phoneNumber.length == 0){
        [ProgressUtil showError:@"请输入手机号"];
        return ;
    }

    
    if ([self checkPhone:phoneNumber] == 0) {
        [ProgressUtil showError:@"手机号格式不正确"];
        return;
    }
    if (code.length == 0) {
        [ProgressUtil showError:@"请输入验证码"];
        return;
    }
    if (password.length < 6 || password.length > 20) {
        [ProgressUtil showError:@"请输入6-20位密码"];
        return;
    }
//    if (![password isEqualToString:rePassword]) {
//        [ProgressUtil showError:@"密码输入不一致"];
//        return;
//    }
    if ([self checkPassword:password] == 0) {
        [ProgressUtil showError:@"密码只能包含数字和字母"];
        return;
    }
    password = [NSString stringWithFormat:@"%@%@", phoneNumber, password];
    password = [JMFoundation encryptForFamilyPaltForm:password];
    [parameters setObject:phoneNumber forKey:@"phone"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:password forKey:@"password"];
    [self registerUser:parameters];
    
}

- (void)registerWCWithPhone:(NSString *) phoneNumber identifyingCode:(NSString *) code password:(NSString *) password rePassword:(NSString *) rePassword{
    self.phoneNum = phoneNumber;
    self.psw = password;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(phoneNumber.length == 0){
        [ProgressUtil showError:@"请输入手机号"];
        return ;
    }
    
    
    if ([self checkPhone:phoneNumber] == 0) {
        [ProgressUtil showError:@"手机号格式不正确"];
        return;
    }
    if (code.length == 0) {
        [ProgressUtil showError:@"请输入验证码"];
        return;
    }
    if (password.length < 6 || password.length > 20) {
        [ProgressUtil showError:@"请输入6-20位密码"];
        return;
    }
    //    if (![password isEqualToString:rePassword]) {
    //        [ProgressUtil showError:@"密码输入不一致"];
    //        return;
    //    }
    if ([self checkPassword:password] == 0) {
        [ProgressUtil showError:@"密码只能包含数字和字母"];
        return;
    }
    password = [NSString stringWithFormat:@"%@%@", phoneNumber, password];
    password = [JMFoundation encryptForFamilyPaltForm:password];
    [parameters setObject:phoneNumber forKey:@"phone"];
    [parameters setObject:code forKey:@"phoneCode"];
    [parameters setObject:password forKey:@"phonePwd"];
    [parameters setObject:@"true" forKey:@"isNewUser"];
    
    

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uuid =[defaults objectForKey:@"MyWeChatUuid"];
    [parameters setObject:uuid forKey:@"uuid"];

    [self registerWCUser:parameters];
    
}

- (void)sendToPhone:(NSString *) phone{
    
    NSDictionary *parameters = @{@"phone":phone,@"IdentifyingCode":@0};
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
- (void)registerUser:(NSDictionary *)parameters{
    WS(ws);

    [[FPNetwork POST:API_PHONE_REGIST withParams:parameters] addCompleteHandler:^(FPResponse* response) {
        if (response != nil) {
            if (response.isSuccess) {
//                [ProgressUtil showSuccess:response.message];
//                kCurrentUser.phone = ws.phoneNum;
//                kCurrentUser.userPasswd = ws.psw;
            }
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(registerComplete:info:)]){
                [ws.delegate registerComplete:response.success info:response.message];
            }
        }
        
        

    }];
    

    
}

- (void)registerWCUser:(NSDictionary *)parameters{
    WS(ws);
    
    [[FPNetwork POSTtigerhuang007:@"BindWxToUser" withParams:parameters] addCompleteHandler:^(FPResponse* response) {
        if (response != nil) {
            if (response.status ==200) {
                [kCurrentUser mj_setKeyValues:response.data];
                kCurrentUser.token = response.token;
            }
            
            if(ws.delegate && [ws.delegate respondsToSelector:@selector(registerComplete:info:)]){
                [ws.delegate registerWCNewComplete:response.success info:response.message];
            }
        }
        
        
        
    }];
    
    
    
}

-(void)autoLogin{
    WS(ws);
    //自动登录
    NSString* passwd = [NSString stringWithFormat:@"%@%@", self.phoneNum, self.psw];
    
    passwd = [JMFoundation encryptForFamilyPaltForm:passwd];
    
    NSDictionary * params = @{@"phone":self.phoneNum, @"password":passwd};
    [[FPNetwork POST:API_LOGIN withParams:params] addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            //            kCurrentUser.phone = userName;
            [kCurrentUser mj_setKeyValues:response.data];
            kCurrentUser.token = response.token;
            kCurrentUser.userPasswd = ws.psw;
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(loginComplete:info:)]){
            [ws.delegate loginComplete:response.success info:response.message];
        }
        
        
    }];
}

- (BOOL )checkPhone:(NSString *)phone
{
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
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,185,184,187,188,176,170
//     * 联通：130,131,132,152,155,156,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[02345-9]|7[06])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188,176,170
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    
//    if (([regextestmobile evaluateWithObject:phone] == YES)
//        || ([regextestcm evaluateWithObject:phone] == YES)
//        
//        || ([regextestcu evaluateWithObject:phone] == YES))
//    {
//        if([regextestcm evaluateWithObject:phone] == YES) {
////                        NSLog(@"China Mobile");
//        } else if ([regextestcu evaluateWithObject:phone] == YES) {
////                        NSLog(@"China Unicom");
//        } else {
////                        NSLog(@"Unknow");
//        }
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}

- (BOOL )checkPassword:(NSString *) password
{
    NSString *passWordRegex =  @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    if ([passWordPredicate evaluateWithObject:password]){
        return YES;
    }else{
        return NO;
    }
}


@end
