//
//  CouponViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponPresenter.h"
#import "CouponableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "CouponList.h"
@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate,CouponPresenterDelegate>

@property(nonatomic,retain) UITableView* table;
@property(nonatomic,retain) CouponPresenter* presenter;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setupView];
    self.title = @"优惠券";
    
}
-(void)setupView{
    


    _table = [UITableView new];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
  [self.view  addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerClass:[CouponableViewCell class] forCellReuseIdentifier:@"cell"];
    
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
    NSLog(@"数量%ld",self.presenter.dataSource.count);
    
    
    return self.presenter.dataSource.count;
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.couponList = [self.presenter.dataSource objectAtIndex:indexPath.row];
    if ( [[NSString  stringWithFormat:@"%@",  [self.presenter.dataSource objectAtIndex:indexPath.row].ClaimStatus] isEqualToString: @"0" ]) {
        //未使用
        cell.CouponImageView.image = [UIImage  imageNamed:@"UnusedCoupon"];
    }else
        if( [[NSString  stringWithFormat:@"%@",[self.presenter.dataSource objectAtIndex:indexPath.row].ClaimStatus] isEqualToString: @"1" ]){
            //已使用
            cell.CouponImageView.image =[UIImage  imageNamed:@"usedCoupon"] ;
        }else{
            //已过期
            
            cell.CouponImageView.image = [UIImage  imageNamed:@"outdateCoupon"];
            
        }
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
return [_table cellHeightForIndexPath:indexPath model:self.presenter.dataSource[indexPath.row] keyPath:@"couponList" cellClass:[CouponableViewCell  class] contentViewWidth:[self cellContentViewWith]];
}
-(void)GetCouPonListCompletion:(BOOL)success info:(NSString*)message{

    if(success){
        
        [_table reloadData];
    }else{
        [ProgressUtil showError:message];
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
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-优惠券界面"];
    _presenter = [CouponPresenter new];
    _presenter.delegate = self;
    [_presenter  getCouPonList];


}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-优惠券界面"];
    


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
