//
//  TestVC1.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HExpertAnswerViewController.h"
#import "HExpertAnswerTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "HExpertAnswerPresenter.h"
#import "HEAInfoViewController.h"
#import "HEHospitalAndOfficeTableViewCell.h"
#import "LocationManager.h"


@interface HExpertAnswerViewController ()<UITableViewDataSource,UITableViewDelegate,HExpertAnswerPresenterDelegate,UIGestureRecognizerDelegate>{
    
    UIImageView* _tableHeaderImageView;
    
}
@property(nonatomic,retain) UITableView* table;
@property(nonatomic,retain) HExpertAnswerPresenter* presenter;
@property(nonatomic,strong) UILabel *MajorContent;  //专业
@property(nonatomic,strong) UILabel *SortContent;   //排序

@property(nonatomic,strong) UIView *MajorSortBV;
@property(nonatomic,strong) UIView *OfficeBV;


@property(nonatomic,retain) UITableView* MajorTable;
@property(nonatomic,strong) UIView *MajorView;
@property(nonatomic,strong) UIImageView *MajorIV;

@property(nonatomic,retain) UITableView *officeTable;
@property(nonatomic,strong) UIView *officeView;
@property(nonatomic,strong) UIImageView *officeIV;
@property(nonatomic,retain) NSMutableArray *hptCellArr;
@property(nonatomic,retain) NSMutableArray *officeCellArr;

@property(nonatomic,retain) NSIndexPath *hptSelectIndexpath;
@property(nonatomic,retain) NSIndexPath *officeSelectIndexpath;





@end

@implementation HExpertAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.presenter = [HExpertAnswerPresenter new];
    self.presenter.delegate = self;
    //    [self.presenter loadExpertHospital];
    if ([_hospitalType isEqualToString:@"MyBindHospital"]) {
        [self.presenter loadMyBindHospitalData];

    }else{
        [self.presenter loadExpertOffice];
        [self.presenter loadExpertData];
    }
//    [self.presenter getExperIDByUserID:^(BOOL isDoctor, NSString *message) {
//        
//        if (isDoctor == YES) {
//            NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
//            [user setObject:message forKey:@"DoctorId"];
//        }else{
//            NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
//            
//            [user removeObjectForKey:@"DoctorId"];
//        }
//    }];


}
- (void)setupView{
    self.title = @"咨询专家";
    if ([_hospitalType isEqualToString:@"MyBindHospital"]) {
        self.title =@"我绑定的医院";
    }
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _table = [UITableView new];
    _table.tag =1001;
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
//    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _table.sd_layout.topSpaceToView(self.view, 0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight - 64);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_table registerClass:[HExpertAnswerTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    if (![_hospitalType isEqualToString:@"MyBindHospital"]) {
        [self setupTableHeaderView];

    }
    WS(ws);
    if ([_hospitalType isEqualToString:@"MyBindHospital"]) {
        
        
    }else{
        _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.table.userInteractionEnabled = NO;
            
            [ws.presenter loadExpertData];
            
        }];
    }
    
    if ([_hospitalType isEqualToString:@"MyBindHospital"]) {
        
        
    }else{
        _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ws.table.userInteractionEnabled = NO;
            
            [ws.presenter loadMoreExpertData];
            
        }];
    }
    
    
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];
    
    _MajorSortBV =[[UIView alloc]initWithFrame:window.bounds];
    _MajorSortBV.hidden =YES;
    _MajorSortBV.userInteractionEnabled =YES;
    _MajorSortBV.backgroundColor =[UIColor clearColor];
    UITapGestureRecognizer *hospitalOfficeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hospitalOfficeTap:)];
    hospitalOfficeTap.delegate =self;
    [_MajorSortBV addGestureRecognizer:hospitalOfficeTap];
    [window addSubview:_MajorSortBV];
    
    _MajorView =[UIView new];
    
    [_MajorSortBV addSubview:_MajorView];
    
    _MajorIV =[UIImageView new];
    _MajorIV.image =[UIImage imageNamed:@"HospitalBackground"];
    [_MajorView addSubview:_MajorIV];
    
    _MajorTable = [UITableView new];
    _MajorTable.tag =1002;
    _MajorTable.dataSource = self;
    _MajorTable.delegate = self;
    _MajorTable.backgroundColor = [UIColor clearColor];
    _MajorTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_MajorTable registerClass:[HEHospitalAndOfficeTableViewCell class] forCellReuseIdentifier:@"HospitalCell"];
    [_MajorView addSubview:_MajorTable];
    
    
    _MajorIV.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _MajorTable.sd_layout.topSpaceToView(_MajorView,13).leftSpaceToView(_MajorView,7.5).rightSpaceToView(_MajorView,7.5).bottomSpaceToView(_MajorView,7.5);
    
    
    
    _OfficeBV =[[UIView alloc]initWithFrame:window.bounds];
    _OfficeBV.hidden =YES;
    _OfficeBV.userInteractionEnabled =YES;
    _OfficeBV.backgroundColor =[UIColor clearColor];
    UITapGestureRecognizer *officeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hospitalOfficeTap:)];
    officeTap.delegate =self;
    [_OfficeBV addGestureRecognizer:officeTap];
    [window addSubview:_OfficeBV];
    
    _officeView =[UIView new];
    
    [_OfficeBV addSubview:_officeView];
    
    _officeIV =[UIImageView new];
    _officeIV.image =[UIImage imageNamed:@"OfficeBackground"];
    [_officeView addSubview:_officeIV];
    
    _officeTable = [UITableView new];
    _officeTable.tag =1003;
    _officeTable.dataSource = self;
    _officeTable.delegate = self;
    _officeTable.backgroundColor = [UIColor clearColor];
    _officeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_officeTable registerClass:[HEHospitalAndOfficeTableViewCell class] forCellReuseIdentifier:@"OfficeCell"];
    [_officeView addSubview:_officeTable];
    
    
    _officeIV.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _officeTable.sd_layout.topSpaceToView(_officeView,13).leftSpaceToView(_officeView,7.5).rightSpaceToView(_officeView,7.5).bottomSpaceToView(_officeView,7.5);
    
    
    
    if (self.presenter.hospitalDataSource.count>5) {
        _officeView.sd_layout.topSpaceToView(_OfficeBV,268.5 - 160).rightSpaceToView(_OfficeBV,5).widthIs(119).heightIs(195.5);
    }else{
        _officeView.sd_layout.topSpaceToView(_OfficeBV,268.5 - 160).rightSpaceToView(_OfficeBV,5).widthIs(119).heightIs(20.5+3*35);
    }
    [_officeTable reloadData];
}

