//
//  MWWithdrawViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWWithdrawViewController.h"
#import "MWWithSuccessViewController.h"
#import "MWWithdrawRuleViewController.h"
#import "LeftTitleTextField.h"
#import <TTTAttributedLabel.h>
#import "JMFoundation.h"
#import "FPNetwork.h"
#import "ForgetPassWordViewController.h"

@interface MWWithdrawViewController ()<TTTAttributedLabelDelegate,UIAlertViewDelegate>{
    UIScrollView* _scroll;
    UIView* _bankbgView;
    LeftTitleTextField* _banktf;
    
    UIView* _accountInfobgView;
    LeftTitleTextField* _nametf;
    LeftTitleTextField* _placetf;
    LeftTitleTextField* _cardNumtf;
    LeftTitleTextField* _accountNametf;
    LeftTitleTextField* _accountPhonetf;
    LeftTitleTextField* _cashtf;
}
@property (nonatomic,strong) NSArray *textFieldArr;
@end

@implementation MWWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _textFieldArr =@[_banktf,
                     _nametf,
                     _placetf,
                     _cardNumtf,
                     _accountNametf,
                     _accountPhonetf,
                     _cashtf];
}

#pragma mark - 加载子视图
- (void)setupView{
    self.title = @"提现申请";
    
    _scroll = [UIScrollView new];
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupBankView];
    [self setupAccountInfoView];
    [self setupTipsLabel];
}

- (void)setupBankView{
    _bankbgView = [UIView new];
    _bankbgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_scroll addSubview:_bankbgView];
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
//    [_bankbgView addGestureRecognizer:tap];
    
    _banktf = [LeftTitleTextField new];
    _banktf.font = [UIFont systemFontOfSize:18];
    _banktf.title = @"开户行：";
    _banktf.placeholder = @"请输入开户行名";
    _banktf.titleColor = UIColorFromRGB(0x545454);
    [_bankbgView addSubview:_banktf];
    
//    UIImageView* indactor = [UIImageView new];
//    indactor.userInteractionEnabled = YES;
//    indactor.image = [UIImage imageNamed:@"mine_indactor"];
//    [_bankbgView addSubview:indactor];
    
    _banktf.sd_layout.topSpaceToView(_bankbgView,15).leftSpaceToView(_bankbgView,20).widthIs(250).heightIs(20);
//    indactor.sd_layout.centerYEqualToView(_banktf).heightIs(37/2.0).rightSpaceToView(_bankbgView,20).widthIs(21/2.0);
    _bankbgView.sd_layout.topEqualToView(_scroll).leftEqualToView(_scroll).rightEqualToView(_scroll);
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
    _nametf.title = @"开户行支行：";
    _nametf.placeholder = @"请输入支行名";
    _nametf.titleFont = _banktf.font;
    _nametf.titleColor = UIColorFromRGB(0x545454);
    [_accountInfobgView addSubview:_nametf];

    UIView* placeLine = [UIView new];
    placeLine.backgroundColor = bankNameLine.backgroundColor;
    [_accountInfobgView addSubview:placeLine];
    _placetf = [LeftTitleTextField new];
    _placetf.font = _banktf.font;
    _placetf.title = @"开户行所在地：";
    _placetf.placeholder = @"请填写省、市即可";
    _placetf.titleFont = _banktf.font;
    _placetf.titleColor = UIColorFromRGB(0x545454);
    [_accountInfobgView addSubview:_placetf];

    UIView* cardLine = [UIView new];
    cardLine.backgroundColor = bankNameLine.backgroundColor;
    [_accountInfobgView addSubview:cardLine];
    _cardNumtf = [LeftTitleTextField new];
    _cardNumtf.keyboardType = UIKeyboardTypePhonePad;
    _cardNumtf.font = _banktf.font;
    _cardNumtf.title = @"储蓄卡号：";
    _cardNumtf.placeholder = @"请输入卡号";
    _cardNumtf.titleFont = _banktf.font;
    _cardNumtf.titleColor = UIColorFromRGB(0x545454);
    [_accountInfobgView addSubview:_cardNumtf];

    UIView* accountLine = [UIView new];
    accountLine.backgroundColor = bankNameLine.backgroundColor;
    [_accountInfobgView addSubview:accountLine];
    _accountNametf = [LeftTitleTextField new];
    _accountNametf.font = _banktf.font;
    _accountNametf.title = @"开户人姓名：";
    _accountNametf.placeholder = @"请输入姓名";
    _accountNametf.titleFont = _banktf.font;
    _accountNametf.titleColor = UIColorFromRGB(0x545454);
    [_accountInfobgView addSubview:_accountNametf];

    UIView* phoneLine = [UIView new];
    phoneLine.backgroundColor = bankNameLine.backgroundColor;
    [_accountInfobgView addSubview:phoneLine];
    _accountPhonetf = [LeftTitleTextField new];
    _accountPhonetf.keyboardType = UIKeyboardTypePhonePad;
    _accountPhonetf.font = _banktf.font;
    _accountPhonetf.title = @"开户人手机号：";
    _accountPhonetf.placeholder = @"请输入手机号码";
    _accountPhonetf.titleFont = _banktf.font;
    _accountPhonetf.titleColor = UIColorFromRGB(0x545454);
    [_accountInfobgView addSubview:_accountPhonetf];
    
    UIView* cashLine = [UIView new];
    cashLine.backgroundColor = bankNameLine.backgroundColor;
    [_accountInfobgView addSubview:cashLine];
    _cashtf = [LeftTitleTextField new];
    _cashtf.keyboardType = UIKeyboardTypePhonePad;
    _cashtf.font = _banktf.font;
    _cashtf.title = @"提现金额：";
