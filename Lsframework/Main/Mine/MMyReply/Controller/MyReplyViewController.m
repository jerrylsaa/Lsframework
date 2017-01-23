//
//  MyReplyViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyReplyViewController.h"
#import "PageView.h"
#import "MyQuestionViewController.h"
#import "MyListenViewController.h"
#import "MyAnswerViewController.h"
#import "MyReplyPresenter.h"




@interface MyReplyViewController ()<PageViewDelegate,MyQuestionDelegate,MyAnswerDelegate,MyListenDelegate>


@property (nonatomic, strong)PageView *pageView;

@property (nonatomic, strong)MyReplyPresenter *presenter;

@end

@implementation MyReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"我的咨询";
    self.view.backgroundColor = [UIColor whiteColor];
    _presenter = [MyReplyPresenter new];
    [self setupPage];
    [self setupTitleAndView];
}
- (void)setupPage{
    _pageView = [PageView new];
    _pageView.pageType = PageTypeSubTitle;
    _pageView.delegate = self;
    _pageView.frame = self.view.frame;
//    [_pageView setTabHeight:44.];
    [_pageView setTitleNormalColor:UIColorFromRGB(0x5D5D5D)];
    [_pageView setTitleHightLightColor:UIColorFromRGB(0x52d8d2)];
    [_pageView setBottomLineColor:UIColorFromRGB(0x52d8d2)];
    [_pageView setSeparatorColor:UIColorFromRGB(0xD2D2D2)];
    [_pageView setBottomLineHeight:2.0];
    [self.view addSubview:_pageView];
    _pageView.alpha = 0;
}

- (void)setupTitleAndView{
    
    MyQuestionViewController *questionVc = [MyQuestionViewController new];
    questionVc.delegate = self;
    MyAnswerViewController *answerVc = [MyAnswerViewController new];
    answerVc.delegate = self;
    MyListenViewController  *listenVc = [MyListenViewController  new];
    listenVc.delegate = self;
  
    [_presenter getExperIDByUserID:^(BOOL isDoctor, NSString *message) {
        _pageView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        _pageView.alpha = 1;
         NSLog(@"4444:%d",isDoctor);
        if (isDoctor == YES) {
            answerVc.doctorID = message;
            [_pageView setViewControllers:@[questionVc,listenVc, answerVc]];
            [_pageView setTitles:@[@"我问",@"我听",@"我答"]];
        }else{
            [_pageView setViewControllers:@[questionVc,listenVc]];
            [_pageView setTitles:@[@"我问",@"我听"]];
        }
    }];  
}

#pragma mark Delegate

- (void)pushToVc:(BaseViewController *)vc{
//    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
//    vc.navigationItem.rightBarButtonItem = barItem;
//    barItem.tag = vc.index;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onPageViewTabChange:(NSInteger)index{
//    if (index == 2) {
//        if (!_answerVc.delegate) {
//            _answerVc.delegate = self;
//        }
//    }
}
//- (void)shareAction:(UIBarButtonItem *)item{
//   }

#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-我的咨询页面"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-我的咨询页面"];
    
}

@end
