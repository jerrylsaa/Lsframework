//
//  RegSuccessViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//
#define kWidthScale (kScreenWidth/375)
#define kHeightScale (kScreenHeight/667)

#import "RegSuccessViewController.h"
#import "ArchivesRecordViewController.h"
#import "TabbarViewController.h"
#import "ArchivesMainViewController.h"
#import "NeonateViewController.h"
#import "GestationViewController.h"
#import "FamilyHistoryViewController.h"

@interface RegSuccessViewController ()
{
    UIImageView *_imageView;
    UILabel *_congratulations;
    UIImageView *_headImageView;
    UILabel *_tips_1;
    UILabel *_tips_2;
    UIButton *_immediatelyButton;
    UIButton *_laterButton;
}

@end

@implementation RegSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    [self setupImageView];
    [self setupHeadImageView];
    [self setupCongratulations];
    [self setupTips];
    [self setupButtons];
}
//背景图
- (void)setupImageView{
    _imageView = [UIImageView new];
    _imageView.frame = self.view.bounds;
    _imageView.image = [UIImage imageNamed:@"regsuccess"];
    _imageView.contentMode =  UIViewContentModeScaleToFill;
    [self.view addSubview:_imageView];
}
//头像
- (void)setupHeadImageView{
    _headImageView = [UIImageView new];
    _headImageView.backgroundColor = [UIColor brownColor];
    _headImageView.clipsToBounds = YES;
    [self.view addSubview:_headImageView];
    _headImageView.sd_layout.topSpaceToView(self.view,140*kHeightScale).widthIs(150*kWidthScale).heightIs(150*kWidthScale);
    _headImageView.centerX = self.view.centerX;
    _headImageView.image = [UIImage imageNamed:@"doctor_icon"];
    _headImageView.layer.cornerRadius = _headImageView.height/2;
    
}
//恭喜注册成功
- (void)setupCongratulations{
    _congratulations = [UILabel new];
    _congratulations.text = @"恭喜您，注册成功！";
    _congratulations.font = [UIFont systemFontOfSize:20];
    _congratulations.textAlignment = NSTextAlignmentCenter;
    _congratulations.textColor = [UIColor whiteColor];
    [self.view addSubview:_congratulations];
    _congratulations.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(_headImageView,27).heightIs(25);
}
//提示语
- (void)setupTips{
    _tips_1 = [UILabel new];
    _tips_1.text = @"需要继续添加宝宝档案信息吗，";
    _tips_1.textAlignment = NSTextAlignmentCenter;
//    _tips_1.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"code_nor"]];
    _tips_1.textColor = RGB(100, 204, 196);
    [self.view addSubview:_tips_1];
    _tips_1.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(_headImageView,35).heightIs(25);
    
    _tips_2 = [UILabel new];
    _tips_2.text = @"添加后便可享受便捷的儿童健康服务";
    _tips_2.textAlignment = NSTextAlignmentCenter;
    _tips_2.textColor = _tips_1.textColor;
    [self.view addSubview:_tips_2];
    _tips_2.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(_tips_1,10).heightIs(25);
}
//马上添加和以后再说按钮
- (void)setupButtons{
    _immediatelyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_immediatelyButton setBackgroundImage:[UIImage imageNamed:@"immediately"] forState:UIControlStateNormal];
    [_immediatelyButton addTarget:self action:@selector(immediatelyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_immediatelyButton];
    
    _laterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_laterButton setBackgroundImage:[UIImage imageNamed:@"later"] forState:UIControlStateNormal];
    [_laterButton addTarget:self action:@selector(laterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_laterButton];
    
    CGFloat spaceY = kScreenHeight == 480 ? 30 : 65;
    _immediatelyButton.sd_layout.topSpaceToView(_tips_2,spaceY).widthIs(122).heightIs(40);
    _immediatelyButton.centerX = self.view.centerX;
    _laterButton.sd_layout.topSpaceToView(_immediatelyButton,15).widthIs(_immediatelyButton.width).heightIs(_immediatelyButton.height);
    _laterButton.centerX = _immediatelyButton.centerX;
}

#pragma mark Action
- (void)immediatelyAction{
    //马上添加
    [self.navigationController pushViewController:[ArchivesMainViewController new] animated:YES];
}
- (void)laterAction{
    //以后再说
    [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
}

#pragma mark Life

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
