//
//  BindToWeChatViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BindToWeChatViewController.h"
#import "RegisterViewController.h"
#import "BindMyAccountViewController.h"


@interface BindToWeChatViewController (){
    UIScrollView *_scrollView;
    UIImageView* _headImage;//头像
}

@end

@implementation BindToWeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    self.view.backgroundColor=[UIColor whiteColor];//背景色
    
    _scrollView =[UIScrollView new];
    
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupHeadImageView];
    [self setupBindBtn];
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

    
    
    UIButton *haveBindBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [haveBindBtn setBackgroundImage:[UIImage imageNamed:@"newloginbar"] forState:UIControlStateNormal];
    [haveBindBtn setTitle:@"绑定已有账号" forState:UIControlStateNormal];
    
    [haveBindBtn addTarget:self action:@selector(bindToMyAccount) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:haveBindBtn];
    haveBindBtn.sd_layout.topSpaceToView(titleLabel,90).centerXEqualToView(_scrollView).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).heightIs(40);
    
    UIButton *registerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"newloginbar"] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册新账号" forState:UIControlStateNormal];
    
    [registerBtn addTarget:self action:@selector(registerNewAccount) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:registerBtn];
    registerBtn.sd_layout.topSpaceToView(haveBindBtn,20).centerXEqualToView(_scrollView).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).heightIs(40);
    
    [_scrollView setupAutoContentSizeWithBottomView:registerBtn bottomMargin:30];
}

- (void)bindToMyAccount {
    [self presentViewController:[BindMyAccountViewController new] animated:YES completion:^{
        
    }];
}

- (void)registerNewAccount {
    RegisterViewController *vc =[RegisterViewController new];
    vc.registerWay =@"WeChatToRegister";
    [self presentViewController:vc animated:YES completion:^{
        
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
