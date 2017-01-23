//
//  BindMyAccountViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BindMyAccountViewController.h"
#import "ZHLoginTextfield.h"
#import "LoginPresenter.h"
#import "TabbarViewController.h"
@interface BindMyAccountViewController ()<LoginPresenterDelegate>{
    UIScrollView *_scrollView;
    UIImageView* _headImage;//头像
    ZHLoginTextfield *_phoneNumberView;
    UIButton *_codeBtn;
    ZHLoginTextfield *_codeTextfield;
    NSTimer * _timer;
    NSUInteger _timeCount;
}
@property (nonatomic, strong) LoginPresenter * presenter;


@end

@implementation BindMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)setupView{
    self.view.backgroundColor=[UIColor whiteColor];//背景色
    _presenter = [LoginPresenter new];
    _presenter.delegate = self;

    _scrollView =[UIScrollView new];
    
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupHeadImageView];
    [self setupBindBtn];
    [self setupCodeView];
}

- (void)setupHeadImageView{
    //添加头像
    CGFloat width = 256/2.0;
    CGFloat height = 256/2.0;
    _headImage=[UIImageView new];
    _headImage.userInteractionEnabled=YES;
    _headImage.image=[UIImage imageNamed:@"HeadIcon"];
    [_scrollView addSubview:_headImage];
    _headImage.sd_layout.topSpaceToView(_scrollView,148/2.0).heightIs(height).widthIs(width).centerXEqualToView(_scrollView);
    
}

- (void)setupBindBtn{
    UILabel *titleLabel =[UILabel new];
    titleLabel.text =@"掌上儿保";
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:20];
    titleLabel.textColor =[UIColor colorWithRed:0.3804 green:0.8471 blue:0.8275 alpha:1.0];
    [_scrollView addSubview:titleLabel];
    titleLabel.sd_layout.topSpaceToView(_headImage,10).centerXEqualToView(_headImage).heightIs(30).widthIs(100);
    _phoneNumberView = [ZHLoginTextfield new];
    //    _phoneNumberView.isCode = YES;
    _phoneNumberView.placeholder = @"手机号";
    [_scrollView addSubview:_phoneNumberView];
    _phoneNumberView.tfType =@"Login";
    _phoneNumberView.image=[UIImage imageNamed:@"bottomline"];
    _phoneNumberView.iconName=@"guyicon";
    _phoneNumberView.placeholder=@"请输入手机号";
    [_phoneNumberView setPlaceholderColor:[UIColor colorWithRed:0.7255 green:0.902 blue:0.8902 alpha:1.0]];
    _phoneNumberView.tf.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    _phoneNumberView.tf.keyboardType = UIKeyboardTypePhonePad;
    
    _phoneNumberView.sd_layout.topSpaceToView(titleLabel,30).heightIs(40).leftSpaceToView(_scrollView, 25).rightSpaceToView(_scrollView, 25).centerXEqualToView(_scrollView);
}
//输入验证码
- (void)setupCodeView{
    
    
    _codeTextfield = [ZHLoginTextfield new];
    //    _phoneNumberView.isCode = YES;
    _codeTextfield.placeholder = @"请输入验证码";
    [_scrollView addSubview:_codeTextfield];
    _codeTextfield.tfType =@"Register";
    _codeTextfield.image=[UIImage imageNamed:@"bottomline"];
    //    _codeTextfield.iconName=@"mmm";
    [_codeTextfield setPlaceholderColor:[UIColor colorWithRed:0.7255 green:0.902 blue:0.8902 alpha:1.0]];
    _codeTextfield.tf.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    _codeTextfield.tf.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextfield.sd_layout.topSpaceToView(_phoneNumberView,30).heightIs(40).leftSpaceToView(_scrollView, 25).rightSpaceToView(_scrollView, 25).centerXEqualToView(_scrollView);
    
    _codeBtn=[UIButton new];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_codeBtn setTitleColor:[UIColor colorWithRed:0.3272 green:0.8197 blue:0.7875 alpha:1.0] forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] forState:UIControlStateHighlighted];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [_codeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_codeBtn];
    _codeBtn.sd_layout.bottomEqualToView(_codeTextfield).rightEqualToView(_codeTextfield).heightIs(40).widthIs(120);
    
    UIButton *bindBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [bindBtn setBackgroundImage:[UIImage imageNamed:@"newloginbar"] forState:UIControlStateNormal];
    [bindBtn setTitle:@"绑定已有账号" forState:UIControlStateNormal];
    
    [bindBtn addTarget:self action:@selector(bindToMyAccount) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:bindBtn];
    bindBtn.sd_layout.topSpaceToView(_codeTextfield,35).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).heightIs(40);
    
    [_scrollView setupAutoContentSizeWithBottomView:bindBtn bottomMargin:30];

}

- (void)bindToMyAccount {
    id responder = [self findFirstResponder];
    if (responder && [responder isKindOfClass:[UITextField class]] ) {
        [responder resignFirstResponder];
    }
    
    [ProgressUtil show];
    [_presenter registerWithPhone:_phoneNumberView.tf.text identifyingCode:_codeTextfield.tf.text];
}

- (void)sendCode{
    //
    [ProgressUtil show];
    //发送验证码
    [_presenter sendIdentifyingCodeToPhone:_phoneNumberView.tf.text];
}

-(void)onBindWeChatComplete:(BOOL)success info:(NSString*)info{
    if (success) {
        kCurrentUser.phone = _phoneNumberView.tf.text;
        
        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
        [ProgressUtil dismiss];
    }else{
        //        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
        [ProgressUtil showError:info];
    }
}

#pragma mark RegisterDelegate

- (void)sendIdentifyingCodeComplete:(BOOL)success{
    if (success) {
        //        _phoneNumberView.codeButton.selected = YES;
        _codeBtn.enabled = NO;
        [self startCountDownTime];
    }
}

-(void)startCountDownTime{
    if (!_timer) {
        _timeCount = 60;
        [_codeBtn setTitle:@"60秒后重新发送" forState:UIControlStateDisabled];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    }
}

-(void)countDown:(id)info{
    _timeCount --;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", _timeCount] forState:UIControlStateDisabled];
    if (_timeCount == 0) {
        _codeBtn.enabled = YES;
        [_timer invalidate];
        _timer = nil;
    }
}

//获取响应者
- (id)findFirstResponder{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subview in self.view.subviews) {
        if ([subview isFirstResponder]&&subview!=nil) {
            return subview;
        }
    }
    return nil;
    
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
