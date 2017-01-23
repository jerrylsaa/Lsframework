//
//  ChangePwdController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChangePwdController.h"
#import "FPNetwork.h"
#import "JMFoundation.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "DefaultChildEntity.h"

@interface ChangePwdController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *nPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *sureNPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;



@end

@implementation ChangePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"修改密码";
    _oldPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
  _sureNPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_submitBtn addTarget:self action:@selector(submitRequest) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitRequest {
    if (_oldPwdTF.text == nil || _oldPwdTF.text.length == 0) {
        [ProgressUtil showError:@"请输入原密码"];
        return;
    }
    
    if(![_oldPwdTF.text isEqualToString:kCurrentUser.userPasswd]){
        [ProgressUtil showError:@"原密码输入错误，请重新输入"];
        return;

    }
    
    if (_nPwdTF.text == nil || _nPwdTF.text.length == 0) {
        [ProgressUtil showError:@"请输入新密码"];
        return;
    }
    if (_nPwdTF.text.length < 6 || _nPwdTF.text.length > 20) {
        [ProgressUtil showError:@"请输入6-20位密码"];
        return;
    }
    if (![self checkPassword:_nPwdTF.text]) {
        [ProgressUtil showError:@"密码只能包含数字和字母"];
        return;
    }
    
    if (_sureNPwdTF.text == nil || _sureNPwdTF.text.length == 0) {
        [ProgressUtil showError:@"请输入确认新密码"];
        return;
    }
    if (![_sureNPwdTF.text isEqualToString:_nPwdTF.text]) {
        [ProgressUtil showError:@"新密码和确认密码不一致，请重新输入"];
        return;
    }
    
    if([_oldPwdTF.text isEqualToString:_nPwdTF.text]){
        [ProgressUtil showError:@"新密码和原密码不能相同，请重新输入"];
        return;
    }
    
    NSString *oldpasswd = [NSString stringWithFormat:@"%@%@", kCurrentUser.phone, _oldPwdTF.text];
    
    oldpasswd = [JMFoundation encryptForFamilyPaltForm:oldpasswd];
    NSString *newpasswd = [NSString stringWithFormat:@"%@%@", kCurrentUser.phone, _nPwdTF.text];
    
    newpasswd = [JMFoundation encryptForFamilyPaltForm:newpasswd];
    
    WS(weakSelf);
    NSDictionary * params = @{@"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId], @"PassWord":oldpasswd,@"NPassWord":newpasswd};
    
    [[FPNetwork POST:@"EditPass" withParams:params]  addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            
            [ProgressUtil showInfo:response.message];
            kCurrentUser.userPasswd = nil;
            [DefaultChildEntity MR_truncateAll];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberAccount"];
            [weakSelf presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[LoginViewController sharedLoginViewController]] animated:YES completion:nil];
        }else{
            if (response.status == 401) {
                [ProgressUtil showError:@"修改失败，原密码输入错误"];
            }else{
                [ProgressUtil showError:response.message];
            }
        }
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
