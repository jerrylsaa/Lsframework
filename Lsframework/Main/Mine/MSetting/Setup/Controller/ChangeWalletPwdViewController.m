//
//  ChangeWalletPwdViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/7/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChangeWalletPwdViewController.h"
#import "JMFoundation.h"
#import "FPNetwork.h"
@interface ChangeWalletPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldWalletPwd;

@property (weak, nonatomic) IBOutlet UITextField *enterNewWalletPwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmWalletPwd;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation ChangeWalletPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"修改钱包密码";
    NSLog(@"修改钱包密码");
    
    _oldWalletPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _enterNewWalletPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _confirmWalletPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [_submitBtn addTarget:self action:@selector(submitRequest) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submitRequest {
    if (_oldWalletPwd.text == nil || _oldWalletPwd.text.length == 0) {
        [ProgressUtil showError:@"请输入原密码"];
        return;
    }
    
    
    if (_enterNewWalletPwd.text == nil || _enterNewWalletPwd.text.length == 0) {
        [ProgressUtil showError:@"请输入新密码"];
        return;
    }
    if (_enterNewWalletPwd.text.length < 6 || _enterNewWalletPwd.text.length > 20) {
        [ProgressUtil showError:@"请输入6-20位密码"];
        return;
    }
    if (![self checkPassword:_enterNewWalletPwd.text]) {
        [ProgressUtil showError:@"密码只能包含数字和字母"];
        return;
    }
    
    if (_confirmWalletPwd.text == nil || _confirmWalletPwd.text.length == 0) {
        [ProgressUtil showError:@"请输入确认新密码"];
        return;
    }
    if (![_confirmWalletPwd.text isEqualToString:_enterNewWalletPwd.text]) {
        [ProgressUtil showError:@"新密码和确认密码不一致，请重新输入"];
        return;
    }
    
    if([_oldWalletPwd.text isEqualToString:_enterNewWalletPwd.text]){
        [ProgressUtil showError:@"新密码和原密码不能相同，请重新输入"];
        return;
    }
    
    NSString *oldpasswd = [NSString stringWithFormat:@"%@", _oldWalletPwd.text];
    
    oldpasswd = [JMFoundation encryptForFamilyPaltForm:oldpasswd];
    NSString *newpasswd = [NSString stringWithFormat:@"%@", _enterNewWalletPwd.text];
    
    newpasswd = [JMFoundation encryptForFamilyPaltForm:newpasswd];
    
    WS(weakSelf);
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId], @"oldPass":oldpasswd,@"newPass":newpasswd,@"newPassAgain":newpasswd};
    
    [[FPNetwork POST:API_UPDATEPASSBYMYWALLET withParams:params]  addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            [ProgressUtil showSuccess:response.message];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [ProgressUtil showError:response.message];
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