- (void)setupTableHeaderView{
    UIView* headerView = [UIView new];
    
//    _tableHeaderImageView = [UIImageView new];
//    _tableHeaderImageView.userInteractionEnabled = YES;
    //    _tableHeaderImageView.backgroundColor = [UIColor greenColor];
//    [headerView addSubview:_tableHeaderImageView];
    
    UIView *appraiseView =[UIView new];
    appraiseView.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [headerView addSubview:appraiseView];
    
    
    
    UIImageView *leftChooseIV =[UIImageView new];
    leftChooseIV.userInteractionEnabled =YES;
    leftChooseIV.image =[UIImage imageNamed:@"ChooseBack"];
    [appraiseView addSubview:leftChooseIV];
    
    UITapGestureRecognizer *hptTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hptTap:)];
    [leftChooseIV addGestureRecognizer:hptTap];
    
    
    UIImageView *rightChooseIV =[UIImageView new];
    rightChooseIV.userInteractionEnabled =YES;
    rightChooseIV.image =[UIImage imageNamed:@"ChooseBack"];
    [appraiseView addSubview:rightChooseIV];
    
    UITapGestureRecognizer *officeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(officeTap:)];
    [rightChooseIV addGestureRecognizer:officeTap];
    
    UILabel *MajorLabel =[UILabel new];
    MajorLabel.font =[UIFont systemFontOfSize:14];
    MajorLabel.textColor =UIColorFromRGB(0x999999);
    MajorLabel.text =@"专业";
    [appraiseView addSubview:MajorLabel];
    
    UILabel *SortLabel =[UILabel new];
    SortLabel.font =[UIFont systemFontOfSize:14];
    SortLabel.textColor =UIColorFromRGB(0x999999);
    SortLabel.text =@"排序";
    [appraiseView addSubview:SortLabel];
    
    _MajorContent =[UILabel new];
    _MajorContent.font =[UIFont systemFontOfSize:14];
    _MajorContent.textAlignment =NSTextAlignmentCenter;
    _MajorContent.textColor =UIColorFromRGB(0x999999);
    _MajorContent.text =@"请选择专业";
    [appraiseView addSubview:_MajorContent];
    
    _SortContent =[UILabel new];
    _SortContent.font =[UIFont systemFontOfSize:14];
    _SortContent.textAlignment =NSTextAlignmentCenter;
    _SortContent.textColor =UIColorFromRGB(0x999999);
    _SortContent.text =@"请选择排序";
    [appraiseView addSubview:_SortContent];
    
    UIImageView *leftDownPull =[UIImageView new];
    leftDownPull.image =[UIImage imageNamed:@"Down_Pull"];
    [appraiseView addSubview:leftDownPull];
    
    UIImageView *rightDownPull =[UIImageView new];
    rightDownPull.image =[UIImage imageNamed:@"Down_Pull"];
    [appraiseView addSubview:rightDownPull];
    
    
    
    
