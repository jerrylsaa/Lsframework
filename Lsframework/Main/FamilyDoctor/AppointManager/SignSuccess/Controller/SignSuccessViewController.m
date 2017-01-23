//
//  SignSuccessViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SignSuccessViewController.h"

@interface SignSuccessViewController ()

@end

@implementation SignSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupBackImage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupBackImage{
    UIButton* back = [UIButton new];
    [back setBackgroundImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    back.sd_layout.topSpaceToView(self.view,30).heightIs(22).leftSpaceToView(self.view,15).widthIs(13);
}

-(void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UIImageView* imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"doctor_right"];
    [self.view addSubview:imageView];
    
    UILabel* title = [UILabel new];
    title.text = @"您已签到成功!";
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = UIColorFromRGB(0x535353);
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    imageView.sd_layout.topSpaceToView(self.view,350/2.0).heightIs(300/2.0).widthEqualToHeight().centerXEqualToView(self.view);
    
    title.sd_layout.topSpaceToView(imageView,15).autoHeightRatio(0).centerYEqualToView(imageView).widthIs(kScreenWidth);
    
}

#pragma mark - 点击事件

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
