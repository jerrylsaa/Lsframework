//
//  ABCViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ABCViewController.h"
#import "XLLBPresenter.h"
#import "ABCCSViewController.h"
#import "GJTJZDViewController.h"
#import "GJTJZDaoViewController.h"
#import "PageView.h"
@interface ABCViewController ()<XLLBPresenterDelegate,PageViewDelegate>
@property (nonatomic, strong)PageView *pageView;
@property (nonatomic,strong) XLLBPresenter *presenter;


@end

@implementation ABCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter getXLLBData];
    
}

- (void)setupView{
    self.title = @"医院测评报告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.presenter =[XLLBPresenter new];
    self.presenter.delegate = self;
    self.presenter.tableName =@"ABC";
    [self setupPage];
    
}

- (void)setupPage{
    UIImageView *backgroundIV =[UIImageView new];
    backgroundIV.image =[UIImage imageNamed:@"hptBGImage"];
    [self.view addSubview:backgroundIV];
    backgroundIV.sd_layout.centerYIs(kScreenHeight/2.0).centerXEqualToView(self.view).widthIs(255).heightIs(329);
    
    _pageView = [PageView new];
    _pageView.pageType = PageTypeSubTitle;
    _pageView.delegate = self;
    _pageView.frame = self.view.frame;
    
    [_pageView setTitleNormalColor:UIColorFromRGB(0x666666)];
    [_pageView setTitleHightLightColor:UIColorFromRGB(0x85d5f1)];
    [_pageView setBottomLineColor:UIColorFromRGB(0x85d5f1)];
    [_pageView setSeparatorColor:[UIColor clearColor]];
    [_pageView setBottomLineHeight:4.0];
    [self.view addSubview:_pageView];
    _pageView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _pageView.alpha =1;
    
    
    
    
}

#pragma mark Delegate

-(void)onPageViewTabChange:(NSInteger)index{
    
}

- (void)onCompletion:(BOOL)success info:(NSString *)messsage{
    if(success){
        ABCCSViewController *ceshiVC =[ABCCSViewController new];
        ceshiVC.xllbDataSource =self.presenter.xllbDataSource;
        
        GJTJZDViewController *zhenduanVC =[GJTJZDViewController new];
        zhenduanVC.xllbDataSource =self.presenter.xllbDataSource;
        
        GJTJZDaoViewController *zhidaoVC =[GJTJZDaoViewController new];
        zhidaoVC.xllbDataSource =self.presenter.xllbDataSource;
        
        [_pageView setViewControllers:@[ceshiVC,zhenduanVC,zhidaoVC]];
        [_pageView setTitles:@[@"测试项目",@"初步诊断",@"医生指导"]];
        
    }else{
        [ProgressUtil showError:messsage];
    }
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
