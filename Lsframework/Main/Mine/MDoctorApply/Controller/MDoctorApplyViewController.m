//
//  MDoctorApplyViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorApplyViewController.h"
#import "MAFamilyDoctorApplyViewController.h"
#import "MAOnlieApplyViewController.h"
#import "MAPhoneApplyViewController.h"
#import "PageView.h"
#import "MDoctorApplyPresenter.h"

#define kColumn 3

@interface MDoctorApplyViewController ()<PageViewDelegate,MDoctorApplyPresenterDelegate>{
    UIView* _container;
    UIView* _headerView;
    
    UIView* _line;
    UIView* _currentLine;
    
    UIScrollView* _scroll;
    
    PageView* _pageView;
    
    
    
}

@property(nonatomic,retain) NSMutableArray* btArray;

@property(nonatomic,retain) MDoctorApplyPresenter* presenter;

//@property(nonatomic,retain) MAFamilyDoctorApplyViewController* familyDoctorApply;
@property(nonatomic,retain) MAOnlieApplyViewController* onlineApply;
//@property(nonatomic,retain) MAPhoneApplyViewController* phoneApply;


@end

@implementation MDoctorApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.presenter = [MDoctorApplyPresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter getMyApply];
}


-(void)setupView{
    self.title = @"我的申请";
    [self.view addSubview:self.onlineApply.view];
//    _pageView = [PageView new];
//    [self.view addSubview:_pageView];
//    _pageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
//    [_pageView setTitleNormalColor:UIColorFromRGB(0x666666)];
//    [_pageView setTitleHightLightColor:UIColorFromRGB(0x68c0de)];
//    [_pageView setBottomLineColor: UIColorFromRGB(0x54AACB)];
////    [_pageView setBottomLineHeight:2.0];
//    [_pageView setBottomLineHeight:0.0];
////    [_pageView setViewControllers:@[self.familyDoctorApply, self.onlineApply, self.phoneApply]];
//      [_pageView setViewControllers:@[ self.onlineApply]];
////    [_pageView setTitles:@[@"家庭医生",@"在线咨询",@"电话咨询"]];
//    
//      [_pageView setTitles:@[@"111"]];
//    _pageView.delegate = self;
    
}

#pragma mark - 代理
-(void)onPageViewTabChange:(NSInteger)index{
//    NSLog(@"index = %ld",index);
}

-(void)onCompletion{
    [ProgressUtil dismiss];
    
//    [self.familyDoctorApply reloadData:self.presenter.familyDoctorResponse];
    [self.onlineApply reloadData:self.presenter.onlineResponse];
//    [self.phoneApply reloadData:self.presenter.phoneResponse];

}

#pragma mark - 懒加载
-(NSMutableArray *)btArray{
    if(!_btArray){
        _btArray=[NSMutableArray array];
    }
    return _btArray;
}

//-(MAFamilyDoctorApplyViewController *)familyDoctorApply{
//    if(!_familyDoctorApply){
//        _familyDoctorApply = [MAFamilyDoctorApplyViewController new];
//    }
//    return _familyDoctorApply;
//}

-(MAOnlieApplyViewController *)onlineApply{
    if(!_onlineApply){
        _onlineApply = [MAOnlieApplyViewController new];
    }
    return _onlineApply;

}

//-(MAPhoneApplyViewController *)phoneApply{
//    if(!_phoneApply){
//        _phoneApply = [MAPhoneApplyViewController new];
//    }
//    return _phoneApply;
//
//}






@end
