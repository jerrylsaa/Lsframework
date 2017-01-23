//
//  BindHospitalViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BindHospitalViewController.h"
#import "BindHospitalPresenter.h"

@interface BindHospitalViewController ()<BindHospitalPresenterDelegate>{
    UIImageView *_hospitalIcon;
    UILabel *_hospitalName;
    UILabel *_hospitalInfo;
    UILabel *_department;
    UILabel *_departmentInfo;
    UIButton *_bindButton;
}
@property (nonatomic,strong) BindHospitalPresenter *presenter;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BindHospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"扫一扫";
    self.view.backgroundColor =[UIColor whiteColor];
    
    
}

- (void)setupView{
    _presenter = [BindHospitalPresenter new];
    _presenter.delegate = self;
    
    _scrollView  = [UIScrollView  new];
    _scrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view  addSubview:_scrollView];
    
    _hospitalIcon =[UIImageView new];
    _hospitalIcon.layer.cornerRadius =45;
    [_hospitalIcon sd_setImageWithURL:[NSURL URLWithString:self.hospitalEntity.ImageUrl] placeholderImage:[UIImage  imageNamed:@"HEADoctorIcon"]];
    _hospitalIcon.layer.masksToBounds =YES;
    [_scrollView addSubview:_hospitalIcon];
    
    _hospitalName =[UILabel new];
    _hospitalName.text =self.hospitalEntity.HospitalName;
    _hospitalName.font =[UIFont systemFontOfSize:17];
    _hospitalName.textColor =UIColorFromRGB(0x333333);
    _hospitalName.textAlignment =NSTextAlignmentCenter;
    [_scrollView addSubview:_hospitalName];
    
    _hospitalInfo =[UILabel new];
    _hospitalInfo.text =self.hospitalEntity.Introduce;
    
    _hospitalInfo.numberOfLines =0;
    _hospitalInfo.font =[UIFont systemFontOfSize:15];
    _hospitalInfo.textColor =UIColorFromRGB(0x333333);
    _hospitalInfo.textAlignment =NSTextAlignmentCenter;
    [_scrollView addSubview:_hospitalInfo];
    
    _department =[UILabel new];
    _department.text =@"科室：";
    _department.font =[UIFont systemFontOfSize:15];
    _department.textColor =UIColorFromRGB(0x61d8d3);
    _department.textAlignment =NSTextAlignmentLeft;
    [_scrollView addSubview:_department];
    
    _departmentInfo =[UILabel new];
    _departmentInfo.text =self.hospitalEntity.DepartName;

    _departmentInfo.numberOfLines =0;
    _departmentInfo.font =[UIFont systemFontOfSize:15];
    _departmentInfo.textColor =UIColorFromRGB(0x666666);
    _departmentInfo.textAlignment =NSTextAlignmentLeft;
    [_scrollView addSubview:_departmentInfo];
    
    _bindButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_bindButton setBackgroundImage:[UIImage imageNamed:@"code_nor"] forState:UIControlStateNormal];
    [_bindButton setTitle:@"绑定医院" forState:UIControlStateNormal];
    _bindButton.titleLabel.font =[UIFont systemFontOfSize:17];
    [_bindButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_bindButton];
    
    _scrollView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    _hospitalIcon.sd_layout.centerXEqualToView(_scrollView).topSpaceToView(_scrollView,25).widthIs(90).heightIs(90);
    _hospitalName.sd_layout.centerXEqualToView(_scrollView).topSpaceToView(_hospitalIcon,15).heightIs(20).widthIs(200);
    _hospitalInfo.sd_layout.topSpaceToView(_hospitalName,20).leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).autoHeightRatio(0);
    _department.sd_layout.topSpaceToView(_hospitalInfo,15).leftSpaceToView(_scrollView,15).heightIs(20).widthIs(50);
    _departmentInfo.sd_layout.topSpaceToView(_hospitalInfo,15).leftSpaceToView(_department,0).rightSpaceToView(_scrollView,15).autoHeightRatio(0);
    
    _bindButton.sd_layout.topSpaceToView(_departmentInfo,50).centerXEqualToView(_scrollView).heightIs(40).widthIs(260);
    
    [_scrollView setupAutoHeightWithBottomView:_bindButton bottomMargin:25];
    
    
}


- (void)buttonAction:(UIButton *)btn{
    NSLog(@"绑定");
    [ProgressUtil show];
    [_presenter bindHospitalWithExpertID:_expertID];
}

- (void)onCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil showSuccess:@"绑定成功"];
        [self.navigationController popToRootViewControllerAnimated:NO];
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
