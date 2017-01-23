//
//  LoginViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "LoginViewController.h"
#import "ZHLoginTextfield.h"
#import "TabbarViewController.h"
#import "RegisterViewController.h"
#import "LoginPresenter.h"
#import "ForgetPassWordViewController.h"
#import "WXApi.h"
#import "BindToWeChatViewController.h"

@interface LoginViewController ()<LoginPresenterDelegate,WXApiDelegate>{
    UIScrollView *_scrollView;
    UIImageView* _headImage;//头像
    ZHLoginTextfield* _phonetf;//手机号数输入框
    ZHLoginTextfield* _pswtf;//密码输入框
    UIButton* _rememberBt;//记住密码按钮
    UILabel* _rememberpswLabel;//记住密码label
}

@property (nonatomic, strong) LoginPresenter * presenter;

@end

@implementation LoginViewController

+(LoginViewController *)sharedLoginViewController{
    static dispatch_once_t predicate;
    static LoginViewController * loginViewController;
    dispatch_once(&predicate, ^{
        loginViewController=[[LoginViewController alloc] init];
    });
    return loginViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformCodetoAccess_token:) name:Notification_WeXinLogin object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setupView{
    self.view.backgroundColor=[UIColor whiteColor];//背景色
    _presenter = [LoginPresenter new];
    _presenter.delegate = self;
    
    _scrollView =[UIScrollView new];
    
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    [self setupHeadImageView];
    [self setupLoginTextfield];
//    [self setupRememberPswButton];
    [self setupLoginRegisterButton];
//    [self setupRememberpswLabel];

//    //test

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rememberPsw"]){
        _phonetf.tf.text = kCurrentUser.phone;
        _pswtf.tf.text = kCurrentUser.userPasswd;
        [_rememberBt setSelected:YES];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rememberAccount"]){
        _phonetf.tf.text = kCurrentUser.phone;
    }
}

#pragma mark LoginPresenterDelegate

-(void)onLoginComplete:(BOOL)success info:(NSString *)info{
    if (success) {
        kCurrentUser.phone = _phonetf.tf.text;
        kCurrentUser.userPasswd = _pswtf.tf.text;

        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
        [ProgressUtil dismiss];
    }else{
//        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
        [ProgressUtil showError:info];
    }

}



- (void)onLoginWeChatComplete:(BOOL)success info:(NSString*)info Dictionary:(NSDictionary *)dict{
    if (success) {
//        kCurrentUser.phone = _phonetf.tf.text;
//        kCurrentUser.userPasswd = _pswtf.tf.text;
        if (dict ==nil) {
            [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
            [ProgressUtil dismiss];
        }else{
            NSString *uuid =[dict objectForKey:@"uuid"];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:uuid forKey:@"MyWeChatUuid"];
            [defaults synchronize];
            [self presentViewController:[BindToWeChatViewController new] animated:YES completion:^{
                
            }];
        }
        
    }else{
        //        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
        [ProgressUtil showError:info];
    }

    
}

#pragma mark - 头像
- (void)setupHeadImageView{
    //添加头像
    CGFloat width = 256/2.0;
    CGFloat height = 256/2.0;
    _headImage=[UIImageView new];
    _headImage.userInteractionEnabled=YES;
    _headImage.image=[UIImage imageNamed:@"HeadIcon"];
    [_scrollView addSubview:_headImage];
    _headImage.sd_layout.topSpaceToView(_scrollView,40/2.0).heightIs(height).widthIs(width).centerXEqualToView(_scrollView);
    
}

#pragma mark - 输入框
- (void)setupLoginTextfield{
   
    UILabel *titleLabel =[UILabel new];
    titleLabel.text =@"掌上儿保";
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:20];
    titleLabel.textColor =[UIColor colorWithRed:0.3804 green:0.8471 blue:0.8275 alpha:1.0];
    [_scrollView addSubview:titleLabel];
    titleLabel.sd_layout.topSpaceToView(_headImage,10).centerXEqualToView(_headImage).heightIs(30).widthIs(100);
    
    //手机号输入框

    CGFloat height = 40;
    _phonetf=[ZHLoginTextfield new];
    _phonetf.tfType =@"Login";
    _phonetf.image=[UIImage imageNamed:@"bottomline"];
    _phonetf.iconName=@"guyicon";
    _phonetf.placeholder=@"请输入手机号";
    [_phonetf setPlaceholderColor:[UIColor colorWithRed:0.7255 green:0.902 blue:0.8902 alpha:1.0]];
    _phonetf.tf.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    _phonetf.tf.keyboardType = UIKeyboardTypePhonePad;
    [_scrollView addSubview:_phonetf];
    _phonetf.sd_layout.topSpaceToView(titleLabel,30).heightIs(height).leftSpaceToView(_scrollView, 25).rightSpaceToView(_scrollView, 25).centerXEqualToView(_scrollView);
    //密码输入框
    _pswtf=[ZHLoginTextfield new];
    _pswtf.tfType =@"Login";
    _pswtf.image=[UIImage imageNamed:@"bottomline"];
    _pswtf.iconName=@"mmm";
    _pswtf.placeholder=@"请输入密码";
    [_pswtf setPlaceholderColor:[UIColor colorWithRed:0.7255 green:0.902 blue:0.8902 alpha:1.0]];
    _pswtf.tf.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    _pswtf.tf.secureTextEntry=YES;
    [_scrollView addSubview:_pswtf];
    _pswtf.sd_layout.topSpaceToView(_phonetf,15).centerXEqualToView(_scrollView).widthRatioToView(_phonetf,1).heightRatioToView(_phonetf,1);
}

