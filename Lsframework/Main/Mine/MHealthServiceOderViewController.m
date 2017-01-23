//
//  MHealthServiceOderViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MHealthServiceOderViewController.h"
#import "MHealthServiceCell.h"
#import "MHSOderDetailEntity.h"
#import "MHealthServiceOderListEntity.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "MHSOderDetailViewController.h"
#import "WXApi.h"

@interface MHealthServiceOderViewController ()<UITableViewDelegate, UITableViewDataSource,MHealthServicePresenterDelegate,MHealthServiceCellDelegate>

@property(nullable,nonatomic,retain) UITableView* table;
@end
@implementation MHealthServiceOderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
}

#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"我的服务";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.presenter = [MHealthServicePresenter new];
    self.presenter.delegate = self;
    
    _table = [UITableView new];
    _table.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    [_table registerClass:[MHealthServiceCell class] forCellReuseIdentifier:@"cell"];
    
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
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
    MHealthServiceCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell.delegate){
        cell.delegate = self;
    }
    cell.myOderList = self.presenter.dataSource[indexPath.row];
    cell.myOderDetail =((NSArray *)(self.presenter.detailArr[indexPath.row]))[0];
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击单元格");
    MHSOderDetailViewController *vc =[MHSOderDetailViewController new];
    
    MHealthServiceOderListEntity* list= self.presenter.dataSource[indexPath.row];
    MHSOderDetailEntity *detail =((NSArray *)(self.presenter.detailArr[indexPath.row]))[0];
    MHSOderAddressEntity *address =self.presenter.addressArr[indexPath.row];
    vc.myDetailEntity =detail;
    vc.myOderListEntity =list;
    vc.myAddressEntity =address;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MHSOderDetailEntity* myOderDetail= ((NSArray *)(self.presenter.detailArr[indexPath.row]))[0];;
    
    return [tableView cellHeightForIndexPath:indexPath model:myOderDetail keyPath:@"myOderDetail" cellClass:[MHealthServiceCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ProgressUtil show];
    
    [_presenter loadMHealthSerivieOderList];
}

- (void)loadHealthServiceComplete:(BOOL) success message:(NSString* _Nullable) info{
    [ProgressUtil dismiss];
    
    if (success) {
        [_table reloadData];
    }
}

- (void)paySuccess{
    NSLog(@"cell支付宝支付成功");
    [ProgressUtil showSuccess:@"支付成功"];
    [ProgressUtil show];

    [_presenter loadMHealthSerivieOderList];
}

- (void)onCheckWXPayResultWithOderCompletion:(BOOL) success info:(NSString* _Nullable) message Url:(NSString * _Nullable)url{
    if (success) {
        [ProgressUtil showSuccess:@"支付成功"];
        [ProgressUtil show];

        [_presenter loadMHealthSerivieOderList];
    }else{
        [ProgressUtil showInfo:message];
    }
}

- (void)cancelOderComplete:(BOOL) success message:(NSString* _Nullable) info{
    if (success) {
        [ProgressUtil showSuccess:info];
        [ProgressUtil show];

        [_presenter loadMHealthSerivieOderList];
    }else{
        [ProgressUtil showError:info];
        [ProgressUtil show];

        [_presenter loadMHealthSerivieOderList];

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

- (void)backItemAction:(id)sender{
    if (_noDirectPush==2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
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
