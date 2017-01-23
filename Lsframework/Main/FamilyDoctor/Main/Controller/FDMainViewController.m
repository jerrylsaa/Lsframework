//
//  FDMainViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//  医生模块入口

#import "FDMainViewController.h"
#import "FDDcotorListViewController.h"
#import "LocationManager.h"
#import "FDMainPresenter.h"

#import "FDDcotorListTableViewCell.h"
#import "FDDoctorInfoViewController.h"
#import "FDSelectFamilyDoctorViewController.h"
#import "OutpatientSuccessViewController.h"
#import "FDHealthCaseViewController.h"
#import "FDHealthReportViewController.h"
#import "FDAppointManagerViewController.h"
#import "FDPayViewController.h"
#import "FDApplyDoctorViewController.h"
#import "FDCollectFamilyDoctorViewController.h"

#import <UITableView+SDAutoTableViewCellHeight.h>


@interface FDMainViewController ()<FDMainPresenterDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIScrollView* _scroll;
    UIImageView* _headerImage;
    UILabel* _titleLabel;
    UIButton* _addButton;
    
    UIView* _headerBgView;
    UITableView* _table;
    
}

@property(nonatomic,retain) FDMainPresenter* presenter;

@property(nonatomic,retain) UIView* noFamilyDoctorView;

@property(nonatomic,retain) UIView* fdFamilyDoctorView;

@property(nonatomic,retain) NSArray* dataSource;


@end

@implementation FDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"家庭医生";
    [self initBackBarWithImage:nil];
    [self initRightBarWithTitle:@"收藏"];
    
//    for(int i=0; i<20; ++i){
//        DoctorList* doctor = [DoctorList new];
//        if(i == 0){
//            doctor.applySuccess = YES;
//        }else if (i == 1){
//            doctor.serviceOutdate = @"2016年4月4日服务到期";
//        }
//        [self.dataSource addObject:doctor];
//    }


    self.presenter = [FDMainPresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter getFamilyDoctor];
    
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.rdv_tabBarController setTabBarHidden:NO animated:animated];
}

#pragma mark - 注册通知
- (void)registerNotification{
    [kdefaultCenter addObserver:self selector:@selector(updateFamilyDoctorList) name:Notification_UpdateFamilyDoctor object:nil];
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    DoctorList* doctor = self.dataSource[indexPath.row];
//    
//    if(doctor.applySuccess){
//        [self.navigationController pushViewController:[FDPayViewController new] animated:YES];
//    }else{
//        [self.navigationController pushViewController:[FDDoctorInfoViewController new] animated:YES];
//
//    }
    FamilyDoctorEntity* doctor = self.dataSource[indexPath.row];
    if(doctor.orderState == 0){
//        [self.navigationController pushViewController:[FDPayViewController new] animated:YES];
        FDDoctorInfoViewController* info = [FDDoctorInfoViewController new];
        info.doctor = doctor;
        [self.navigationController pushViewController:info animated:YES];
    }else if(doctor.orderState == 2){
        FDDoctorInfoViewController* info = [FDDoctorInfoViewController new];
        info.doctor = doctor;
        [self.navigationController pushViewController:info animated:YES];

    }
    

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FamilyDoctorEntity* familyDoctor = self.dataSource[indexPath.row];
    
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:familyDoctor keyPath:@"doctor" cellClass:[FDDcotorListTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
    return height;
}

-(void)onCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        [ProgressUtil dismiss];
        NSLog(@"＝＝更新列表");
        if(self.presenter.hasFamilyDoctor){
            [self.view addSubview:self.fdFamilyDoctorView];
            _fdFamilyDoctorView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
            self.dataSource = self.presenter.dataSource;
            [_table reloadData];
        }else{
            [self.view addSubview:self.noFamilyDoctorView];
            _noFamilyDoctorView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

        }
    }else{
        [ProgressUtil showError:message];
    }
}

#pragma mark - 懒加载

-(UIView *)noFamilyDoctorView{
    if(!_noFamilyDoctorView){
        _noFamilyDoctorView = [UIView new];
        _noFamilyDoctorView.backgroundColor = UIColorFromRGB(0xffffff);

        _scroll = [UIScrollView new];
        _scroll.showsVerticalScrollIndicator=NO;
        [_noFamilyDoctorView addSubview:_scroll];
        _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        //头像
        _headerImage = [UIImageView new];
        _headerImage.userInteractionEnabled = YES;
        _headerImage.image = [UIImage imageNamed:@"doctor_icon"];
        [_scroll addSubview:_headerImage];
        _headerImage.sd_layout.topSpaceToView(_scroll,80).heightIs(150).widthEqualToHeight().centerXEqualToView(_scroll);
        //title
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColorFromRGB(0x7FD9CB);
        _titleLabel.text = @"您还没有添加任何医生";
        [_scroll addSubview:_titleLabel];
        _titleLabel.sd_layout.topSpaceToView(_headerImage,128/2.0).heightIs(20).centerXEqualToView(_scroll);
        [_titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
        //添加按钮
        _addButton = [UIButton new];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"doctor_addNow"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [_scroll addSubview:_addButton];
        _addButton.sd_layout.topSpaceToView(_titleLabel,128/2.0).heightIs(40).centerXEqualToView(_scroll).widthIs(245/2.0);
        
        [_scroll setupAutoContentSizeWithBottomView:_addButton bottomMargin:20];
        [_noFamilyDoctorView setupAutoHeightWithBottomView:_scroll bottomMargin:0];
        
    }
    return _noFamilyDoctorView;
}

-(UIView *)fdFamilyDoctorView{
    if(!_fdFamilyDoctorView){
    
        _fdFamilyDoctorView = [UIView new];
        _fdFamilyDoctorView.backgroundColor = UIColorFromRGB(0xffffff);
        
        _headerBgView = [UIView new];
        _headerBgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [_fdFamilyDoctorView addSubview:_headerBgView];
        _headerBgView.sd_layout.topSpaceToView(_fdFamilyDoctorView,0).leftSpaceToView(_fdFamilyDoctorView,0).rightSpaceToView(_fdFamilyDoctorView,0);
        
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
        
        _table = [UITableView new];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorColor = UIColorFromRGB(0x68c0de);
        [_fdFamilyDoctorView addSubview:_table];
        _table.sd_layout.topSpaceToView(_headerBgView,0).leftSpaceToView(_fdFamilyDoctorView,0).rightSpaceToView(_fdFamilyDoctorView,0).bottomSpaceToView(_fdFamilyDoctorView,0);

        [_table registerClass:[FDDcotorListTableViewCell class] forCellReuseIdentifier:@"cell"];

    }
    return _fdFamilyDoctorView;
}

#pragma mark - 点击事件
/**
 *  马上添加
 */
- (void)addAction{
    
    FDSelectFamilyDoctorViewController* selectDoctor = [FDSelectFamilyDoctorViewController new];
    selectDoctor.navgTitle = @"家庭医生";
    [self.navigationController pushViewController:selectDoctor animated:YES];

    
}

/**
 *  导航栏右边item
 *
 *  @param sender <#sender description#>
 */
-(void)rightItemAction:(id)sender{
    
    FDCollectFamilyDoctorViewController* collectDoctor = [FDCollectFamilyDoctorViewController new];
    [self.navigationController pushViewController:collectDoctor animated:YES];
    
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

#pragma mark - 通知回调
- (void)updateFamilyDoctorList{
    [self.presenter getFamilyDoctor];
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

-(void)dealloc{
    [kdefaultCenter removeObserver:self name:Notification_UpdateFamilyDoctor object:nil];
}






@end
