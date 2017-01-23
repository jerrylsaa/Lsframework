//
//  SplashViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "SplashPresenter.h"
#import "GuideViewController.h"
#import "TabbarViewController.h"

@interface SplashViewController ()<SplashPresenterDelegate>{
    UIImageView* _imageView;
}

@property(nonatomic,retain) SplashPresenter* presenter;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    self.presenter = [SplashPresenter new];
    self.presenter.delegate = self;
    [self.presenter initCommonData];
//    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    
}

-(void)setupView{
    _imageView = [UIImageView new];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([UIScreen mainScreen].bounds.size.height <970&&[UIScreen mainScreen].bounds.size.height >950) {
        _imageView.image = [UIImage imageNamed:@"welcome960"];
    }
    else if ([UIScreen mainScreen].bounds.size.height <1146&&[UIScreen mainScreen].bounds.size.height >1126) {
        _imageView.image = [UIImage imageNamed:@"welcome1136"];
    }
    else if ([UIScreen mainScreen].bounds.size.height <1344&&[UIScreen mainScreen].bounds.size.height >1324) {
        _imageView.image = [UIImage imageNamed:@"welcome1334"];
    }
    else if ([UIScreen mainScreen].bounds.size.height <2218&&[UIScreen mainScreen].bounds.size.height >2198) {
        _imageView.image = [UIImage imageNamed:@"welcome2208"];
    }else {
        _imageView.image = [UIImage imageNamed:@"welcome1334"];

    }
    
    [self.view addSubview:_imageView];
    _imageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark SplashPresenterDelegate

-(void)onInitCommonDataComplete{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstStart"]) {
        //判断是不是第一次登录
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstStart"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController pushViewController:[GuideViewController new] animated:YES];
    }else{
    
        if(!kCurrentUser.isLogin){
            [self.navigationController pushViewController:[LoginViewController sharedLoginViewController] animated:YES];
        }else{
#warning umeng账号统计
            NSString  *user = [NSString stringWithFormat:@"%ld",(long)kCurrentUser.userId];
            [MobClick profileSignInWithPUID:user];
            [self presentViewController:[TabbarViewController new] animated:YES completion:nil];

        }
        
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
