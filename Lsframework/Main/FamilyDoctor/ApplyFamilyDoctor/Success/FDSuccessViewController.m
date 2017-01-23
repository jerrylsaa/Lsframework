//
//  FDSuccessViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDSuccessViewController.h"
#import "TabbarViewController.h"

@interface FDSuccessViewController (){
    UIScrollView* _scroll;
    UIImageView* _bgImageView;
    UIImageView* _headerImageView;
    UILabel* _successTitleLabel;
    UIView* _contentView;
    UIView* _commitContainerView;
    UILabel* _tipsLabel;
}

@end

@implementation FDSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - 加载子视图
-(void)setupView{
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    
    _scroll = [UIScrollView new];
    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    [self setupBgImageView];
    [self setupHedaerImageView];
    [self setupTitleLabel];
    [self setupContentView];
    [self setupCommitButton];
    [self setupTipsLabel];
}

/**
 *  背景
 */
- (void)setupBgImageView{
    _bgImageView=[UIImageView new];
    _bgImageView.image=[UIImage imageNamed:@"commit_success_bg"];
    [_scroll addSubview:_bgImageView];
    _bgImageView.sd_layout.topSpaceToView(_scroll,-20).heightIs(314/2.0).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
}

/**
 *  头像
 */
- (void)setupHedaerImageView{
    _headerImageView=[UIImageView new];
    _headerImageView.image=[UIImage imageNamed:@"correct"];
    [_scroll addSubview:_headerImageView];
    _headerImageView.sd_layout.topSpaceToView(_bgImageView,-150/2.0).centerXEqualToView(_scroll).widthIs(150).heightEqualToWidth();
}

/**
 *  标题
 */
- (void)setupTitleLabel{
    _successTitleLabel = [UILabel new];
    _successTitleLabel.textColor=UIColorFromRGB(0xf3c156);
    _successTitleLabel.font=[UIFont systemFontOfSize:18];
    _successTitleLabel.textAlignment=NSTextAlignmentCenter;
    [_scroll addSubview:_successTitleLabel];
    _successTitleLabel.text=@"您的家庭医生申请提交成功!";
    _successTitleLabel.sd_layout.topSpaceToView(_headerImageView,30).autoHeightRatio(0).centerXEqualToView(self.view);
    [_successTitleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
}

/**
 *  内容
 */
- (void)setupContentView{
    _contentView = [UIView new];
    [_scroll addSubview:_contentView];
    _contentView.sd_layout.topSpaceToView(_successTitleLabel,15).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
    
    UILabel* name = [UILabel new];
    name.font = [UIFont systemFontOfSize:16];
    name.textColor = RGB(101, 201, 197);
    name.textAlignment = NSTextAlignmentCenter;
    name.text = [NSString stringWithFormat:@"医生姓名：%@",self.doctor.UserName];
    [_contentView addSubview:name];
    
    UILabel* depart = [UILabel new];
    depart.font = name.font;
    depart.textColor = name.textColor;
    depart.textAlignment = NSTextAlignmentCenter;
    depart.text = [NSString stringWithFormat:@"科室：%@",self.doctor.DepartName];
    [_contentView addSubview:depart];

    UILabel* address = [UILabel new];
    address.font = name.font;
    address.textColor = name.textColor;
    address.textAlignment = NSTextAlignmentCenter;
//    address.text = [NSString stringWithFormat:@"执医地点：%@",self.doctor.DepartName];
    address.text = [NSString stringWithFormat:@"执医地点：%@ %@",@"济南市儿童医院",self.doctor.DepartName];//测试
    [_contentView addSubview:address];

    
    name.sd_layout.topSpaceToView(_contentView,0).leftSpaceToView(_contentView,0).rightSpaceToView(_contentView,0).autoHeightRatio(0);
    depart.sd_layout.topSpaceToView(name,10).leftEqualToView(name).rightEqualToView(name).autoHeightRatio(0);
    address.sd_layout.topSpaceToView(depart,10).leftEqualToView(name).rightEqualToView(name).autoHeightRatio(0);
    
    [_contentView setupAutoHeightWithBottomView:address bottomMargin:0];
    
}

/**
 *  提交
 */
- (void)setupCommitButton{
    _commitContainerView = [UIView new];
    [_scroll addSubview:_commitContainerView];
    
    UIButton* backbt=[UIButton new];
    [backbt setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [backbt setTitle:@"返回首页" forState:UIControlStateNormal];
    [backbt addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    backbt.tag=201;
    [_commitContainerView addSubview:backbt];
    
    UIButton* morebt=[UIButton new];
//    [morebt setBackgroundImage:[UIImage imageNamed:@"konwmore"] forState:UIControlStateNormal];
//    [morebt setTitle:@"了解更多疾病知识" forState:UIControlStateNormal];
//    [morebt setTitleColor:UIColorFromRGB(0xf3c156) forState:UIControlStateNormal];
//    [morebt addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
//    morebt.tag=202;
    [_commitContainerView addSubview:morebt];
    
    _commitContainerView.sd_layout.topSpaceToView(_contentView,50).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
    backbt.sd_layout.topSpaceToView(_commitContainerView,0).leftSpaceToView(_commitContainerView,25).rightSpaceToView(_commitContainerView,25).heightIs(40);
    morebt.sd_layout.topSpaceToView(backbt,15).heightRatioToView(backbt,1).leftEqualToView(backbt).rightEqualToView(backbt);
    
    [_commitContainerView setupAutoHeightWithBottomView:morebt bottomMargin:0];
}

/**
 *  提示
 */
- (void)setupTipsLabel{
    _tipsLabel = [UILabel new];
    _tipsLabel.backgroundColor = [UIColor whiteColor];
    _tipsLabel.font = [UIFont systemFontOfSize:12];
    _tipsLabel.textColor = [UIColor redColor];
    _tipsLabel.text = @"* 温馨提示：提交成功后，医生将在七天内进行审核。审核成功后，您将在首页事件提醒中收到通知，刷新医生界面就会看到您添加的家庭医生。请您在申请成功后七天内付款。否则您申请的家庭医生资格将被取消，并影响您下次申请家庭医生成功率。";
    [_scroll addSubview:_tipsLabel];

    _tipsLabel.sd_layout.topSpaceToView(_commitContainerView,25).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25).autoHeightRatio(0);
    [_scroll setupAutoContentSizeWithBottomView:_tipsLabel bottomMargin:20];
}



#pragma mark - 点击事件
- (void)backHomeAction:(UIButton*) bt{
    if(bt.tag==201){
        //跳转首页
        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];

    }else{
        //了解更多
    }
}




@end