//    _cashtf.placeholder = @"可提现金额8.00元";
    _cashtf.titleFont = _banktf.font;
    _cashtf.titleColor = UIColorFromRGB(0x545454);
    [_accountInfobgView addSubview:_cashtf];
    
    
    //添加约束
    bankNameLine.sd_layout.topEqualToView(_accountInfobgView).leftEqualToView(_accountInfobgView).rightEqualToView(_accountInfobgView).heightIs(1);
    _nametf.sd_layout.topSpaceToView(bankNameLine,15).leftSpaceToView(_accountInfobgView,20).rightSpaceToView(_accountInfobgView,20).heightIs(20);
    
    placeLine.sd_layout.topSpaceToView(_nametf,15).leftEqualToView(_accountInfobgView).rightEqualToView(_accountInfobgView).heightIs(1);
    _placetf.sd_layout.topSpaceToView(placeLine,15).leftSpaceToView(_accountInfobgView,20).rightSpaceToView(_accountInfobgView,20).heightIs(20);

    cardLine.sd_layout.topSpaceToView(_placetf,15).leftEqualToView(_accountInfobgView).rightEqualToView(_accountInfobgView).heightIs(1);
    _cardNumtf.sd_layout.topSpaceToView(cardLine,15).leftSpaceToView(_accountInfobgView,20).rightSpaceToView(_accountInfobgView,20).heightIs(20);

    accountLine.sd_layout.topSpaceToView(_cardNumtf,15).leftEqualToView(_accountInfobgView).rightEqualToView(_accountInfobgView).heightIs(1);
    _accountNametf.sd_layout.topSpaceToView(accountLine,15).leftSpaceToView(_accountInfobgView,20).rightSpaceToView(_accountInfobgView,20).heightIs(20);

    phoneLine.sd_layout.topSpaceToView(_accountNametf,15).leftEqualToView(_accountInfobgView).rightEqualToView(_accountInfobgView).heightIs(1);
    _accountPhonetf.sd_layout.topSpaceToView(phoneLine,15).leftSpaceToView(_accountInfobgView,20).rightSpaceToView(_accountInfobgView,20).heightIs(20);

    cashLine.sd_layout.topSpaceToView(_accountPhonetf,15).leftEqualToView(_accountInfobgView).rightEqualToView(_accountInfobgView).heightIs(1);
    _cashtf.sd_layout.topSpaceToView(cashLine,15).leftSpaceToView(_accountInfobgView,20).rightSpaceToView(_accountInfobgView,20).heightIs(20);

    
    _accountInfobgView.sd_layout.topSpaceToView(_bankbgView,0).leftEqualToView(_scroll).rightEqualToView(_scroll);
    [_accountInfobgView setupAutoHeightWithBottomView:_cashtf bottomMargin:15];
    
}

