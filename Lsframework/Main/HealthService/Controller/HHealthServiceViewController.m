//
//  HHealthServiceViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HHealthServiceViewController.h"
#import "HHealthServiceCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "HHealthServicePresenter.h"
#import "HealthServiceProductDetailViewController.h"

@interface HHealthServiceViewController ()<UITableViewDelegate, UITableViewDataSource, HHealthServicePresenterDelegate>

@property(nullable,nonatomic,retain) UITableView* table;
@property(nullable,nonatomic,retain) HHealthServicePresenter* presenter;

@end

@implementation HHealthServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"健康服务";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.presenter = [HHealthServicePresenter new];
    self.presenter.delegate = self;
    
    UITableView* table = [UITableView new];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.table = table;
    [table registerClass:[HHealthServiceCell class] forCellReuseIdentifier:@"cell"];
    
    table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
//    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//    }];
//    
//    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//    }];
    
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
    return self.presenter.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HHealthServiceCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.healthServiceProduct = self.presenter.dataSource[indexPath.row];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击单元格");
    HealthServiceProduct* healthService= self.presenter.dataSource[indexPath.row];
    [ProgressUtil show];
    [_presenter loadHealthServiceDetail:healthService.ID];
    
#pragma 打点统计*首页--健康服务-->选择服务--->行

    [BasePresenter  EventStatisticalDotTitle:DotHealthTeachSelect Action:DotEventEnter  Remark:nil];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HealthServiceProduct* healthService= self.presenter.dataSource[indexPath.row];
    
    return [tableView cellHeightForIndexPath:indexPath model:healthService keyPath:@"healthServiceProduct" cellClass:[HHealthServiceCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ProgressUtil show];

    [_presenter loadHealthService];
}

- (void)loadHealthServiceComplete:(BOOL) success message:(NSString* _Nullable) info{
    [ProgressUtil dismiss];

    if (success) {
        [_table reloadData];
    }
}

- (void)loadHealthServiceDetailComplete:(BOOL) success message:(NSString* _Nullable) info{
    [ProgressUtil dismiss];

    if (success) {
        
        HealthServiceProductDetailViewController *vc =[HealthServiceProductDetailViewController new];
        vc.serviceData =_presenter.detailDataSource;
        vc.attributesDataSource =_presenter.attributesDataSource;
        vc.stocksDataSource =_presenter.stocksDataSource;
        
        
        [self.navigationController pushViewController:vc animated:YES];
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
