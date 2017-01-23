//
//  PatientCaseController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PatientCaseController.h"
#import "PatientCaseCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "PatientCaseDetailController.h"
#import "PatientCasePresenter.h"

@interface PatientCaseController ()<UITableViewDataSource,UITableViewDelegate,PatientCasePresenterDelegate>

@property (nonatomic, strong) UITableView *caseTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property(nullable,nonatomic,retain) PatientCasePresenter* presenter;

@end

@implementation PatientCaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [PatientCasePresenter new];
    self.presenter.delegate = self;
}

- (void)setupView{
    self.title = @"病友案例";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
}
- (void)setupTableView{
    _caseTableView = [UITableView new];
    _caseTableView.dataSource = self;
    _caseTableView.delegate = self;
    _caseTableView.backgroundColor = [UIColor whiteColor];
    [_caseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_caseTableView];
    _caseTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    WS(ws);
    _caseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter loadPatientCase];
    }];
    [_caseTableView.mj_header beginRefreshing];
    
    _caseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter loadMorePatientCase];
    }];
}

#pragma mark - 代理
#pragma mark * tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.presenter.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_case";
    PatientCaseCell *cell = [_caseTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PatientCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.patientCaseEntity = self.presenter.dataSource[indexPath.row];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientCaseEntity* patientCaseEntity = self.presenter.dataSource[indexPath.row];
    
    return [tableView cellHeightForIndexPath:indexPath model:patientCaseEntity keyPath:@"patientCaseEntity" cellClass:[PatientCaseCell class] contentViewWidth:[self cellContentViewWith]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PatientCaseDetailController *vc = [PatientCaseDetailController new];
    PatientCaseEntity* entity = self.presenter.dataSource[indexPath.row];
    vc.admissionRecordID = entity.admissionRecordID;
    vc.patientCaseEntity = entity;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark * PatientCasePresenter代理
-(void)loadPatientCaseComplete:(BOOL)success message:(NSString *)info{
    [self.caseTableView.mj_header endRefreshing];
    
    if(self.presenter.noMoreData){
        [self.caseTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.caseTableView.mj_footer endRefreshing];
    }
    
    
    if(success){
        [ProgressUtil dismiss];
        [self.caseTableView reloadData];
        
    }else{
        [ProgressUtil showError:info];
    }

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


@end
