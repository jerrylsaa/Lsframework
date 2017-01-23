//
//  SucceedSubmitViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/5/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SucceedSubmitViewController.h"
#import "TabbarViewController.h"


@interface SucceedSubmitViewController (){
    UIScrollView* _scrollView;
    UIImageView* _bgImageView;
    UIImageView* _headerImageView;
}
@property(nonatomic,retain) NSMutableArray* subtitleLabelArray;
@property(nonatomic,retain) NSMutableArray* titleLabelArray;

@end

@implementation SucceedSubmitViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(NSMutableArray *)titleLabelArray{
    if(!_titleLabelArray){
        _titleLabelArray=[NSMutableArray array];
    }
    return _titleLabelArray;
}
-(NSMutableArray *)subtitleLabelArray{
    if(!_subtitleLabelArray){
        _subtitleLabelArray=[NSMutableArray array];
    }
    return _subtitleLabelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)setupView{
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    //    _scrollView.backgroundColor = [UIColor redColor];
    
    
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
//    UILabel* title=[UILabel new];
//    title.textColor=UIColorFromRGB(0xf3c156);
//    title.font=[UIFont systemFontOfSize:18];
//    title.textAlignment=NSTextAlignmentCenter;
//    //    title.numberOfLines = 2;
//    title.text=self.successTitle;
//    [_scrollView addSubview:title];
//    CGFloat height=30;
//    title.sd_layout.topSpaceToView(_headerImageView,height).heightIs(30).leftEqualToView(_scrollView).rightEqualToView(_scrollView);
    for(int i=0;i<self.titleArray.count;++i){
        UILabel* detail=[UILabel new];
        detail.textColor=UIColorFromRGB(0xf3c156);
        detail.font=[UIFont boldSystemFontOfSize:18];
        detail.textAlignment=NSTextAlignmentCenter;
        detail.text=self.titleArray[i];
        [_scrollView addSubview:detail];
        [self.titleLabelArray addObject:detail];
        detail.sd_layout.topSpaceToView(_headerImageView,30+i*(30+5)).heightIs(30).leftEqualToView(_scrollView).rightEqualToView(_scrollView);
    }
    //    NSArray* subtitleArray=@[@"时间: 2016年3月10日09:30",@"科室: 小儿内科",@"地点: 济南市儿童医院"];
    UILabel* detalLabel=[self.titleLabelArray lastObject];
    for(int i=0;i<self.subtitleArray.count;++i){
        UILabel* detail=[UILabel new];
        detail.textColor=UIColorFromRGB(0x5FCCC7);
        detail.font=[UIFont boldSystemFontOfSize:16];
        detail.textAlignment=NSTextAlignmentCenter;
        detail.text=self.subtitleArray[i];
        [_scrollView addSubview:detail];
        [self.subtitleLabelArray addObject:detail];
        detail.sd_layout.topSpaceToView(detalLabel,20+i*(10+15)).heightIs(10).leftEqualToView(_scrollView).rightEqualToView(_scrollView);
    }
}

/**
 *  提交
 */
- (void)setupCommitButton{
    UIButton* backbt=[UIButton new];
    [backbt setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [backbt setTitle:@"返回" forState:UIControlStateNormal];
    [backbt addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    backbt.tag=201;
    [_scrollView addSubview:backbt];
    
    UIButton* morebt=[UIButton new];
//    [morebt setBackgroundImage:[UIImage imageNamed:@"konwmore"] forState:UIControlStateNormal];
//    [morebt setTitle:@"了解更多疾病知识" forState:UIControlStateNormal];
//    morebt.hidden =YES;
//    [morebt setTitleColor:UIColorFromRGB(0xf3c156) forState:UIControlStateNormal];
//    [morebt addTarget:self action:@selector(backHomeAction:) forControlEvents:UIControlEventTouchUpInside];
//    morebt.tag=202;
    [_scrollView addSubview:morebt];
    
    //温馨提示
    UILabel* tips=[UILabel new];
    tips.textColor=UIColorFromRGB(0xF44141);
    tips.font=[UIFont systemFontOfSize:10];
//    tips.text= self.tips;
    [_scrollView addSubview:tips];
    
    CGFloat height=100/2.0;
    UILabel* detalLabel=[self.subtitleLabelArray lastObject];
    backbt.sd_layout.topSpaceToView(detalLabel,height).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
    
    CGFloat spaceHeight=20;
    morebt.sd_layout.topSpaceToView(backbt,spaceHeight).heightIs(40).leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25);
    
    CGFloat tipsHeight=25;
    tips.sd_layout.topSpaceToView(morebt,tipsHeight).leftEqualToView(morebt).rightEqualToView(morebt);
    tips.sd_layout.autoHeightRatio(0);
    
    [_scrollView setupAutoContentSizeWithBottomView:tips bottomMargin:10];
    
}

#pragma mark - 点击事件
- (void)backHomeAction:(UIButton*) bt{
    if(bt.tag==201){
        //返回上一页
        [self.navigationController popViewControllerAnimated:YES ];
    }else{
        //了解更多
        
    }
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
