//
//  ACSuccessPageViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACSuccessPageViewController.h"
#import "TabbarViewController.h"

@interface ACSuccessPageViewController (){
    UIImageView* _bgImageView;
    UIImageView* _headerImageView;
    UILabel* _bottomLabel;
}

@end

@implementation ACSuccessPageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)setupView{
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
 
    [self setupBgImageView];
    [self setupHedaerImageView];
    [self setupTitleLabel];
    [self setupCommitButton];
}

/**
 *  背景
 */
- (void)setupBgImageView{
    _bgImageView=[UIImageView new];
    _bgImageView.image=[UIImage imageNamed:@"commit_success_bg"];
    [self.view addSubview:_bgImageView];
    _bgImageView.sd_layout.topSpaceToView(self.view,0).heightIs(314/2.0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0);
}

/**
 *  头像
 */
- (void)setupHedaerImageView{
    [_bgImageView updateLayout];
    _headerImageView=[UIImageView new];
    _headerImageView.image=[UIImage imageNamed:@"correct"];
    [self.view addSubview:_headerImageView];
    _headerImageView.sd_layout.centerYIs(_bgImageView.bottom).centerXEqualToView(self.view).widthIs(150).heightEqualToWidth();
}

/**
 *  标题
 */
- (void)setupTitleLabel{
    UILabel* title=[UILabel new];
    title.textColor=UIColorFromRGB(0xf3c156);
    title.font=[UIFont systemFontOfSize:18];
    title.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:title];
    title.text=@"您的咨询提交成功!";
    
    UILabel* midTitle=[UILabel new];
    midTitle.textColor=title.textColor;
    midTitle.font=[UIFont boldSystemFontOfSize:17];
    midTitle.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:midTitle];
    midTitle.text=@"医生团队将尽力在24小时内给您回复";
    
    _bottomLabel=[UILabel new];
    _bottomLabel.textColor=title.textColor;
    _bottomLabel.font=title.font;
    _bottomLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_bottomLabel];
    _bottomLabel.text=@"请注意查看消息";
    
    CGFloat height=30;
    if(kScreenHeight==480){
        height=15;
    }
    
    title.sd_layout.topSpaceToView(_headerImageView,height).heightIs(20).widthIs(kScreenWidth).centerXEqualToView(self.view);
    
    CGFloat midHeight=20;
    if(kScreenHeight==480){
        midHeight=15;
    }
    
    midTitle.sd_layout.topSpaceToView(title,midHeight).heightIs(20).widthIs(kScreenWidth).centerXEqualToView(self.view);
    
    _bottomLabel.sd_layout.topSpaceToView(midTitle,20).heightIs(midHeight).widthIs(kScreenWidth).centerXEqualToView(self.view);

}

/**
 *  提交
 */
- (void)setupCommitButton{
    UIButton* backbt=[UIButton new];
    [backbt setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [backbt setTitle:@"返回首页" forState:UIControlStateNormal];
    [backbt addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    backbt.tag=201;
    [self.view addSubview:backbt];
    
//    UIButton* morebt=[UIButton new];
//    [morebt setBackgroundImage:[UIImage imageNamed:@"konwmore"] forState:UIControlStateNormal];
//    [morebt setTitle:@"了解更多疾病知识" forState:UIControlStateNormal];
//    [morebt setTitleColor:UIColorFromRGB(0xf3c156) forState:UIControlStateNormal];
//    [morebt addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
//    morebt.tag=202;
//    [self.view addSubview:morebt];
    
    CGFloat height=145/2.0;
    if(kScreenHeight==480){
        height=55/2.0;
    }
    
    backbt.sd_layout.topSpaceToView(_bottomLabel,height).heightIs(40).leftSpaceToView(self.view,25).rightSpaceToView(self.view,25);
    
//    morebt.sd_layout.topSpaceToView(backbt,20).heightIs(40).leftSpaceToView(self.view,25).rightSpaceToView(self.view,25);

}

#pragma mark - 点击事件
- (void)backHomeAction:(UIButton*) bt{
    if(bt.tag==201){
    //跳转首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
    //了解更多
    }
}

@end
