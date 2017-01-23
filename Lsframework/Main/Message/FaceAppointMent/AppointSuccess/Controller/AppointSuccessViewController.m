//
//  AppointSuccessViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AppointSuccessViewController.h"
#import "JMChatViewController.h"

@interface AppointSuccessViewController (){
    UIScrollView* _scroll;
    UIImageView* _bgImageView;
    UIImageView* _headerImageView;
    UIView* _contentbgView;
    
    UILabel* _doctorName;
    UILabel* _departName;
    UILabel* _doctorTitle;
    UILabel* _appointTime;
    UILabel* _appointMode;
    UILabel* _appointAddress;
    
    UIView* _commitContainerView;
    UILabel* _tipsLabel;
}

@end

@implementation AppointSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _doctorName.text = [NSString stringWithFormat:@"医生姓名：%@",@""];
    _departName.text = [NSString stringWithFormat:@"科       室：%@",@""];
    _doctorTitle.text = [NSString stringWithFormat:@"医生级别：%@",@""];
    _appointTime.text = [NSString stringWithFormat:@"预约时间：%@",@""];
    _appointMode.text = [NSString stringWithFormat:@"预约方式：%@",@""];
    _appointAddress.text = [NSString stringWithFormat:@"预约地点：%@",@""];

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
    
    [self setupHedaerImageView];
    [self setupContentView];
    [self setupCommitButton];
    [self setupTipsLabel];
    
    [_scroll setupAutoContentSizeWithBottomView:_tipsLabel bottomMargin:0];
}

- (void)setupHedaerImageView{
    _bgImageView=[UIImageView new];
    _bgImageView.image=[UIImage imageNamed:@"commit_success_bg"];
    [_scroll addSubview:_bgImageView];
    
    _headerImageView=[UIImageView new];
    _headerImageView.image=[UIImage imageNamed:@"correct"];
    [_scroll addSubview:_headerImageView];
    
    _bgImageView.sd_layout.topSpaceToView(_scroll,-20).heightIs(314/2.0).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
    _headerImageView.sd_layout.topSpaceToView(_bgImageView,-150/2.0).centerXEqualToView(_scroll).widthIs(150).heightEqualToWidth();

}

- (void)setupContentView{
    _contentbgView = [UIView new];
    [_scroll addSubview:_contentbgView];
    
    UILabel* title = [UILabel new];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = RGB(241, 180, 59);//110,205,201
    title.font = [UIFont boldSystemFontOfSize:18];
    title.text = @"预约成功！";
    [_contentbgView addSubview:title];
    
    _doctorName = [UILabel new];
    _doctorName.textAlignment = NSTextAlignmentCenter;
    _doctorName.textColor = RGB(110, 205, 201);//110,205,201
    _doctorName.font = [UIFont systemFontOfSize:16];
    [_contentbgView addSubview:_doctorName];
    _departName = [UILabel new];
    _departName.textAlignment = NSTextAlignmentCenter;
    _departName.textColor = _doctorName.textColor;//110,205,201
    _departName.font = _doctorName.font;
    [_contentbgView addSubview:_departName];
    _doctorTitle = [UILabel new];
    _doctorTitle.textAlignment = NSTextAlignmentCenter;
    _doctorTitle.textColor = _doctorName.textColor;//110,205,201
    _doctorTitle.font = _doctorName.font;
    [_contentbgView addSubview:_doctorTitle];
    _appointTime = [UILabel new];
    _appointTime.textAlignment = NSTextAlignmentCenter;
    _appointTime.textColor = _doctorName.textColor;//110,205,201
    _appointTime.font = _doctorName.font;
    [_contentbgView addSubview:_appointTime];
    _appointMode = [UILabel new];
    _appointMode.textAlignment = NSTextAlignmentCenter;
    _appointMode.textColor = _doctorName.textColor;//110,205,201
    _appointMode.font = _doctorName.font;
    [_contentbgView addSubview:_appointMode];
    _appointAddress = [UILabel new];
    _appointAddress.textAlignment = NSTextAlignmentCenter;
    _appointAddress.textColor = _doctorName.textColor;//110,205,201
    _appointAddress.font = _doctorName.font;
    [_contentbgView addSubview:_appointAddress];

    
    title.sd_layout.topSpaceToView(_contentbgView,0).autoHeightRatio(0).leftSpaceToView(_contentbgView,0).rightSpaceToView(_contentbgView,0);
    _doctorName.sd_layout.topSpaceToView(title,10).autoHeightRatio(0).leftEqualToView(title).rightEqualToView(title);
    _departName.sd_layout.topSpaceToView(_doctorName,5).autoHeightRatio(0).leftEqualToView(title).rightEqualToView(title);
    _doctorTitle.sd_layout.topSpaceToView(_departName,5).autoHeightRatio(0).leftEqualToView(title).rightEqualToView(title);
    _appointTime.sd_layout.topSpaceToView(_doctorTitle,5).autoHeightRatio(0).leftEqualToView(title).rightEqualToView(title);
    _appointMode.sd_layout.topSpaceToView(_appointTime,5).autoHeightRatio(0).leftEqualToView(title).rightEqualToView(title);
    _appointAddress.sd_layout.topSpaceToView(_appointMode,5).autoHeightRatio(0).leftEqualToView(title).rightEqualToView(title);

    
    _contentbgView.sd_layout.topSpaceToView(_headerImageView,25).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
    [_contentbgView setupAutoHeightWithBottomView:_appointAddress bottomMargin:5];
}

