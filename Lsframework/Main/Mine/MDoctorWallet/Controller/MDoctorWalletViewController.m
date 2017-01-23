//
//  MDoctorWalletViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorWalletViewController.h"
#import "MWallet.h"
#import "MWalletCell.h"
#import "MWWithdrawViewController.h"
#import "MWRechargeViewController.h"
#import "MDoctoreWalletPresenter.h"
#import "MWalletPassWordViewController.h"
#import "ZFBWithDrawViewController.h"

@interface MDoctorWalletViewController ()<UITableViewDelegate,UITableViewDataSource,MDoctoreWalletPresenterDelegate,UIActionSheetDelegate>{
    UITableView* _table;
    
    UILabel* _account;
    
}

@property(nonatomic,retain) NSArray* sectionTitle;
//@property(nonatomic,retain) NSMutableArray* dataSource;

//@property(nonatomic,retain) NSMutableDictionary* openDic;
@property(nonatomic,retain) MDoctoreWalletPresenter* presenter;

@end

@implementation MDoctorWalletViewController
//-(NSMutableArray *)dataSource{
//    if(!_dataSource){
//        _dataSource=[NSMutableArray array];
//    }
//    return _dataSource;
//}
//
//-(NSMutableDictionary *)openDic{
//    if(!_openDic){
//        _openDic=[NSMutableDictionary dictionary];
//    }
//    return _openDic;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的钱包";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    

    self.presenter = [MDoctoreWalletPresenter new];
    self.presenter.delegate = self;
    [self.presenter checkWalletAccount];
    [self.presenter loadWalletBalance];
    [self.presenter loadWalletConsumption];
    
    [self setupTableView];
    [self setupTableHeaderView];
    
    self.sectionTitle = @[@"账户明细"];
    
//    for(int i=0; i<self.sectionTitle.count; ++i){
//        NSArray* name = @[@"家庭医生套餐",@"特需门诊预约",@"全程就医协助",@"泊车服务",@"微信支付在线充值",@"支付宝支付在线充值",@"提现申请"];
//        [self.openDic setObject:@0 forKey:@(i)];
//        NSMutableArray* walletArray = [NSMutableArray arrayWithCapacity:name.count];
//        for(int j=0; j<name.count; ++j){
//            MWallet* wallet = [MWallet new];
////            wallet.date = [NSString stringWithFormat:@"2016/04/%02d",3+j];
//            wallet.name = name[j];
////            wallet.money = @"1000.00";
//            [walletArray addObject:wallet];
//        }
//        [self.dataSource addObject:walletArray];
//    }
    
}

#pragma mark - 加载子视图

- (void)setupTableView{
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorColor = UIColorFromRGB(0xdbdbdb);
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
//    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
//    [_table layoutSubviews];
    
    [_table registerClass:[MWalletCell class] forCellReuseIdentifier:@"cell"];
    
    WS(ws);
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter loadWalletConsumption];
    }];
    
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter loadMoreWalletConsumption];
    }];

}

- (void)setupTableHeaderView{
    UIView* headerView = [UIView new];
    headerView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:headerView];
    //账号余额
    _account = [UILabel new];
    _account.textColor = UIColorFromRGB(0x535353);
    _account.font = [UIFont systemFontOfSize:18];
    _account.text = @"账户余额：";
    [headerView addSubview:_account];
    UIView* accountLine = [UIView new];
    accountLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [headerView addSubview:accountLine];
    
    UIView* rechargebgView = [UIView new];
    rechargebgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [headerView addSubview:rechargebgView];
    
    //提现
    UIButton* withDraw = [UIButton new];
    [withDraw setTitle:@"提现" forState:UIControlStateNormal];
    [withDraw setBackgroundImage:[UIImage imageNamed:@"mine_withdraw"] forState:UIControlStateNormal];//245*80
    [withDraw addTarget:self action:@selector(widthDrawAction) forControlEvents:UIControlEventTouchUpInside];
    [rechargebgView addSubview:withDraw];
    
    //提示
    UILabel *tipLabel = [UILabel new];
    tipLabel.text =@"收入中平台已收取20%费用";
    tipLabel.font =[UIFont systemFontOfSize:12];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor =[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [rechargebgView addSubview:tipLabel];
    //充值
    
//    UIButton* recharge = [UIButton new];
//    [recharge setTitle:@"充值" forState:UIControlStateNormal];
//    [recharge setBackgroundImage:[UIImage imageNamed:@"mine_recharge"] forState:UIControlStateNormal];//245*80
//    [recharge addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
//    [rechargebgView addSubview:recharge];
    
    UIView* rechargeLine = [UIView new];
    rechargeLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [headerView addSubview:rechargeLine];

    //约束
    _account.sd_layout.topSpaceToView(headerView,15).leftSpaceToView(headerView,10).heightIs(20).rightEqualToView(headerView);
    accountLine.sd_layout.topSpaceToView(_account,15).heightIs(1).leftEqualToView(headerView).rightEqualToView(headerView);
    
    rechargebgView.sd_layout.topSpaceToView(accountLine,0).leftEqualToView(headerView).rightEqualToView(headerView);
//    rechargebgView.sd_equalWidthSubviews = @[tipLabel];
    withDraw.sd_layout.topSpaceToView(rechargebgView,20).leftSpaceToView(rechargebgView,200/2.0).rightSpaceToView(rechargebgView,200/2.0).heightIs(40);
    tipLabel.sd_layout.topSpaceToView(withDraw,20).centerXEqualToView(rechargebgView).leftSpaceToView(rechargebgView,0).rightSpaceToView(rechargebgView,0).heightIs(12);
    
//    recharge.sd_layout.topEqualToView(withDraw).leftSpaceToView(withDraw,45).heightIs(40).rightSpaceToView(rechargebgView,85/2.0);
    [rechargebgView setupAutoHeightWithBottomView:tipLabel bottomMargin:20];
    rechargeLine.sd_layout.topSpaceToView(rechargebgView,0).leftEqualToView(headerView).rightEqualToView(headerView).heightIs(1);
    [headerView setupAutoHeightWithBottomView:rechargeLine bottomMargin:0];
    headerView.sd_layout.topSpaceToView(self.view,0).leftEqualToView(self.view).rightEqualToView(self.view);
    [headerView layoutSubviews];
    
    _table.sd_layout.topSpaceToView(headerView,0).leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view,0);
    [_table layoutSubviews];