//    _tableHeaderImageView.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0).heightIs(160);
    CGFloat  kk_WIDTH = 28;
    
    if (kScreenWidth >= 370 && kScreenWidth <= 380) {
        //6
        NSLog(@"--------------6---------------");
        kk_WIDTH = 28 *375/320;
        
    }else if (kScreenWidth >= 410 && kScreenWidth <= 420){
        //6  PLUS
        NSLog(@"--------------6  PLUS---------------");
        kk_WIDTH = 28 *414/320;
        
    }

    
    appraiseView.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0).heightIs(50);
//    MajorLabel.sd_layout.topSpaceToView(appraiseView,20.5).leftSpaceToView(appraiseView,10).heightIs(14).widthIs(kk_WIDTH);
    MajorLabel.sd_layout.topSpaceToView(appraiseView,20.5).leftSpaceToView(appraiseView,10).heightIs(14).widthIs(kJMWidth(MajorLabel));
    _MajorContent.sd_layout.topSpaceToView(appraiseView,10.5).leftSpaceToView(MajorLabel,5).widthIs(98).heightIs(35);
    leftDownPull.sd_layout.topSpaceToView(appraiseView,27).leftSpaceToView(_MajorContent,2).widthIs(7).heightIs(4);
    leftChooseIV.sd_layout.topSpaceToView(appraiseView,10.5).leftSpaceToView(MajorLabel,5).widthIs(109).heightIs(35);
    
    rightChooseIV.sd_layout.topSpaceToView(appraiseView,10.5).rightSpaceToView(appraiseView,10).widthIs(109).heightIs(35);
    rightDownPull.sd_layout.topSpaceToView(appraiseView,27).rightSpaceToView(appraiseView,12).widthIs(7).heightIs(4);
    _SortContent.sd_layout.topSpaceToView(appraiseView,10.5).leftSpaceToView(SortLabel,5).widthIs(98).heightIs(35);
    SortLabel.sd_layout.topSpaceToView(appraiseView,20.5).rightSpaceToView(rightChooseIV,5).heightIs(14).widthIs(kJMWidth(SortLabel));
    
    [headerView setupAutoHeightWithBottomView:appraiseView bottomMargin:0];
    
    [headerView layoutSubviews];
    _table.tableHeaderView = headerView;
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
    if (tableView.tag ==1001) {
        if ([_hospitalType isEqualToString:@"MyBindHospital"]) {
            return self.presenter.myBindDataSource.count;
        }
        return self.presenter.dataSource.count;
    }else if(tableView.tag ==1002){
        return self.presenter.officeDataSource.count;
    }else {
        return self.presenter.hospitalDataSource.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    static NSString *hptCellID = @"HospitalCell";
    static NSString *officeCellID = @"OfficeCell";
    
    
    if (tableView.tag ==1001) {
        HExpertAnswerTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell = [[HExpertAnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        if ([_hospitalType isEqualToString:@"MyBindHospital"]) {
            
            cell.expertAnswer = [self.presenter.myBindDataSource objectAtIndex:indexPath.row];
//            if ([[self.presenter.myBindDataSource objectAtIndex:indexPath.row].IsVacation isEqual:@1] ) {
//                //休假中
//                cell.statusImageView.image = [UIImage  imageNamed:@"CouponUN"];
////                cell.moreStatusImageView.image =nil;
//            }else{
//                if ([[self.presenter.myBindDataSource objectAtIndex:indexPath.row].DayUseCouponCount integerValue] >0) {
//                    //优惠券
//                    cell.moreStatusImageView.image = [UIImage  imageNamed:@"Freeclinic2"];
//                    if ([[self.presenter.myBindDataSource objectAtIndex:indexPath.row].IsDuty isEqual:@1]) {
//                        cell.statusImageView.image = [UIImage  imageNamed:@"doctor_duty"];
//                    }else {
//                        cell.statusImageView.image = nil;
//
//                    }
//                }else{
//                    if ([[self.presenter.myBindDataSource objectAtIndex:indexPath.row].IsDuty isEqual:@1]) {
//                        cell.statusImageView.image = [UIImage  imageNamed:@"doctor_duty"];
//                        
//                    }else {
//                        cell.statusImageView.image = nil;
//                        
//                    }
//                }
//            }
        } else {
            cell.expertAnswer = [self.presenter.dataSource objectAtIndex:indexPath.row];
        }
        
        
        
        cell.sd_indexPath = indexPath;
        cell.sd_tableView = _table;
        
        
        return cell;
    }else if(tableView.tag ==1002){
        
        HEHospitalAndOfficeTableViewCell* officeCell = [tableView dequeueReusableCellWithIdentifier:officeCellID];
        if (officeCell==nil) {
            officeCell = [[HEHospitalAndOfficeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:officeCellID];
            
        }
        officeCell.expertOffice =[self.presenter.officeDataSource objectAtIndex:indexPath.row];
        if (indexPath ==_officeSelectIndexpath) {
            officeCell.isSelected =YES;
        }else{
            officeCell.isSelected =NO;
        }
        if (self.officeCellArr==nil) {
            _officeCellArr =[NSMutableArray array];
        }
        [self.officeCellArr addObject:officeCell];
        return officeCell;
        
        
    }else {
        HEHospitalAndOfficeTableViewCell* hptCell = [tableView dequeueReusableCellWithIdentifier:hptCellID];
        if (hptCell==nil) {
            hptCell = [[HEHospitalAndOfficeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hptCellID];
            
        }
        hptCell.contentLabel.text =[self.presenter.hospitalDataSource objectAtIndex:indexPath.row];
        if (indexPath ==_hptSelectIndexpath) {
            hptCell.isSelected =YES;
        }else{
            hptCell.isSelected =NO;
        }
        if (_hptCellArr==nil) {
            _hptCellArr =[NSMutableArray array];
        }
        [self.hptCellArr addObject:hptCell];
        return hptCell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==1001) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        HEAInfoViewController* info = [HEAInfoViewController new];
        if ([_hospitalType isEqualToString:@"MyBindHospital"]) {
            
            info.expertEntity = [self.presenter.myBindDataSource objectAtIndex:indexPath.row];
            info.hospitalType =_hospitalType;
            [self.navigationController pushViewController:info animated:YES];
        }else {
            info.expertEntity = [self.presenter.dataSource objectAtIndex:indexPath.row];
            [kdefaultCenter postNotificationName:Notification_Push object:nil userInfo:@{@"viewController":info}];
        }
        
      #pragma 打点统计*专家解答-->专家-->每一行
        [BasePresenter  EventStatisticalDotTitle:DotHEAninfoView Action:DotEventEnter  Remark:nil];
   

    }else if(tableView.tag ==1003){
        NSLog(@"点击排序列表");
        _hptSelectIndexpath =indexPath;
        HEHospitalAndOfficeTableViewCell* cell =[tableView cellForRowAtIndexPath:indexPath];
        _SortContent.textColor =UIColorFromRGB(0x61d8d3);
        _SortContent.text =cell.contentLabel.text;
        if ([cell.contentLabel.text isEqualToString:@"默认排序"]) {
            self.presenter.hospitalName =1;
            
        }else if ([cell.contentLabel.text isEqualToString:@"咨询由多到少"]) {
            self.presenter.hospitalName =2;
            
        }else if([cell.contentLabel.text isEqualToString:@"价格由低到高"]) {
            self.presenter.hospitalName =3;
            
        }else if([cell.contentLabel.text isEqualToString:@"值班医生"]){
            self.presenter.hospitalName = 9 ;
        }else if ([cell.contentLabel.text isEqualToString:@"位置由近到远"]) {
            self.presenter.hospitalName =10;
            

        }else {
            self.presenter.hospitalName = 7 ;

        }
        
        for (HEHospitalAndOfficeTableViewCell* hptCell in self.hptCellArr) {
            hptCell.isSelected =NO;
        }
        cell.isSelected =YES;
        _OfficeBV.hidden =YES;
        if ([cell.contentLabel.text isEqualToString:@"位置由近到远"]){
            WS(ws);
            [[LocationManager shareInstance] getProvinceAndCityWithBlock:^(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success) {
                if(success){
                    NSLog(@"定位位置10");
                    [ProgressUtil  show];
                    ws.presenter.longitude = longitude;
                    ws.presenter.latitude = latitude;
                    [ws.presenter  loadExpertData];
                    
                }else{
//                    [ProgressUtil showError:@"定位失败"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
//
                }
            }];
            
            
        }else{
            [self.presenter loadExpertData];
        }        
    }else{
        NSLog(@"点击专业列表");
        _officeSelectIndexpath =indexPath;
        HEHospitalAndOfficeTableViewCell* cell =[tableView cellForRowAtIndexPath:indexPath];
        _MajorContent.textColor =UIColorFromRGB(0x61d8d3);
        _MajorContent.text =cell.contentLabel.text;
        self.presenter.officeName =cell.contentLabel.text;
        for (HEHospitalAndOfficeTableViewCell* officeCell in self.officeCellArr) {
            officeCell.isSelected =NO;
            
        }
        
        cell.isSelected =YES;
        _MajorSortBV.hidden =YES;
         [self.presenter loadExpertData];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==1001) {
        if ([_hospitalType isEqualToString:@"MyBindHospital"]) {
            return [_table cellHeightForIndexPath:indexPath model:self.presenter.myBindDataSource[indexPath.row] keyPath:@"expertAnswer" cellClass:[HExpertAnswerTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        
        }else {
        
        return [_table cellHeightForIndexPath:indexPath model:self.presenter.dataSource[indexPath.row] keyPath:@"expertAnswer" cellClass:[HExpertAnswerTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        }
    }else {
        return 35;
    }
    
}

-(void)onCompletion:(BOOL)success info:(NSString *)messsage{
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    _table.userInteractionEnabled = YES;
    if(success){
        [ProgressUtil  dismiss];
        [_table reloadData];
    }else{
        [ProgressUtil showError:messsage];
    }
}

-(void)MoreOnCompletion:(BOOL)success info:(NSString *)message{
    self.presenter.noMoreData? [_table.mj_footer endRefreshingWithNoMoreData]: [_table.mj_footer endRefreshing];
    _table.userInteractionEnabled = YES;
    if(success){
        [_table reloadData];
    }else{
        [ProgressUtil showError:message];
    }
}

- (void)bannerOnCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        [_tableHeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.presenter.bannerURL] placeholderImage:nil];
    }
}


- (void)hptTap:(UITapGestureRecognizer *)tap{
    NSLog(@"点击医院列表");
    [UIView animateWithDuration:0.3 animations:^{
        _table.contentOffset =CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        _MajorSortBV.hidden =!_MajorSortBV.hidden;
        
    }];
}

- (void)officeTap:(UITapGestureRecognizer *)tap{
    NSLog(@"点击科室列表");
    [UIView animateWithDuration:0.3 animations:^{
        _table.contentOffset =CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        _OfficeBV.hidden =!_OfficeBV.hidden;
        
    }];
    
}

- (void)hospitalOfficeTap:(UITapGestureRecognizer *)tap{
    tap.view.hidden =YES;
}

- (void)onGetHospitalCompletion:(BOOL) success info:(NSString*) messsage{
    
}

- (void)onGetOfficeCompletion:(BOOL) success info:(NSString*) messsage{
    if (self.presenter.officeDataSource.count>5) {
        
        _MajorView.sd_layout.topSpaceToView(_MajorSortBV,268.5 - 160).leftSpaceToView(_MajorSortBV,5).widthIs(147).heightIs(195.5);
    }else{
        
        _MajorView.sd_layout.topSpaceToView(_MajorSortBV,268.5 - 160).leftSpaceToView(_MajorSortBV,5).widthIs(147).heightIs(20.5+self.presenter.officeDataSource.count*35);
    }
    [_MajorTable reloadData];
    
}
#pragma mark - 私有方法

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//
//{
//
//    if([gestureRecognizer.view isKindOfClass:[UITableView class]]) {
//
//        return NO;
//
//    }
//
//    return  YES;
//
//}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_MajorTable]|[touch.view isDescendantOfView:_officeTable]) {
        return NO;
    }
    return YES;
}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"咨询专家首页"];
#pragma 打点统计*咨询专家segment
    [BasePresenter  EventStatisticalDotTitle:DotExpertSegment Action:DotEventEnter  Remark:nil];
  

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"咨询专家首页"];
    
}



@end
