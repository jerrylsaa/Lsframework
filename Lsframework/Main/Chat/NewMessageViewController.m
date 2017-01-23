//
//  NewMessageViewController.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "NewMessageViewController.h"
#import "ChatListViewController.h"
#import "NoticeViewController.h"
#import "CSystemNoticeViewController.h"
@interface NewMessageViewController ()<UIScrollViewDelegate,ChatListViewControllerDelegate,NoticeViewControllerDelegate,CSystemNoticeViewControllerDelegate>

@property(nullable,nonatomic,retain) UIView* navigTitleView;
@property(nullable,nonatomic,retain) UIButton* chatListBtn;
@property(nullable,nonatomic,retain) UIButton* noticeBtn;
@property(nullable,nonatomic,retain) UIView* lineView;
@property(nullable,nonatomic,retain) UIScrollView* scroll;


@property(nonatomic,strong)ChatListViewController *chatListVc;
@property(nonatomic,strong)NoticeViewController  *noticeVc;
//@property(nonatomic,strong)CSystemNoticeViewController  *noticeVc;


@end

@implementation NewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setupView
{
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    _navigTitleView = [UIView new];
    _navigTitleView.frame = CGRectMake(0, 0, 280/2.0, 44);
    self.navigationItem.titleView = _navigTitleView;
    
    _noticeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [_noticeBtn setTitle:@"通知" forState:UIControlStateNormal];
    _noticeBtn.tag = 101;
    [_noticeBtn addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventTouchUpInside];
    _chatListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [_chatListBtn setTitle:@"聊天" forState:UIControlStateNormal];
    _chatListBtn.tag = 102;
    [_chatListBtn addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventTouchUpInside];
    [_navigTitleView sd_addSubviews:@[_noticeBtn,_chatListBtn]];
    
    
    _lineView = [UIView new];
    _lineView.backgroundColor = UIColorFromRGB(0xffffff);
    [_navigTitleView addSubview:_lineView];
    
    _noticeBtn.sd_layout.topSpaceToView(_navigTitleView,10).leftSpaceToView(_navigTitleView,0).widthIs(45).heightIs(24);
    _chatListBtn.sd_layout.topEqualToView(_noticeBtn).rightSpaceToView(_navigTitleView,0).widthRatioToView(_noticeBtn,1).heightRatioToView(_noticeBtn,1);
    _lineView.sd_layout.topSpaceToView(_noticeBtn,3).heightIs(2).leftEqualToView(_noticeBtn).widthRatioToView(_noticeBtn,1);
    _lineView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
    
    
    _noticeVc = [NoticeViewController new];
    UIView* view1 = _noticeVc.view;
    _noticeVc.delegate = self;
    
    _chatListVc = [ChatListViewController new];
    _chatListVc.delegate = self;
    UIView* view2 = _chatListVc.view;
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
        self.segmentType = SegmentNoticeType;
    [kdefaultCenter postNotificationName:@"SegmentNoticeTypeRefresh" object:nil userInfo:nil];
    }else if(index == 2){
        self.segmentType = SegmentChatListType;
        [kdefaultCenter postNotificationName:@"SegmentChatListTypeRefresh" object:nil userInfo:nil];
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
            //专家
            self.segmentType = SegmentNoticeType;
            [UIView animateWithDuration:.2f animations:^{
                _lineView.sd_layout.leftEqualToView(_noticeBtn);
                [_lineView updateLayout];
                
            }];
        }else if(page == 1){
            //咨询
            self.segmentType = SegmentChatListType;
            
            [UIView animateWithDuration:.2f animations:^{
                _lineView.sd_layout.leftEqualToView(_chatListBtn);
                [_lineView updateLayout];
                
            }];
        }
        
    }
    
}
-(void)pushToVc:(BaseViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
    
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