//    _table.tableHeaderView = headerView;
    
}




#pragma mark - 代理

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.presenter.dataSource.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.presenter.dataSource.count;
    
}
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray* array=self.dataSource[section];
//    if([self.openDic[@(section)] intValue]){
//        return array.count;
//    }else{
//        return 0;
//    }
////    return 1;
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MWalletCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.wallet = [self.presenter.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString* sectionTitle=self.sectionTitle[section];
    
    UIView* sectionView=[UIView new];
    sectionView.backgroundColor=UIColorFromRGB(0xffffff);
    sectionView.tag = 100+section;
    
    UILabel * titleLabel=[UILabel new];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor=UIColorFromRGB(0x666666);
    titleLabel.text=sectionTitle;
    [sectionView addSubview:titleLabel];
    
    UIImageView * indactorImage=[UIImageView new];
    indactorImage.image=[UIImage imageNamed:@"trangtle"];
    indactorImage.userInteractionEnabled=YES;
    [sectionView addSubview:indactorImage];
    
    UIView* line=[UIView new];
    line.backgroundColor= UIColorFromRGB(0xdbdbdb);
    [sectionView addSubview:line];
    
    
    titleLabel.sd_layout.topSpaceToView(sectionView,15).autoHeightRatio(0).leftSpaceToView(sectionView,10);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    indactorImage.sd_layout.centerYEqualToView(titleLabel).heightIs(10).rightSpaceToView(sectionView,10).widthIs(18);
    
    line.sd_layout.leftEqualToView(sectionView).rightEqualToView(sectionView).heightIs(1).bottomEqualToView(sectionView);
    
    
    //添加手势
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [sectionView addGestureRecognizer:tap];
    
    return sectionView;
}


- (void)pushSetUpPass{
    [self.navigationController pushViewController:[MWalletPassWordViewController new]
     animated:YES];
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 点击事件
/**
 *  提现
 */
- (void)widthDrawAction{

    if([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示：请选择提现方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"支付宝");
            [self.navigationController pushViewController:[ZFBWithDrawViewController new] animated:YES];
            
        }];
        UIAlertAction *determineActionNo2 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"银行卡");
            [self.navigationController pushViewController:[MWWithdrawViewController new] animated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:determineAction];
        [alert addAction:determineActionNo2];

        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
     
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"提示：请选择提现方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"银行卡", nil];
        [sheet showInView:self.view];
        
    }

    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"支付宝0");
        [self.navigationController pushViewController:[ZFBWithDrawViewController new] animated:YES];
//        ScanQRCodeViewController *qrCode = [[ScanQRCodeViewController alloc] init];
//        [self.navigationController pushViewController:qrCode animated:YES];
        
    }else if (buttonIndex == 1) {
        NSLog(@"银行卡1");
        [self.navigationController pushViewController:[MWWithdrawViewController new] animated:YES];
        
    }else if (buttonIndex == 2) {
        NSLog(@"取消2");
        
    }
}
/**
 *  充值
 */
- (void)rechargeAction{
    [self.navigationController pushViewController:[MWRechargeViewController new] animated:YES];
}

/**
 *  点击talbe的setion标题手势
 *
 *  @param tap <#tap description#>
 */
- (void)handleTapGesture:(UITapGestureRecognizer*) tap{
//    NSInteger index=tap.view.tag-100;
//    if([[self.openDic objectForKey:@(index)] integerValue]){
//        [self.openDic setObject:@0 forKey:@(index)];
//    }else{
//        [self.openDic setObject:@1 forKey:@(index)];
//    }
//    [_table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)onBalanceCompletion:(BOOL) loadBalanceSuccess info:(NSString*) messsage{
    _account.text = [NSString stringWithFormat:@"账户余额：%@元",messsage];
}

-(void)onCompletion:(BOOL)success info:(NSString *)messsage{
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    
    if(success){
        
        [_table reloadData];
    }else{
        [ProgressUtil showError:messsage];
    }
}

-(void)MoreOnCompletion:(BOOL)success info:(NSString *)message{
    self.presenter.noMoreData? [_table.mj_footer endRefreshingWithNoMoreData]: [_table.mj_footer endRefreshing];
    if(success){
        [_table reloadData];
    }else{
        [ProgressUtil showError:message];
    }
}
#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的-钱包页面"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的-钱包页面"];
    
}


@end