- (void)setupCommitButton{
    _commitContainerView = [UIView new];
    [_scroll addSubview:_commitContainerView];
    
    UIButton* backbt=[UIButton new];
    [backbt setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [backbt setTitle:@"确认" forState:UIControlStateNormal];
    [backbt addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    backbt.tag=201;
    [_commitContainerView addSubview:backbt];
    
    UIButton* morebt=[UIButton new];
    [morebt setBackgroundImage:[UIImage imageNamed:@"konwmore"] forState:UIControlStateNormal];
    [morebt setTitle:@"更多宝宝健康教育" forState:UIControlStateNormal];
    [morebt setTitleColor:UIColorFromRGB(0xf3c156) forState:UIControlStateNormal];
    [morebt addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    morebt.tag=202;
    [_commitContainerView addSubview:morebt];
    
    _commitContainerView.sd_layout.topSpaceToView(_contentbgView,50).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
    backbt.sd_layout.topSpaceToView(_commitContainerView,0).leftSpaceToView(_commitContainerView,25).rightSpaceToView(_commitContainerView,25).heightIs(40);
    morebt.sd_layout.topSpaceToView(backbt,15).heightRatioToView(backbt,1).leftEqualToView(backbt).rightEqualToView(backbt);
    
    [_commitContainerView setupAutoHeightWithBottomView:morebt bottomMargin:0];

}

- (void)setupTipsLabel{
    _tipsLabel = [UILabel new];
    _tipsLabel.backgroundColor = [UIColor whiteColor];
    _tipsLabel.font = [UIFont systemFontOfSize:12];
    _tipsLabel.textColor = [UIColor redColor];
    _tipsLabel.text = @"* 温馨提示：您可以在家庭医生预约管理中查看预约信息。";
    [_scroll addSubview:_tipsLabel];
    
    _tipsLabel.sd_layout.topSpaceToView(_commitContainerView,25).leftSpaceToView(_scroll,25).rightSpaceToView(_scroll,25).autoHeightRatio(0);

}

#pragma mark - 点击事件

#pragma mark - 点击事件
- (void)backHomeAction:(UIButton*) bt{
    if(bt.tag==201){
        //跳转首页
        UIViewController* back = nil;
        for(UIViewController* vc in self.navigationController.childViewControllers){
            if([vc isKindOfClass:[JMChatViewController class]]){
                back = vc;
                break;
            }
        }
        
        if(back){
            [self.navigationController popToViewController:back animated:NO];
        }

        
    }else{
        //了解更多
    }
}





@end
