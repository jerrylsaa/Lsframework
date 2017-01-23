//
//  ForgetPassWordViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ForgetPassWordViewController.h"

#import "FPTextField.h"
#import "ForgetPassWordPresenter.h"
#import "ZHLoginTextfield.h"

@interface ForgetPassWordViewController ()<ForgetPassWordDelegate>
{
    UIScrollView *_scrollView;
    ZHLoginTextfield *_phoneNumberView;
    UIButton *_codeBtn;
    ZHLoginTextfield *_codeTextfield;
    ZHLoginTextfield *_pwdView;
    ZHLoginTextfield *_rePwdView;
    UIButton *_registerButton;
    NSTimer * _timer;
    NSUInteger _timeCount;
}

@property (nonatomic ,strong) ForgetPassWordPresenter *presenter;

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    if (_identifyingCode ==1) {
        self.title = @"忘记密码";
    }
    if (_identifyingCode ==2) {
        self.title = @"忘记钱包密码";
    }
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    _presenter = [ForgetPassWordPresenter new];
    _presenter.delegate = self;
    
    _scrollView =[UIScrollView new];
    
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    [self setupPhoneNumberView];
    [self setupPwdView];
    [self setupCodeView];

    [self setupRegisterButton];
}
//输入手机号
- (void )setupPhoneNumberView{
    
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
    //    _phoneNumberView.texfield.keyboardType = UIKeyboardTypeNumberPad;
    //    [_phoneNumberView.codeButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    //    _phoneNumberView.sd_layout.leftSpaceToView(self.view,25).topSpaceToView(self.view,35).rightSpaceToView(self.view,25).heightIs(40);
    _phoneNumberView.sd_layout.topSpaceToView(_scrollView,40).heightIs(40).leftSpaceToView(_scrollView, 25).rightSpaceToView(_scrollView, 25).centerXEqualToView(_scrollView);

//    _phoneNumberView = [PhoneNumberView new];
//    _phoneNumberView.isCode = YES;
//    _phoneNumberView.placeholder = @"手机号";
//    [self.view addSubview:_phoneNumberView];
//    _phoneNumberView.texfield.keyboardType = UIKeyboardTypeNumberPad;
//    [_phoneNumberView.codeButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
//    _phoneNumberView.sd_layout.leftSpaceToView(self.view,25).topSpaceToView(self.view,35).rightSpaceToView(self.view,25).heightIs(40);
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
    _codeTextfield.sd_layout.topSpaceToView(_rePwdView,15).heightIs(40).leftSpaceToView(_scrollView, 25).rightSpaceToView(_scrollView, 25).centerXEqualToView(_scrollView);
    
    _codeBtn=[UIButton new];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_codeBtn setTitleColor:[UIColor colorWithRed:0.3272 green:0.8197 blue:0.7875 alpha:1.0] forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] forState:UIControlStateHighlighted];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [_codeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_codeBtn];
    _codeBtn.sd_layout.bottomEqualToView(_codeTextfield).rightEqualToView(_codeTextfield).heightIs(40).widthIs(120);

//    _codeView = [UIImageView new];
//    _codeView.userInteractionEnabled = YES;
//    _codeView.clipsToBounds = YES;
//    _codeView.image = [self stretchableImageWithImageName:@"textfield_nor"];
//    [self.view addSubview:_codeView];
//    _codeView.sd_layout.leftSpaceToView(self.view,25).rightSpaceToView(self.view,25).topSpaceToView(_phoneNumberView,15).heightIs(40);
//    _codeView.layer.cornerRadius = _codeView.height/2;
//    
//    _codeTextfield = [UITextField new];
//    _codeTextfield.textColor = [UIColor whiteColor];
//    _codeTextfield.font = [UIFont systemFontOfSize:kScreenWidth == 320 ? 14 : 18];
//    _codeTextfield.delegate = self;
//    _codeTextfield.keyboardType = UIKeyboardTypeNumberPad;
//    _codeTextfield.backgroundColor = [UIColor clearColor];
//    _codeTextfield.placeholder = @"请输入验证码";
//    [_codeTextfield setValue:UIColorFromRGB(0xffffff) forKeyPath:@"_placeholderLabel.textColor"];
//    [_codeView addSubview:_codeTextfield];
//    _codeTextfield.sd_layout.leftSpaceToView(_codeView,25).rightSpaceToView(_codeView,0).heightIs(40);
}

