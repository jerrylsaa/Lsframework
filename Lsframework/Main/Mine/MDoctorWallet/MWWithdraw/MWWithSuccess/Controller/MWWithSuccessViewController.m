//
//  MWWithSuccessViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWWithSuccessViewController.h"

@interface MWWithSuccessViewController (){
    UIScrollView* _scrollView;
    UIImageView* _bgImageView;
    UIImageView* _headerImageView;
    
    UILabel* _detailInfo;
}

@end

@implementation MWWithSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)setupView{
    
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    
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
    [_scrollView addSubview:_bgImageView];
    _bgImageView.sd_layout.topSpaceToView(_scrollView,-20).heightIs(314/2.0).leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0);
}

/**
 *  头像
 */
- (void)setupHedaerImageView{
    [_bgImageView updateLayout];
    _headerImageView=[UIImageView new];
    _headerImageView.image=[UIImage imageNamed:@"correct"];
    [_scrollView addSubview:_headerImageView];
    _headerImageView.sd_layout.centerYIs(_bgImageView.bottom).centerXEqualToView(_scrollView).widthIs(150).heightEqualToWidth();
}

/**
 *  标题
 */
- (void)setupTitleLabel{
    UILabel* title=[UILabel new];
    title.textColor=UIColorFromRGB(0xf3c156);
    title.font=[UIFont systemFontOfSize:18];
    title.textAlignment=NSTextAlignmentCenter;
    title.text= @"提现申请成功!";
    [_scrollView addSubview:title];
    CGFloat height=30;
    title.sd_layout.topSpaceToView(_headerImageView,height).autoHeightRatio(0).leftEqualToView(_scrollView).rightEqualToView(_scrollView);
    
    UILabel* detail=[UILabel new];
    detail.textColor=UIColorFromRGB(0x5FCCC7);
    detail.font=[UIFont boldSystemFontOfSize:16];
    detail.textAlignment=NSTextAlignmentCenter;
    detail.text= @"预计处理时间5-7个工作日";
    [_scrollView addSubview:detail];
    detail.sd_layout.topSpaceToView(title,70).autoHeightRatio(0).leftEqualToView(_scrollView).rightEqualToView(_scrollView);
    
    _detailInfo=[UILabel new];
    _detailInfo.textColor=UIColorFromRGB(0x5FCCC7);
    _detailInfo.font=[UIFont boldSystemFontOfSize:16];
    _detailInfo.textAlignment=NSTextAlignmentCenter;
    _detailInfo.text= @"请您随时查看您的账户信息";
    [_scrollView addSubview:_detailInfo];
    _detailInfo.sd_layout.topSpaceToView(detail,10).autoHeightRatio(0).leftEqualToView(_scrollView).rightEqualToView(_scrollView);
}

/**
 *  提交
 */
- (void)setupCommitButton{
    UIButton* confirm=[UIButton new];
    [confirm setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [confirm setTitle:@"确认" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:confirm];
    
    confirm.sd_layout.topSpaceToView(_detailInfo,75).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
    
    [_scrollView setupAutoContentSizeWithBottomView:confirm bottomMargin:10];


}


#pragma mark - 点击事件
- (void)confirmAction{
    NSLog(@"确认");
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


@end
