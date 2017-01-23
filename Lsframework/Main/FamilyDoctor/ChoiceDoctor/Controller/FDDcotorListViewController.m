//
//  FDDcotorListViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//  医生列表

#import "FDDcotorListViewController.h"
#import "FDDcotorListTableViewCell.h"
#import "FDDoctorInfoViewController.h"
#import "FDDoctorInfoViewController.h"
#import "FDSelectFamilyDoctorViewController.h"
#import "OutpatientSuccessViewController.h"
#import "FDHealthCaseViewController.h"
#import "FDHealthReportViewController.h"
#import "FDAppointManagerViewController.h"
#import "FDPayViewController.h"
#import "FDApplyDoctorViewController.h"
#import <UITableView+SDAutoTableViewCellHeight.h>


@interface FDDcotorListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView* _headerBgView;
    UITableView* _table;
}

@property(nonatomic,retain) NSMutableArray* dataSource;

@end

@implementation FDDcotorListViewController

-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initRightBarWithTitle:@"收藏"];
}


- (void)setupView{
    self.title = @"家庭医生";
    [self setupHeaderView];
    [self setupTableViews];
    
//    for(int i=0; i<20; ++i){
//        DoctorList* doctor = [DoctorList new];
//        if(i == 0){
//            doctor.applySuccess = YES;
//        }else if (i == 1){
//            doctor.serviceOutdate = @"2016年4月4日服务到期";
//        }
//        [self.dataSource addObject:doctor];
//    }
}

#pragma mark - 加载subviews

- (void)setupHeaderView{
    _headerBgView = [UIView new];
    _headerBgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:_headerBgView];
    _headerBgView.sd_layout.topSpaceToView(self.view,0).leftEqualToView(self.view).rightEqualToView(self.view);
    
    UIButton* healthCase = [UIButton new];
    [healthCase setBackgroundImage:[UIImage imageNamed:@"doctor_healthCase"] forState:UIControlStateNormal];
    [healthCase addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    healthCase.tag = 100;
    
    UIButton* healthRecord = [UIButton new];
    [healthRecord setBackgroundImage:[UIImage imageNamed:@"doctor_healthRecord"] forState:UIControlStateNormal];
    [healthRecord addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    healthRecord.tag = 101;
    
    UIButton* appointManager = [UIButton new];
    [appointManager setBackgroundImage:[UIImage imageNamed:@"doctor_appointManager"] forState:UIControlStateNormal];
    [appointManager addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    appointManager.tag = 102;
    
    UIButton* addDoctor = [UIButton new];
    [addDoctor setBackgroundImage:[UIImage imageNamed:@"doctor_addDoctor"] forState:UIControlStateNormal];
    [addDoctor addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    addDoctor.tag = 103;
    
    [_headerBgView sd_addSubviews:@[healthCase,healthRecord,appointManager,addDoctor]];
    
    _headerBgView.sd_equalWidthSubviews = @[healthCase,healthRecord,appointManager,addDoctor];
    
    healthCase.sd_layout.topSpaceToView(_headerBgView,15).heightEqualToWidth().leftSpaceToView(_headerBgView,15);
    
    healthRecord.sd_layout.topEqualToView(healthCase).heightEqualToWidth().leftSpaceToView(healthCase,15);
    
    appointManager.sd_layout.topEqualToView(healthCase).heightEqualToWidth().leftSpaceToView(healthRecord,15);
    
    addDoctor.sd_layout.leftSpaceToView(appointManager,15).rightSpaceToView(_headerBgView,15).topEqualToView(healthCase).heightEqualToWidth();
    
    [_headerBgView setupAutoHeightWithBottomView:addDoctor bottomMargin:15];
}

- (void)setupTableViews{
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorColor = UIColorFromRGB(0x68c0de);
    [self.view addSubview:_table];
    _table.sd_layout.topSpaceToView(_headerBgView,0).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
    
    [_table registerClass:[FDDcotorListTableViewCell class] forCellReuseIdentifier:@"cell"];

}



#pragma mark - 代理

/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FDDcotorListTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.doctor = self.dataSource[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    DoctorList* doctor = self.dataSource[indexPath.row];
//    
//    if(doctor.applySuccess){
//        [self.navigationController pushViewController:[FDPayViewController new] animated:YES];
//    }else{
//        [self.navigationController pushViewController:[FDDoctorInfoViewController new] animated:YES];
//
//    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 130;
    
    FamilyDoctorEntity* familyDoctor = self.dataSource[indexPath.row];
    
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:familyDoctor keyPath:@"doctor" cellClass:[FDDcotorListTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
    return height;

}


#pragma mark - 点击事件
/**
 *  导航栏右边item
 *
 *  @param sender <#sender description#>
 */
-(void)rightItemAction:(id)sender{
    
    FDSelectFamilyDoctorViewController* selectDoctor = [FDSelectFamilyDoctorViewController new];
    selectDoctor.navgTitle = @"收藏的医生";
    selectDoctor.isCollectDoctor = YES;
    [self.navigationController pushViewController:selectDoctor animated:YES];
    
}

/**
 *  tableHeaderView按钮
 *
 *  @param bt <#bt description#>
 */
- (void)headerViewClick:(UIButton*) bt{
    BaseViewController* vc = nil;
    switch (bt.tag) {
        case 100:{
            //健康方案
            vc = [FDHealthCaseViewController new];
        }
            break;
        case 101:{
            //健康报告
            vc = [FDHealthReportViewController new];
        }
            break;
        case 102:{
            //预约管理
            vc = [FDAppointManagerViewController new];
        }
            break;
        case 103:{
            //添加医生
            vc = [FDSelectFamilyDoctorViewController new];
        }
            break;
    }
    if(bt.tag == 103){
        vc = nil;
        FDSelectFamilyDoctorViewController* selectDoctor = [FDSelectFamilyDoctorViewController new];
        selectDoctor.navgTitle = @"家庭医生";
        [self.navigationController pushViewController:selectDoctor animated:YES];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 

- (CGFloat)cellContentViewWith{
    CGFloat width = kScreenWidth;
    
    //适配ios7
    if([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0){
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width ;
}



@end
