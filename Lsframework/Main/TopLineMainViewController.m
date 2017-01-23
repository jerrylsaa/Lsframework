//
//  TopLineMainViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "TopLineMainViewController.h"
#import "RecommendViewController.h"
#import "ConcentrationViewController.h"
#import "RankingViewController.h"
#import "navigTitleView.h"
#import "DailyArticleMoreViewController.h"
#import "MoreViewController.h"


#define xSpace  (kScreenWidth - 3*24*4)/4

#define  x_height  24

@interface TopLineMainViewController ()<UIScrollViewDelegate,RecommendViewDelegate,ConcentrationViewDelegate,RankingViewDelegate>

@property(nullable,nonatomic,strong) navigTitleView* navigTitleView;
@property(nullable,nonatomic,strong) UIButton* Recommendbt;
@property(nullable,nonatomic,strong) UIButton* Concentrationbt;
@property(nullable,nonatomic,strong) UIButton* Rankingbt;

@property(nullable,nonatomic,strong) UIView* lineView;
@property(nullable,nonatomic,strong) UIScrollView* scroll;

@property(nullable,nonatomic,strong) RecommendViewController* recommendList; //今日推荐
@property(nullable,nonatomic,strong) ConcentrationViewController * concentrationList;  //精选
@property(nullable,nonatomic,strong) RankingViewController *rankingList;  //排行




@end

@implementation TopLineMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHideTabbar = NO;
    [self initBackBarWithImage:nil];
//    self.title = @"头条";
    
}

-(void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _navigTitleView = [navigTitleView new];
    _navigTitleView.backgroundColor = [UIColor  clearColor];
    _navigTitleView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    self.navigationItem.titleView = _navigTitleView;
    
    
    _Recommendbt = [UIButton  new];
    _Recommendbt.backgroundColor = [UIColor clearColor];
    [_Recommendbt setTitle:@"今日推荐" forState:UIControlStateNormal];
    _Recommendbt.tag = 101;
    [_Recommendbt addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventTouchUpInside];
    
    _Concentrationbt = [UIButton new];
    _Concentrationbt.backgroundColor = [UIColor clearColor];
    [_Concentrationbt setTitle:@"精选" forState:UIControlStateNormal];
    _Concentrationbt.tag = 102;
    [_Concentrationbt addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventTouchUpInside];
    
    _Rankingbt = [UIButton  new];
    _Rankingbt.backgroundColor = [UIColor clearColor];
    [_Rankingbt setTitle:@"排行" forState:UIControlStateNormal];
    _Rankingbt.tag = 103;
    [_Rankingbt addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_navigTitleView sd_addSubviews:@[_Recommendbt,_Concentrationbt,_Rankingbt]];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = UIColorFromRGB(0xffffff);
    [_navigTitleView addSubview:_lineView];
    
    _Recommendbt.sd_layout.topSpaceToView(_navigTitleView,10).leftSpaceToView(_navigTitleView,xSpace).widthIs(24*4).heightIs(24);
    //
    _Concentrationbt.sd_layout.topEqualToView(_Recommendbt).leftSpaceToView(_Recommendbt,xSpace).widthRatioToView(_Recommendbt,1).heightRatioToView(_Recommendbt,1);
    //
    _Rankingbt.sd_layout.topEqualToView(_Recommendbt).leftSpaceToView(_Concentrationbt,xSpace).widthRatioToView(_Recommendbt,1).heightRatioToView(_Recommendbt,1);
    
    _lineView.sd_layout.topSpaceToView(_Recommendbt,3).heightIs(2).leftEqualToView(_Recommendbt).widthRatioToView(_Recommendbt,1);
    
    _lineView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    
    _recommendList = [RecommendViewController new];
    _recommendList.delegate=self;
    UIView* view1 = _recommendList.view;
    view1.backgroundColor = [UIColor  clearColor];
    
    _concentrationList = [ConcentrationViewController new];
    UIView* view2 = _concentrationList.view;
    CGRect rect = view2.frame;
    _concentrationList.delegate=self;
    rect.origin.x = kScreenWidth;
    view2.frame = rect;
    view2.backgroundColor = [UIColor  clearColor];
    
    _rankingList = [RankingViewController new];
    _rankingList.delegate=self;
    UIView* view3 = _rankingList.view;
    CGRect rect2 = view3.frame;
    rect2.origin.x = 2*kScreenWidth;
    view3.frame = rect2;
    view3.backgroundColor = [UIColor  clearColor];

    
    [_scroll addSubview:view1];
    [_scroll addSubview:view2];
    [_scroll addSubview:view3];
    
    _scroll.contentSize = CGSizeMake(3* kScreenWidth, kScreenHeight);
    
}

#pragma mark - 点击事件
- (void)clickSegment:(UIButton*) bt{
    
    NSInteger index = bt.tag - 100;
    
    CGPoint contentOffset = _scroll.contentOffset;
    
    contentOffset.x = kScreenWidth * (index - 1);
    
    if(index == 1){
        self.segmentType = SegmentRecommendType;
    }else if(index == 2){
        self.segmentType = SegmentConcentrationType;
    }else if(index == 3){
        self.segmentType = SegmentRankingType;
    }
    
    [UIView animateWithDuration:.2f animations:^{
        
        _lineView.sd_layout.leftEqualToView(bt);
        [_lineView updateLayout];
        
        _scroll.contentOffset = contentOffset;
    }];
    
    
}

#pragma mark - 代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page ;
    if(_scroll.contentOffset.x / kScreenWidth == (int)(_scroll.contentOffset.x / kScreenWidth)){
        page = _scroll.contentOffset.x / kScreenWidth;
        //        NSLog(@"%ld",page);
        if(page == 0){
            //今日推荐
            self.segmentType = SegmentRecommendType;
            [UIView animateWithDuration:.2f animations:^{
                _lineView.sd_layout.leftEqualToView(_Recommendbt);
                [_lineView updateLayout];
                
            }];
        }else if(page == 1){
            //精选
            self.segmentType = SegmentConcentrationType;
            
            [UIView animateWithDuration:.2f animations:^{
                _lineView.sd_layout.leftEqualToView(_Concentrationbt);
                [_lineView updateLayout];
                
            }];
        }else if(page == 2){
            //排行
            self.segmentType = SegmentRankingType;
            
            [UIView animateWithDuration:.2f animations:^{
                _lineView.sd_layout.leftEqualToView(_Rankingbt);
                [_lineView updateLayout];
                
            }];
        }
        
        
    }
    
}

- (void)pushToVc:(BaseViewController *)vc{
    
    [self.navigationController  pushViewController:vc animated:YES];

}
@end
