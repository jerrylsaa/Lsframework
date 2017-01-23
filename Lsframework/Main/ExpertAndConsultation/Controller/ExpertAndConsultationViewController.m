//
//  ExpertAndConsultationViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ExpertAndConsultationViewController.h"
#import "HotQuestionViewController.h"
#import "HExpertAnswerViewController.h"
#import "SearchQuestionViewController.h"

@interface ExpertAndConsultationViewController ()<UIScrollViewDelegate>

@property(nullable,nonatomic,retain) UIView* navigTitleView;
@property(nullable,nonatomic,retain) UIButton* expertbt;
@property(nullable,nonatomic,retain) UIButton* consulationbt;
@property(nullable,nonatomic,retain) UIView* lineView;
@property(nullable,nonatomic,retain) UIScrollView* scroll;

@property(nullable,nonatomic,retain) HotQuestionViewController* hotQuestion;
@property(nullable,nonatomic,retain) HExpertAnswerViewController* expsertList;

@end

@implementation ExpertAndConsultationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightBarWithImage:[UIImage imageNamed:@"GB_Search"]];
    
    [kdefaultCenter addObserver:self selector:@selector(notificationPush:) name:Notification_Push object:nil];
    [kdefaultCenter addObserver:self selector:@selector(notificationRefresh:) name:Notification_RefreshHotQuestion object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if(self.segmentType == SegmentConsulationType){
        [_scroll updateLayout];

        //咨询
        CGPoint contentOffset = _scroll.contentOffset;
        contentOffset.x = kScreenWidth ;
        
        [UIView animateWithDuration:.2f animations:^{
            _lineView.sd_layout.leftEqualToView(_consulationbt);
            [_lineView updateLayout];
            
            _scroll.contentOffset = contentOffset;

            
        }];

    }
}

-(void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _navigTitleView = [UIView new];
    _navigTitleView.frame = CGRectMake(0, 0, 280/2.0, 44);
    self.navigationItem.titleView = _navigTitleView;
    
    _expertbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [_expertbt setTitle:@"专家" forState:UIControlStateNormal];
    _expertbt.tag = 101;
    [_expertbt addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventTouchUpInside];
    _consulationbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [_consulationbt setTitle:@"咨询" forState:UIControlStateNormal];
    _consulationbt.tag = 102;
    [_consulationbt addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventTouchUpInside];
    [_navigTitleView sd_addSubviews:@[_expertbt,_consulationbt]];
    
//    _navigTitleView.backgroundColor = [UIColor redColor];
//    _expertbt.backgroundColor = [UIColor greenColor];
//    _consulationbt.backgroundColor = [UIColor greenColor];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = UIColorFromRGB(0xffffff);
    [_navigTitleView addSubview:_lineView];
    
    _expertbt.sd_layout.topSpaceToView(_navigTitleView,10).leftSpaceToView(_navigTitleView,0).widthIs(45).heightIs(24);
    _consulationbt.sd_layout.topEqualToView(_expertbt).rightSpaceToView(_navigTitleView,0).widthRatioToView(_expertbt,1).heightRatioToView(_expertbt,1);
    _lineView.sd_layout.topSpaceToView(_expertbt,3).heightIs(2).leftEqualToView(_expertbt).widthRatioToView(_expertbt,1);
    _lineView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    
    _expsertList = [HExpertAnswerViewController new];
    UIView* view1 = _expsertList.view;

    _hotQuestion = [HotQuestionViewController new];
    UIView* view2 = _hotQuestion.view;
    CGRect rect = view2.frame;
    rect.origin.x = kScreenWidth;
    view2.frame = rect;
    
    [_scroll addSubview:view1];
    [_scroll addSubview:view2];
    
    _scroll.contentSize = CGSizeMake(2* kScreenWidth, kScreenHeight);
    
}

#pragma mark - 点击事件
- (void)clickSegment:(UIButton*) bt{
    
    NSInteger index = bt.tag - 100;
    
    CGPoint contentOffset = _scroll.contentOffset;
    
    contentOffset.x = kScreenWidth * (index - 1);
    
    if(index == 1){
        self.segmentType = SegmentExpertType;
    }else if(index == 2){
        self.segmentType = SegmentConsulationType;
    }

    
    
    [UIView animateWithDuration:.2f animations:^{
       
        _lineView.sd_layout.leftEqualToView(bt);
        [_lineView updateLayout];
        
        _scroll.contentOffset = contentOffset;
    }];
    

}

-(void)rightItemAction:(id)sender{
    SearchQuestionViewController  *vc  =[SearchQuestionViewController  new];
    [self.navigationController   pushViewController:vc animated:YES];


    
}


-(void)RightBarItemClick{
    
    SearchQuestionViewController  *vc  =[SearchQuestionViewController  new];
    [self.navigationController   pushViewController:vc animated:YES];
    
}

#pragma mark - 通知回调
- (void)notificationPush:(NSNotification*) notification{
    NSDictionary* userInfo = notification.userInfo;
    UIViewController* vc = [userInfo objectForKey:@"viewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)notificationRefresh:(NSNotification *)notification{
    [_hotQuestion refresh];
}

#pragma mark - 代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page ;
    if(_scroll.contentOffset.x / kScreenWidth == (int)(_scroll.contentOffset.x / kScreenWidth)){
        page = _scroll.contentOffset.x / kScreenWidth;
//        NSLog(@"%ld",page);
        if(page == 0){
            //专家
            self.segmentType = SegmentExpertType;
            [UIView animateWithDuration:.2f animations:^{
                _lineView.sd_layout.leftEqualToView(_expertbt);
                [_lineView updateLayout];
                
            }];
        }else if(page == 1){
            //咨询
            self.segmentType = SegmentConsulationType;

            [UIView animateWithDuration:.2f animations:^{
                _lineView.sd_layout.leftEqualToView(_consulationbt);
                [_lineView updateLayout];
                
            }];
        }
        
    }

}


#pragma mark - dealloc

- (void)dealloc{
    [kdefaultCenter removeObserver:self name:Notification_Push object:nil];
    [kdefaultCenter removeObserver:self name:Notification_RefreshHotQuestion object:nil];
}



@end
