//
//  SetUpController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SetUpController.h"
#import "PrivateSetupViewController.h"
#import "ChangePwdController.h"
#import "PostNotiController.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "DefaultChildEntity.h"
#import "ChangeWalletPwdViewController.h"
@interface SetUpController ()
@property (weak, nonatomic) IBOutlet UIView *privateSetupView;
@property (weak, nonatomic) IBOutlet UIView *changePwdView;
@property (weak, nonatomic) IBOutlet UIView *postNotiView;

@property (weak, nonatomic) IBOutlet UIButton *logoutView;
@property (weak, nonatomic) IBOutlet UIView *changeWalletPwdView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation SetUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"设置";
    self.versionLabel.text =[NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    [self setupGesture];
}

- (void)setupGesture{
    UITapGestureRecognizer* tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPrivateView)];
    [_privateSetupView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer* tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushChangePwdView)];
    [_changePwdView addGestureRecognizer:tap2];

    UITapGestureRecognizer* tap3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushNotiView)];
    [_postNotiView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer* tap4=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushChangeWalletPwdView)];
    [_changeWalletPwdView addGestureRecognizer:tap4];
    
    [_logoutView addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushPrivateView {
    PrivateSetupViewController * privateCtrl =[[PrivateSetupViewController alloc]init];
    [self.navigationController pushViewController:privateCtrl animated:YES];
}

- (void)pushChangePwdView {
    ChangePwdController * changeCtrl =[[ChangePwdController alloc]init];
    [self.navigationController pushViewController:changeCtrl animated:YES];

}

- (void)pushChangeWalletPwdView {
    ChangeWalletPwdViewController * changeCtrl =[[ChangeWalletPwdViewController alloc]init];
    [self.navigationController pushViewController:changeCtrl animated:YES];
    
}

- (void)pushNotiView {
    PostNotiController * notiCtrl =[[PostNotiController alloc]init];
    [self.navigationController pushViewController:notiCtrl animated:YES];
    
}

- (void)logout {
    
    
//    [UIApplication sharedApplication].keyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[LoginViewController new]];
//    [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:nil];
//    [ProgressUtil dismiss];
    
//    [MobClick  profileSignOff];  //umeng账号登出
        
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberPsw"];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOutAction object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-我的设置页面"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-我的设置页面"];
    
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