- (void)setupTipsLabel{
    UIView* tipsLine = [UIView new];
    tipsLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_scroll addSubview:tipsLine];
    
    TTTAttributedLabel* tips = [TTTAttributedLabel new];
    tips.delegate = self;
    [_scroll addSubview:tips];
    NSString* title =@"*温馨提示：有疑问查看《提现规则》，姓名有误，账户有误等疑问请联系客服解决";
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",title]];
    NSRange range = [title rangeOfString:@"《提现规则》"];
    UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:12];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, title.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF64143) range:NSMakeRange(0, title.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x5EC8BF) range:range];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [tips addLinkToURL:[NSURL URLWithString:@"http://www.baidu.com"] withRange:range];
    tips.attributedText = attributedString;
    tips.isAttributedContent = YES;
    
    
    UIButton* commit = [UIButton new];
    [commit setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
    [commit setTitle:@"申请提现" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:commit];
    
    //添加约束
    tipsLine.sd_layout.topSpaceToView(_accountInfobgView,0).heightIs(1).leftEqualToView(_scroll).rightEqualToView(_scroll);
    tips.sd_layout.topSpaceToView(tipsLine,15).leftSpaceToView(_scroll,20).rightSpaceToView(_scroll,20).autoHeightRatio(0);
    commit.sd_layout.topSpaceToView(tips,40).leftSpaceToView(_scroll,10).rightSpaceToView(_scroll,10).heightIs(40);
    [_scroll setupAutoContentSizeWithBottomView:commit bottomMargin:25];

}

#pragma mark - 点击事件

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{

    [self.navigationController pushViewController:[MWWithdrawRuleViewController new] animated:YES];

}

#pragma mark - 点击事件
/**
 *  选择银行
 */
//- (void)handleTapGesture{
//    
//}
/**
 *  申请提现
 */

- (void)commitAction{
    for (LeftTitleTextField *textField in _textFieldArr) {
        if ([textField isFirstResponder]) {
            [self.view endEditing:YES];
            
            [textField resignFirstResponder];
            
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
        }
    }
    
    
    if (_banktf.text == nil || _banktf.text.length == 0) {
        [ProgressUtil showError:@"请输入开户行"];
        return;
    }
    if (_nametf.text == nil || _nametf.text.length == 0) {
        [ProgressUtil showError:@"请输入开户行支行"];
        return;
    }
    if (_placetf.text == nil || _placetf.text.length == 0) {
        [ProgressUtil showError:@"请输入开户行所在地"];
        return;
    }
    if (_cardNumtf.text == nil || _cardNumtf.text.length == 0) {
        [ProgressUtil showError:@"请输入储蓄卡号"];
        return;
    }
    if (_accountNametf.text == nil || _accountNametf.text.length == 0) {
        [ProgressUtil showError:@"请输入开户人姓名"];
        return;
    }
    if (_accountPhonetf.text == nil || _accountPhonetf.text.length == 0) {
        [ProgressUtil showError:@"请输入开户人手机号"];
        return;
    }
    if (_cashtf.text == nil || _cashtf.text.length == 0) {
        [ProgressUtil showError:@"请输入提现金额"];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入钱包密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"忘记密码",@"确定",nil];
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    UITextField *pwdField = [alertView textFieldAtIndex:0];
    pwdField.placeholder = @"请输入钱包密码";
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {

    ForgetPassWordViewController *vc =[ForgetPassWordViewController new];
        
    vc.identifyingCode =2;
        
    [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (buttonIndex == 2) {
        UITextField *pwdField = [alertView textFieldAtIndex:0];
       
        if ((pwdField.text ==nil)|[pwdField.text isEqualToString:@""]) {
            [ProgressUtil showError:@"请输入钱包密码"];
            return;
        }
        NSLog(@"%@",pwdField.text);
        //开户行_banktf 开户行支行_nametf 开户行所在地_placetf 卡号_cardNumtf 开户人姓名_accountNametf 开户人手机号_accountPhonetf 提现金额_cashtf
        //输入参数：userid 用户ID，pass，Money提现金额，Bank银行，Branch支行，PlaceBank开户行所在地，BankCardNo银行卡号，CardUserName开卡人姓名，CardPhone开户人手机号码，WithdrawalsStatus提现状态(1成功 0处理中)，withdrawalstime提现时间
        NSString *passwd = [JMFoundation encryptForFamilyPaltForm:pwdField.text];
        NSDictionary * params = @{
                                  @"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId],
                                  @"pass":passwd,
                                  @"Bank":_banktf.text,
                                  @"Branch":_nametf.text,
                                  @"PlaceBank":_placetf.text,
                                  @"BankCardNo":_cardNumtf.text,
                                  @"CardUserName":_accountNametf.text,
                                  @"CardPhone":_accountPhonetf.text,
                                  @"Money":_cashtf.text,
                                  };
        WS(ws);
        [[FPNetwork POST:API_INSERTWITHDRAWALS withParams:params] addCompleteHandler:^(FPResponse *response) {
            if (response.success) {
                
                NSLog(@"%@",response.data);
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
}


- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

@end
