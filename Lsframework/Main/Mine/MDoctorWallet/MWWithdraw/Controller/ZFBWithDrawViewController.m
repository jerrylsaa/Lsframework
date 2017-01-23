//
//  ZFBWithDrawViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/8/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZFBWithDrawViewController.h"
#import "MWWithSuccessViewController.h"
#import "MWWithdrawRuleViewController.h"
#import "LeftTitleTextField.h"
#import <TTTAttributedLabel.h>
#import "JMFoundation.h"
#import "FPNetwork.h"
#import "ForgetPassWordViewController.h"

@interface ZFBWithDrawViewController ()<UIAlertViewDelegate>{
    
    UIScrollView *_scroll;
    UIView *_bankbgView;
    UIView* _accountInfobgView;

    LeftTitleTextField *_banktf;
    LeftTitleTextField* _nametf;
    LeftTitleTextField* _cashtf;

}

@end

@implementation ZFBWithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 加载子视图
- (void)setupView{
    self.title = @"提现申请";
    self.view.backgroundColor =[UIColor whiteColor];
    
    _scroll = [UIScrollView new];
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupBankView];
    [self setupAccountInfoView];
    [self setupCommitView];
}

- (void)setupBankView{
    _bankbgView = [UIView new];
    _bankbgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_scroll addSubview:_bankbgView];
    
    _bankbgView.sd_layout.topEqualToView(_scroll).leftEqualToView(_scroll).rightEqualToView(_scroll);
    
    _banktf = [LeftTitleTextField new];
    _banktf.font = [UIFont systemFontOfSize:18];
    _banktf.title = @"支付宝账号：";
    _banktf.placeholder = @"请输入支付宝账号";
    _banktf.titleColor = UIColorFromRGB(0x545454);
    [_bankbgView addSubview:_banktf];
    
    _banktf.sd_layout.topSpaceToView(_bankbgView,15).leftSpaceToView(_bankbgView,20).rightSpaceToView(_bankbgView,0).heightIs(20);
    
    [_bankbgView setupAutoHeightWithBottomViewsArray:@[_banktf] bottomMargin:15];
}

- (void)setupAccountInfoView{
    _accountInfobgView = [UIView new];
    _accountInfobgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_scroll addSubview:_accountInfobgView];
    
    UIView* bankNameLine = [UIView new];
    bankNameLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_accountInfobgView addSubview:bankNameLine];
    _nametf = [LeftTitleTextField new];
    _nametf.font = _banktf.font;
    _nametf.title = @"姓名：";
    _nametf.placeholder = @"请输入姓名";
    _nametf.titleFont = _banktf.font;
    _nametf.titleColor = UIColorFromRGB(0x545454);
    [_accountInfobgView addSubview:_nametf];
    
    UIView* placeLine = [UIView new];
    placeLine.backgroundColor = bankNameLine.backgroundColor;
    [_accountInfobgView addSubview:placeLine];
    
    _cashtf = [LeftTitleTextField new];
    _cashtf.keyboardType = UIKeyboardTypePhonePad;
    _cashtf.font = _banktf.font;
    _cashtf.title = @"提现金额：";
    _cashtf.titleFont = _banktf.font;
    _cashtf.titleColor = UIColorFromRGB(0x545454);
    [_accountInfobgView addSubview:_cashtf];
    
    bankNameLine.sd_layout.topEqualToView(_accountInfobgView).leftEqualToView(_accountInfobgView).rightEqualToView(_accountInfobgView).heightIs(1);
    _nametf.sd_layout.topSpaceToView(bankNameLine,15).leftSpaceToView(_accountInfobgView,20).rightSpaceToView(_accountInfobgView,20).heightIs(20);
    
    placeLine.sd_layout.topSpaceToView(_nametf,15).leftEqualToView(_accountInfobgView).rightEqualToView(_accountInfobgView).heightIs(1);
    _cashtf.sd_layout.topSpaceToView(placeLine,15).leftSpaceToView(_accountInfobgView,20).rightSpaceToView(_accountInfobgView,20).heightIs(20);
    
    _accountInfobgView.sd_layout.topSpaceToView(_bankbgView,0).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [_accountInfobgView setupAutoHeightWithBottomView:_cashtf bottomMargin:15];
}

- (void)setupCommitView{
    UIView *commitLine  = [UIView new];
    commitLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_scroll addSubview:commitLine];
    
    UIButton* commit = [UIButton new];
    [commit setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
    [commit setTitle:@"申请提现" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:commit];
    
    commitLine.sd_layout.topSpaceToView(_accountInfobgView,0).heightIs(1).leftEqualToView(_scroll).rightEqualToView(_scroll);
    
    commit.sd_layout.topSpaceToView(commitLine,40).leftSpaceToView(_scroll,10).rightSpaceToView(_scroll,10).heightIs(40);
    
    [_scroll setupAutoContentSizeWithBottomView:commit bottomMargin:25];


}


- (void)commitAction{
    
    if (_banktf.text == nil || _banktf.text.length == 0) {
        [ProgressUtil showError:@"请输入支付宝账号"];
        return;
    }
    if (_nametf.text == nil || _nametf.text.length == 0) {
        [ProgressUtil showError:@"请输入姓名"];
        return;
    }
    
    if (_cashtf.text == nil || _cashtf.text.length == 0) {
        [ProgressUtil showError:@"请输入提现金额"];
        return;
    }
    NSDictionary * params = @{
                              @"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId],@"AlipayAccount":_banktf.text,@"UserName":_nametf.text,@"Money":_cashtf.text};
    WS(ws);
    [[FPNetwork POST:API_INSERTALIPAYWITHDRAWALS withParams:params] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSLog(@"%@",response.message);
        [ws.navigationController pushViewController:[MWWithSuccessViewController new] animated:YES];
        }
     else {
         if (response.message==nil) {
             [ProgressUtil showError:@"网络故障"];
             
         }else{
             [ProgressUtil showError:response.message];
         }
         
     }

    }];
    

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
