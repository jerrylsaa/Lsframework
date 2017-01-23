//
//  ForgetPassWordPresenter.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ForgetPassWordPresenter.h"
#import "JMFoundation.h"

@interface ForgetPassWordPresenter ()

@property(nonatomic,copy) NSString* phoneNum;

@property(nonatomic,copy) NSString* psw;

@end

@implementation ForgetPassWordPresenter

- (void)sendIdentifyingCodeToPhone:(NSString *)phoneNumber with:(NSInteger )idCode{
    
    NSLog(@"%d",[self checkPhone:phoneNumber]);
    if ([self checkPhone:phoneNumber] == 1) {
        [self sendToPhone:phoneNumber with:idCode];
    }else{
        [ProgressUtil showError:@"手机号格式不正确"];
    }
}

- (void)sendToPhone:(NSString *)phone with:(NSInteger )idCode{
    
    NSDictionary *parameters = @{@"phone":phone,@"IdentifyingCode":@(idCode)};
    
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

- (void)commitWithPhone:(NSString *)phoneNumber identifyingCode:(NSString *)code password:(NSString *)password rePassword:(NSString *)rePassword identifyCode:(NSInteger)idCode{
    
    self.phoneNum = phoneNumber;
    self.psw = password;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
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
    if (![password isEqualToString:rePassword]) {
        [ProgressUtil showError:@"密码输入不一致"];
        return;
    }
    if ([self checkPassword:password] == 0) {
        [ProgressUtil showError:@"密码只能包含数字和字母"];
        return;
    }
    if (idCode ==1) {
        password = [NSString stringWithFormat:@"%@%@", phoneNumber, password];
        password = [JMFoundation encryptForFamilyPaltForm:password];
    }
    if (idCode ==2) {
        password = [JMFoundation encryptForFamilyPaltForm:password];
        
    }
    
    [parameters setObject:phoneNumber forKey:@"phone"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:password forKey:@"password"];

    [self commitUser:parameters withIdentifyCode:idCode];

    
}

- (void)commitUser:(NSDictionary *)parameters withIdentifyCode:(NSInteger )idCode{
    
    //
    NSLog(@"西湖的水，我的泪,啊~,啊~");
    WS(ws);
    if (idCode ==1) {
        [[FPNetwork POST:API_FORGETPASSWORD withParams:parameters] addCompleteHandler:^(FPResponse* response) {
            if (response != nil) {
                if (response.isSuccess) {
                    //                [ProgressUtil showSuccess:response.message];
                    //                kCurrentUser.phone = ws.phoneNum;
                    //                kCurrentUser.userPasswd = ws.psw;
                }
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(commitComplete:info:)]){
                    [ws.delegate commitComplete:response.success info:response.message];
                }
            }
            
            
            
        }];
    }
    if (idCode ==2) {//
        [[FPNetwork POST:API_FORGETMYWALLETPASSWORD withParams:parameters] addCompleteHandler:^(FPResponse* response) {
            if (response != nil) {
                if (response.isSuccess) {
                    //                [ProgressUtil showSuccess:response.message];
                    //                kCurrentUser.phone = ws.phoneNum;
                    //                kCurrentUser.userPasswd = ws.psw;
                }
                
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(commitComplete:info:)]){
                    [ws.delegate commitComplete:response.success info:response.message];
                }
            }
            
            
            
        }];
    }

    

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
//            //                        NSLog(@"China Mobile");
//        } else if ([regextestcu evaluateWithObject:phone] == YES) {
//            //                        NSLog(@"China Unicom");
//        } else {
//            //                        NSLog(@"Unknow");
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
