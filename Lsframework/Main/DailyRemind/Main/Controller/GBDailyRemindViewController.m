//
//  GBDailyRemindViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GBDailyRemindViewController.h"
#import "GBDailyRemindPresenter.h"
#import "GBDailyRemindCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "DailyViewController.h"

@interface GBDailyRemindViewController ()<GBDailyRemindPresenterDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nullable,nonatomic,retain) GBDailyRemindPresenter* presenter;
@property(nullable,nonatomic,retain) UITableView* table;

@end

@implementation GBDailyRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _presenter = [[GBDailyRemindPresenter alloc] init];
    _presenter.delegate = self;
    
    
}

-(void)setupView{
    self.title = @"每日提醒";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView* table = [UITableView new];
    table.dataSource = self;
    table.delegate = self;
    self.table = table;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[GBDailyRemindCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:table];
    
    table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
 
    WS(ws);
    if(self.time < 1){
        self.time = 1;
    }
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter loadDailyRemindWithDay:ws.time];
    }];
    [table.mj_header beginRefreshing];
    
    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter loadMoreDailyRemind];
    }];
    
}

#pragma mark - 代理
#pragma mark * tableView代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _presenter.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GBDailyRemindCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    DailyRemindEntity* dailyRemind = _presenter.dataSource[indexPath.row];
    
    cell.isCurrentDailRemind = indexPath.row == 0;
    cell.dailyRemind = dailyRemind;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DailyRemindEntity* dailyRemind = _presenter.dataSource[indexPath.row];

    
    DailyViewController  *vc= [DailyViewController  new];
    vc.time = [dailyRemind.remindDay integerValue];
    [self.navigationController  pushViewController:vc animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DailyRemindEntity* dailyRemind = _presenter.dataSource[indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:dailyRemind keyPath:@"dailyRemind" cellClass:[GBDailyRemindCell class] contentViewWidth:[self cellContentViewWith]];

}

#pragma mark * 加载每日提醒代理
-(void)loadDailyRemindComplete:(BOOL)success message:(NSString *)info{
    
    [self.table.mj_header endRefreshing];
    
    if(self.presenter.noMoreData){
        [self.table.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.table.mj_footer endRefreshing];
    }
    
    
    if(success){
        [ProgressUtil dismiss];
        [self.table reloadData];
        
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