- (void)setupPwdView{
    //密码
    _pwdView = [ZHLoginTextfield new];
    //    _phoneNumberView.isCode = YES;
    _pwdView.placeholder = @"请输入新密码";
    [_scrollView addSubview:_pwdView];
    _pwdView.tfType =@"Login";
    _pwdView.tf.secureTextEntry=YES;
    _pwdView.image=[UIImage imageNamed:@"bottomline"];
    _pwdView.iconName=@"mmm";
    [_pwdView setPlaceholderColor:[UIColor colorWithRed:0.7255 green:0.902 blue:0.8902 alpha:1.0]];
    _pwdView.tf.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    _pwdView.tf.keyboardType = UIKeyboardTypePhonePad;
    _pwdView.sd_layout.topSpaceToView(_phoneNumberView,15).heightIs(40).leftSpaceToView(_scrollView, 25).rightSpaceToView(_scrollView, 25).centerXEqualToView(_scrollView);
    
    _rePwdView = [ZHLoginTextfield new];
    //    _phoneNumberView.isCode = YES;
    _rePwdView.placeholder = @"请确认新密码";
    [_scrollView addSubview:_rePwdView];
    _rePwdView.tfType =@"Login";
    _rePwdView.tf.secureTextEntry=YES;
    _rePwdView.image=[UIImage imageNamed:@"bottomline"];
    _rePwdView.iconName=@"mmm";
    [_rePwdView setPlaceholderColor:[UIColor colorWithRed:0.7255 green:0.902 blue:0.8902 alpha:1.0]];
    _rePwdView.tf.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    _rePwdView.tf.keyboardType = UIKeyboardTypePhonePad;
    _rePwdView.sd_layout.topSpaceToView(_pwdView,15).heightIs(40).leftSpaceToView(_scrollView, 25).rightSpaceToView(_scrollView, 25).centerXEqualToView(_scrollView);

//    //密码
//    _pwdView = [PhoneNumberView new];
//    _pwdView.placeholder = @"请输入新密码";
//    [self.view addSubview:_pwdView];
//    _pwdView.sd_layout.leftSpaceToView(self.view,25).rightSpaceToView(self.view,25).topSpaceToView(_codeView,15).heightIs(40);
//    //重复密码
//    _rePwdView = [PhoneNumberView new];
//    _rePwdView.placeholder = @"请输入新密码";
//    [self.view addSubview:_rePwdView];
//    _rePwdView.sd_layout.leftSpaceToView(self.view,25).rightSpaceToView(self.view,25).topSpaceToView(_pwdView,15).heightIs(40);
}
//提交按钮
- (void)setupRegisterButton{
//    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _registerButton.clipsToBounds = YES;
//    [_registerButton setBackgroundImage:[self stretchableImageWithImageName:@"commit_nor"] forState:UIControlStateNormal];
//    [_registerButton setBackgroundImage:[self stretchableImageWithImageName:@"commit_hightlight"] forState:UIControlStateHighlighted];
//    [_registerButton setBackgroundImage:[self stretchableImageWithImageName:@"commit_sel"] forState:UIControlStateSelected];
//    [_registerButton setTitle:@"提交" forState:UIControlStateNormal];
//    [_registerButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_registerButton];
//    _registerButton.sd_layout.leftSpaceToView(self.view,25).rightSpaceToView(self.view,25).topSpaceToView(_rePwdView,15).heightIs(40);
//    _registerButton.layer.cornerRadius = _registerButton.height/2;
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"newloginbar"] forState:UIControlStateNormal];
    //    [_registerButton setBackgroundImage:[self stretchableImageWithImageName:@"commit_hightlight"] forState:UIControlStateHighlighted];
    //    [_registerButton setBackgroundImage:[self stretchableImageWithImageName:@"commit_sel"] forState:UIControlStateSelected];
    [_registerButton setTitle:@"提交" forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_registerButton];
    //    _registerButton.sd_layout.leftSpaceToView(self.view,25).rightSpaceToView(self.view,25).topSpaceToView(_rePwdView,15).heightIs(40);
    _registerButton.sd_layout.topSpaceToView(_codeTextfield,40).centerXEqualToView(_scrollView).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).heightIs(40);
    //    _registerButton.layer.cornerRadius = _registerButton.height/2;
    [_scrollView setupAutoContentSizeWithBottomView:_registerButton bottomMargin:30];
}

-(void)countDown:(id)info{
    _timeCount --;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", _timeCount] forState:UIControlStateDisabled];
    if (_timeCount == -1) {
        _codeBtn.enabled = YES;
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sendCode{
    //
    [ProgressUtil show];
    //发送验证码
    [_presenter sendIdentifyingCodeToPhone:_phoneNumberView.tf.text with:_identifyingCode];
}
- (void)commitAction{
    //收起键盘，提交注册
    id responder = [self findFirstResponder];
    if (responder && [responder isKindOfClass:[UITextField class]] ) {
        [responder resignFirstResponder];
    }
    
    [ProgressUtil show];
    [_presenter commitWithPhone:_phoneNumberView.tf.text
                  identifyingCode:_codeTextfield.tf.text
                         password:_pwdView.tf.text
                       rePassword:_rePwdView.tf.text
                        identifyCode:_identifyingCode];
    
    //    [self.navigationController pushViewController:[RegSuccessViewController new] animated:YES];
    
}
//裁减拉伸图片
- (UIImage *)stretchableImageWithImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect myImageRect = CGRectMake(image.size.width/2 - 1, image.size.height/2 -1 , 3, 3);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size = CGSizeMake(myImageRect.size.width, myImageRect.size.height);
    UIGraphicsBeginImageContext (size);
    CGContextRef context = UIGraphicsGetCurrentContext ();
    CGContextDrawImage (context, myImageRect, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage :subImageRef];
    UIGraphicsEndImageContext ();
    image = [newImage stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    return image;
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

#pragma mark ForgetPassWordDelegate

- (void)sendIdentifyingCodeComplete:(BOOL)success{
    if (success == YES) {
        NSLog(@"1111");
        _codeBtn.enabled = NO;
        [self startCountDownTime];

    }
}

- (void)commitComplete:(BOOL)success info:(NSString *)info{
    if (success == YES) {
        NSLog(@"111-111-111");
        [ProgressUtil showSuccess:info];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [ProgressUtil showError:info];
    }
}

#pragma mark - 
-(void)startCountDownTime{
    if (!_timer) {
        _timeCount = 60;
        [_codeBtn setTitle:@"60秒后重新发送" forState:UIControlStateDisabled];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    }
}


@end
