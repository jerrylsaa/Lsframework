//
//  FDHealthCaseViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDHealthCaseViewController.h"
#import "HealthCaseInfoViewController.h"
#import "HealthCaseBlueCell.h"
#import "HealthCaseGreenCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "FDHealthCasePresenter.h"


@interface FDHealthCaseViewController ()<UITableViewDataSource,UITableViewDelegate,FDHealthCasePresenterDelegate>{
    UITableView* _table;
}

@property(nonatomic,retain) NSArray* dataSource;

@property(nonatomic,retain) FDHealthCasePresenter* presenter;

@end

@implementation FDHealthCaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.presenter = [FDHealthCasePresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter requtestData];

}

-(void)setupView{
    self.title = @"健康方案";
    
    [self setupTableView];
    [self setupTableHeaderView];
    
}

- (void)setupTableView{
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_table registerClass:[HealthCaseBlueCell class] forCellReuseIdentifier:@"blueCell"];
    [_table registerClass:[HealthCaseGreenCell class] forCellReuseIdentifier:@"greenCell"];
    
}

- (void)setupTableHeaderView{
    UIView* headerView = [UIView new];
    
    //图片
    UIImageView* headerImageView = [UIImageView new];
    headerImageView.userInteractionEnabled = YES;
    headerImageView.image = [UIImage imageNamed:@"doctor_healthCase_header"];
    headerImageView.tag = 101;
    [headerView addSubview:headerImageView];
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerGesture)];
//    [headerImageView addGestureRecognizer:tap];
    
    //标题
    UILabel* title = [UILabel new];
    title.font = [UIFont systemFontOfSize:18];
    title.text = @"按阶段执行健康方案";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = UIColorFromRGB(0x525252);
    [headerView addSubview:title];
    
    //分割线
    UIView* line = [UIView new];
    line.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [headerView addSubview:line];
    
    //约束
    headerImageView.sd_layout.topEqualToView(headerView).heightIs(310/2.0).leftEqualToView(headerView).rightEqualToView(headerView);
    title.sd_layout.topSpaceToView(headerImageView,0).heightIs(50).leftEqualToView(headerView).rightEqualToView(headerView);
    line.sd_layout.topSpaceToView(title,0).heightIs(1).leftEqualToView(headerView).rightEqualToView(headerView);
    
    
    [headerView setupAutoHeightWithBottomView:line bottomMargin:0];
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
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FDHealthCaseEntity* heathCase = self.dataSource[indexPath.row];
    if(!(indexPath.row%2)){
        HealthCaseBlueCell* cell = [tableView dequeueReusableCellWithIdentifier:@"blueCell"];
        
        cell.healthCase = heathCase;
        cell.sd_tableView = tableView;
        cell.sd_indexPath = indexPath;
        return cell;

    }else{
        HealthCaseGreenCell* cell = [tableView dequeueReusableCellWithIdentifier:@"greenCell"];
        cell.healthCase = heathCase;
        cell.sd_tableView = tableView;
        cell.sd_indexPath = indexPath;
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HealthCaseInfoViewController* healthCaseInfo = [HealthCaseInfoViewController new];
    healthCaseInfo.healthCase = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:healthCaseInfo animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FDHealthCaseEntity* healthCase = self.dataSource[indexPath.row];
    
    Class currentClass = nil;
    
    if(!(indexPath.row%2)){
        currentClass = [HealthCaseBlueCell class];
    }else{
        currentClass = [HealthCaseGreenCell class];
    }
    
    return [tableView cellHeightForIndexPath:indexPath model:healthCase keyPath:@"healthCase" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}

-(void)onCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        [ProgressUtil dismiss];
        self.dataSource = self.presenter.dataSource;
        [_table reloadData];
    }else{
        [ProgressUtil showError:message];
    }
}



#pragma mark - 点击

- (void)handlerGesture{
    [self.navigationController pushViewController:[HealthCaseInfoViewController new] animated:YES];
}

#pragma mark - 

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
