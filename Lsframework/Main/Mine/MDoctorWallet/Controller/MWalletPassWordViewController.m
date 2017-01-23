//
//  MWalletPassWordViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/6/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWalletPassWordViewController.h"
#import "MDoctoreWalletPresenter.h"
#import "JMFoundation.h"

@interface MWalletPassWordViewController ()<MDoctoreWalletPresenterDelegate>
@property (weak, nonatomic) IBOutlet UITextField *enterPwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property(nonatomic,retain) MDoctoreWalletPresenter* presenter;

@end

@implementation MWalletPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"设置钱包密码";
    self.presenter = [MDoctoreWalletPresenter new];
    self.presenter.delegate = self;
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backItemAction:(id)sender{
    

    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)submitAction{
    if (_enterPwd.text == nil || _enterPwd.text.length == 0) {
        [ProgressUtil showError:@"请输入密码"];
        return;
    }
    
    if (_enterPwd.text.length < 6 || _enterPwd.text.length > 20) {
        [ProgressUtil showError:@"请输入6-20位密码"];
        return;
    }
    if (![self checkPassword:_enterPwd.text]) {
        [ProgressUtil showError:@"密码只能包含数字和字母"];
        return;
    }
    
    if (_confirmPwd.text == nil || _confirmPwd.text.length == 0) {
        [ProgressUtil showError:@"请输入确认密码"];
        return;
    }
    
    if (![_confirmPwd.text isEqualToString:_enterPwd.text]) {
        [ProgressUtil showError:@"两次密码输入不一致，请重新输入"];
        return;
    }
    NSString *passwd = [JMFoundation encryptForFamilyPaltForm:_enterPwd.text];
    [self.presenter submitWalletPwd:passwd];
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
