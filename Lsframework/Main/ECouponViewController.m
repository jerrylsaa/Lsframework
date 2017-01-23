//
//  ECouponViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ECouponViewController.h"
#import "CouponListPresenter.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "ECouponTableViewCell.h"
#import "CouponList.h"
#import "HEAInfoViewController.h"
#import "WXApi.h"

@interface ECouponViewController ()<UITableViewDataSource,UITableViewDelegate,CouponListPresenterDelegate,UIActionSheetDelegate>{
    NSInteger  index;

}

@property(nonatomic,retain) UITableView* table;
@property(nonatomic,retain) CouponListPresenter* presenter;
@property(nonatomic,strong) UIButton* commitBtn;
@property(nonatomic,strong) UIButton* starButton;
@property(nonatomic,strong) NSMutableArray *couponCellArr;
//@property(nonatomic,retain) NSIndexPath *cellSelectIndexpath;
@property(nonatomic,assign) BOOL haveSelectedCell;
@end

@implementation ECouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    
}
-(void)setupView{
    index =-1;
    _table = [UITableView new];
    _table.delegate = self;
    _table.dataSource = self;
//    _table.delaysContentTouches = NO;
    _table.backgroundColor = [UIColor clearColor];
    [self.view  addSubview:_table];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_table registerClass:[ECouponTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    
    UIView* tableFooterView = [UIView new];
    
    _commitBtn = [UIButton new];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"COUPON_Commit"] forState:UIControlStateNormal];
    
    [_commitBtn addTarget:self action:@selector(CommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:_commitBtn];
    
    _commitBtn.sd_layout.topSpaceToView(tableFooterView,100/2).centerXEqualToView(tableFooterView).heightIs(kFitHeightScale(80)).widthIs(kFitWidthScale(690));
    [tableFooterView setupAutoHeightWithBottomView:_commitBtn bottomMargin:20];
    [_commitBtn setHidden:NO];
    [tableFooterView layoutSubviews];
    _table.tableFooterView = tableFooterView;
   
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
    NSLog(@"数量%ld",(unsigned long)self.presenter.CouponListSource.count);
    
    
    return self.presenter.CouponListSource.count;
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ECouponTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.userInteractionEnabled = YES;
//    cell.contentView.userInteractionEnabled = YES;
    cell.couponList = [self.presenter.CouponListSource objectAtIndex:indexPath.row];

    
    if (indexPath.row ==index) {
        
        cell.isSelected =YES;
    }else{
        cell.isSelected =NO;
    }
//    [cell.CouponBtn  addTarget:self action:@selector(CouPonClick:) forControlEvents:UIControlEventTouchUpInside];
//    cell.CouponBtn.tag = indexPath.row;
    
    if ( [[NSString  stringWithFormat:@"%@",  [self.presenter.CouponListSource objectAtIndex:indexPath.row].ClaimStatus] isEqualToString: @"0" ]) {
        //未使用
        cell.CouponImageView.image = [UIImage  imageNamed:@"UnusedCoupon"];
    }
    [self.couponCellArr addObject:cell];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    _cellSelectIndexpath =indexPath;
    index =indexPath.row;
    
    for (ECouponTableViewCell* cell in _couponCellArr) {
        cell.isSelected =NO;
        
    }
    ECouponTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected =YES;
    _haveSelectedCell =YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [_table cellHeightForIndexPath:indexPath model:self.presenter.CouponListSource[indexPath.row] keyPath:@"couponList" cellClass:[ECouponTableViewCell  class] contentViewWidth:[self cellContentViewWith]];
}
-(void)GetCouPonListCompletion:(BOOL)success info:(NSString*)message{
    
    if(success){

        for (NSInteger  i= 0; i<_presenter.CouponListSource.count; i++){
    if ([[NSString stringWithFormat:@"%@", _presenter.CouponListSource[i].ClaimStatus]  isEqualToString: @"1"]||[[NSString stringWithFormat:@"%@", _presenter.CouponListSource[i].ClaimStatus]  isEqualToString: @"2"] ) {
        [_presenter.CouponListSource  removeObjectAtIndex:i];
        i--;
       }
    }
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _presenter = [CouponListPresenter new];
    _presenter.delegate = self;
    [_presenter  getCouPonList];
    
    
}
#pragma mark----点击事件
-(void)CouPonClick:(UIButton*)btn{
    if(btn!=self.starButton){
        
        self.starButton.selected=NO;
        self.starButton=btn;
    }
    self.starButton.selected=YES;
    
    if (btn.selected == YES) {
        NSLog(@"当前行：%d",btn.tag);
        
        index = btn.tag;
    }
    
}

-(void)CommitBtn{
    
    if (_haveSelectedCell ==NO){
        
        [ProgressUtil  showInfo:@"您未选择任何优惠券"];
    }
    else{
        CouponList  *model=[self.presenter.CouponListSource objectAtIndex:index];
        
        [_presenter  GetConsultationConsumptionCouponPriceWithCouponID:model.CouponID Expert_ID:self.doctorID];
        
//        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
//        [sheet showInView:self.view];
        
    
    }

}

-(void)GetConsultationCouponPriceCompletion:(BOOL)success info:(NSString*)message{
    
        if (success) {
            NSLog(@"8888888888888888");
            if (_presenter.Status == 0) {
                if(_presenter.price == 0){
                    [ProgressUtil  showInfo:@"咨询成功"];
                    CouponList  *model=[self.presenter.CouponListSource objectAtIndex:index];
                    [self.delegate payFreeByCouponID:model.CouponID];
                    [self.navigationController   popViewControllerAnimated:YES];
                    
                }else if(_presenter.price >0){
                    [ProgressUtil dismiss];
                    
                    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"您还需要支付%.2f元,请选择支付方式",_presenter.price] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
                    [sheet showInView:self.view];
                    
                }
                
            }
        }
        else{
            NSLog(@"999999999999");
            
            [ProgressUtil  showError:message];
        }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"支付宝支付");
        _commitBtn.userInteractionEnabled = YES;
        CouponList  *model=[self.presenter.CouponListSource objectAtIndex:index];
        NSLog(@"提交：%@",model.CouponID);
        [ self.delegate  GetCouponID:model.CouponID];
        
        [self.navigationController   popViewControllerAnimated:YES];


        
    }else if (buttonIndex == 1){
        NSLog(@"微信支付");
        _commitBtn.userInteractionEnabled = YES;
        CouponList  *model=[self.presenter.CouponListSource objectAtIndex:index];
        NSLog(@"提交：%@",model.CouponID);
        [self.delegate  wxPayByUseCouponID:model.CouponID];
        
        [self.navigationController   popViewControllerAnimated:YES];
        
        
        
        
    }else if (buttonIndex ==2){
        NSLog(@"取消");
        
        
    }
}

- (NSMutableArray *)couponCellArr{
    if (_couponCellArr==nil) {
        _couponCellArr =[NSMutableArray array];
    }
    return _couponCellArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