#pragma mark - 记住密码按钮
- (void)setupRememberPswButton{
    _rememberBt=[UIButton new];
    [_rememberBt setBackgroundImage:[UIImage imageNamed:@"remeberpsw_nor"] forState:UIControlStateNormal];
    [_rememberBt setBackgroundImage:[UIImage imageNamed:@"remeberpsw_sel"] forState:UIControlStateSelected];
    [_rememberBt addTarget:self action:@selector(rememberPswAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rememberBt];
    [_pswtf updateLayout];
    _rememberBt.sd_layout.topSpaceToView(_pswtf,15).heightIs(15).widthIs(15).leftSpaceToView(self.view, 50);
}

#pragma mark - 记住密码label
- (void)setupRememberpswLabel{
//    _rememberpswLabel=[UILabel new];
//    _rememberpswLabel.textColor=UIColorFromRGB(0xffffff);
//    _rememberpswLabel.font=[UIFont systemFontOfSize:16];
//    _rememberpswLabel.text=@"记住密码";
//    [self.view addSubview:_rememberpswLabel];
//    _rememberpswLabel.sd_layout.topEqualToView(_rememberBt).heightRatioToView(_rememberBt,1).leftSpaceToView(_rememberBt, 15).widthIs(120);
    //忘记密码
//    UILabel* forgetpswLabel=[UILabel new];
//    forgetpswLabel.textColor=UIColorFromRGB(0xffffff);
//    forgetpswLabel.font=[UIFont systemFontOfSize:16];
//    forgetpswLabel.text=@"忘记密码?";
//    forgetpswLabel.textAlignment=NSTextAlignmentRight;
//    [self.view addSubview:forgetpswLabel];
//    forgetpswLabel.sd_layout.topEqualToView(_rememberBt).heightRatioToView(_rememberBt,1).rightEqualToView(_pswtf);
    
    
}

#pragma mark - 注册登录按钮
- (void)setupLoginRegisterButton{
    //背景
//    UIImageView* bgImageView=[UIImageView new];
//    bgImageView.userInteractionEnabled=YES;
//    bgImageView.backgroundColor =[UIColor colorWithRed:0.3804 green:0.8471 blue:0.8275 alpha:1.0];
////    bgImageView.image=[UIImage imageNamed:@"textfield_nor"];
//    [self.view addSubview:bgImageView];
//    bgImageView.sd_layout.leftEqualToView(_pswtf).rightEqualToView(_pswtf).topSpaceToView(_rememberBt,15).heightRatioToView(_pswtf,1);
    
    
    //登录按钮
    UIButton* loginbt=[UIButton new];
    [loginbt setBackgroundImage:[UIImage imageNamed:@"newloginbar"] forState:UIControlStateNormal];
//    [loginbt setBackgroundImage:[UIImage imageNamed:@"slider_sel"] forState:UIControlStateHighlighted];
    [loginbt setTitle:@"登录" forState:UIControlStateNormal];
    loginbt.tag=201;
    [loginbt addTarget:self action:@selector(loginRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:loginbt];
    loginbt.sd_layout.topSpaceToView(_pswtf,40).centerXEqualToView(_scrollView).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).heightIs(40);
    
    
    //注册按钮
    UIButton* registerbt=[UIButton new];
    registerbt.titleLabel.font = [UIFont systemFontOfSize:16];
    [registerbt setTitleColor:[UIColor colorWithRed:0.3272 green:0.8197 blue:0.7875 alpha:1.0] forState:UIControlStateNormal];
    [registerbt setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] forState:UIControlStateHighlighted];
    [registerbt setTitle:@"去注册" forState:UIControlStateNormal];
    registerbt.tag=200;
    [registerbt addTarget:self action:@selector(loginRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:registerbt];
    registerbt.sd_layout.topSpaceToView(loginbt,10).rightEqualToView(loginbt).heightIs(30).widthIs(60);
    
    
    
    //忘记密码
    UIButton *forgetPswButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPswButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPswButton setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
    forgetPswButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [forgetPswButton addTarget:self action:@selector(forgetPwdAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:forgetPswButton];
    forgetPswButton.sd_layout.topSpaceToView(loginbt,10).leftEqualToView(loginbt).heightIs(30).widthIs(80);
    
    UIImageView *lineIV =[UIImageView new];
    if ([WXApi isWXAppInstalled]) {
        lineIV.hidden =NO;
        
    }else{
        lineIV.hidden =YES;
    }
    lineIV.backgroundColor =[UIColor colorWithRed:0.3272 green:0.8197 blue:0.7875 alpha:1.0];
    [_scrollView addSubview:lineIV];
    lineIV.sd_layout.topSpaceToView(forgetPswButton,20).leftSpaceToView(_scrollView,45).rightSpaceToView(_scrollView,45).heightIs(1);
    
    UILabel *wxLabel =[UILabel new];
    if ([WXApi isWXAppInstalled]) {
        wxLabel.hidden =NO;
        
    }else{
        wxLabel.hidden =YES;
    }
    wxLabel.backgroundColor =[UIColor whiteColor];
    wxLabel.text =@"微信登录";
    wxLabel.textAlignment =NSTextAlignmentCenter;
    wxLabel.font = [UIFont systemFontOfSize:16];
    wxLabel.textColor =[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    [_scrollView addSubview:wxLabel];
    wxLabel.sd_layout.centerYEqualToView(lineIV).centerXEqualToView(_scrollView).heightIs(16).widthIs(68);


    
    UIButton *wxBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    if ([WXApi isWXAppInstalled]) {
        wxBtn.hidden =NO;
        
    }else{
        wxBtn.hidden =YES;
    }
    [wxBtn setImage:[UIImage imageNamed:@"WeChatIcon"] forState:UIControlStateNormal];
    [wxBtn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] forState:UIControlStateNormal];
    
    [wxBtn addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:wxBtn];
    wxBtn.sd_layout.topSpaceToView(lineIV,20).centerXEqualToView(_scrollView).heightIs(46).widthIs(46);
    
    [_scrollView setupAutoContentSizeWithBottomView:wxBtn bottomMargin:30];

}

#pragma mark - 按钮点击事件
/**
 *  记住密码按钮
 *
 *  @param bt <#bt description#>
 */
- (void)rememberPswAction:(UIButton*) bt{
    bt.selected=!bt.selected;
    /*
    if (!bt.selected) {
        kCurrentUser.phone = nil;
        kCurrentUser.userPasswd = nil;
    }
     */
}

//微信登录

- (void)sendAuthRequest {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    [WXApi sendAuthReq:req viewController:self delegate:[UIApplication sharedApplication].delegate];
}

- (void)transformCodetoAccess_token:(NSNotification *)object {
    NSString *code =[[object userInfo] valueForKey:@"authRespCode"];
    [ProgressUtil show];
    [_presenter loginWithWeChatCode:code];
}

- (void)loginRegisterAction:(UIButton*) bt{
    if(bt.tag==200){
    //注册
        [self presentViewController:[RegisterViewController new] animated:YES completion:^{
            
        }];

//        [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
    }else if(bt.tag==201){
        [ProgressUtil show];
        
//        _phonetf.tf.text = @"15700160182";
//        _pswtf.tf.text = @"234567";
//        _phonetf.tf.text = @"15806622232";//测试
//        _pswtf.tf.text = @"1qaz2wsx";
//        _phonetf.tf.text = @"13789812873";//测试
//        _pswtf.tf.text = @"123456";
//        _phonetf.tf.text = @"15521020331";
//        _pswtf.tf.text = @"000000";
        
/*
        if (_rememberBt.selected) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberPsw"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"rememberPsw"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
 */
//    //登录
        [_presenter loginWithUserName:_phonetf.tf.text withPasswd:_pswtf.tf.text];
#pragma mark - umeng账号统计
        NSString  *user = [NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId];
        //    kCurrentUser.userId
        [MobClick profileSignInWithPUID:user];


    }
}

- (void)forgetPwdAction{
    ForgetPassWordViewController *vc =[ForgetPassWordViewController new];
    vc.identifyingCode =1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_WeXinLogin object:nil];
}

@end
