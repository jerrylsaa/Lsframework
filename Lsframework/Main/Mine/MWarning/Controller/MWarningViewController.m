//
//  MWarningViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/7/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWarningViewController.h"
#import "MWarningTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "MWarningPresenter.h"
#import "HRHealthStaticPageViewController.h"

@interface MWarningViewController ()<UITableViewDelegate,UITableViewDataSource,MWarningPresenterDelegate>{
    UITableView *_table;
    UIView *_blankView;
}
@property (nonatomic,retain) MWarningPresenter *presenter;
@end

@implementation MWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.presenter = [MWarningPresenter new];
    self.presenter.delegate = self;
    [self.presenter loadMyWarningList];
}

- (void)setupView {
    self.title =@"我的提醒";
    self.view.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.0];
    _blankView =[UIView new];
    _blankView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_blankView];
    
    UILabel *blankLabel =[UILabel new];
    blankLabel.textColor =UIColorFromRGB(0x5D5D5D);
    blankLabel.text =@"您尚无提醒消息可查看";
    blankLabel.textAlignment = NSTextAlignmentCenter;
    [_blankView addSubview:blankLabel];
    
    blankLabel.sd_layout.topSpaceToView(_blankView,100).centerXEqualToView(_blankView).heightIs(30).widthIs(300);
    
    _blankView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.0];
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_table registerClass:[MWarningTableViewCell class] forCellReuseIdentifier:@"MWarningTableViewCell"];

    WS(ws);
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter loadMyWarningList];
    }];
    
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter loadMoreWarningList];
    }];

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
    if (self.presenter.dataSource) {
        
        return self.presenter.dataSource.count;
    }else {
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MWarningTableViewCell* cell = [_table dequeueReusableCellWithIdentifier:@"MWarningTableViewCell"];
    cell.myWarning = [self.presenter.dataSource objectAtIndex:indexPath.row];
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRHealthStaticPageViewController *vc =[HRHealthStaticPageViewController new];
    vc.pageType =@"MyWarning";
    vc.staticPageURL =((MWarningEntity *)[self.presenter.dataSource objectAtIndex:indexPath.row]).Url;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_table cellHeightForIndexPath:indexPath model:self.presenter.dataSource[indexPath.row] keyPath:@"myWarning" cellClass:[MWarningTableViewCell class] contentViewWidth:[self cellContentViewWith]];

    
    
}


-(void)onCompletion:(BOOL)success info:(NSString *)messsage{
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    
    if(success){
        _blankView.hidden =YES;
        _table.hidden=NO;
        [_table reloadData];
    }else{
        _table.hidden=YES;
        _blankView.hidden=NO;
//        [ProgressUtil showError:messsage];
    }
}

-(void)MoreOnCompletion:(BOOL)success info:(NSString *)message{
    self.presenter.noMoreData? [_table.mj_footer endRefreshingWithNoMoreData]: [_table.mj_footer endRefreshing];
    if(success){
        [_table reloadData];
    }else{
//        [ProgressUtil showError:message];
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
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-提醒界面"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-提醒界面"];
    
}@end
