//
//  MWRechargeViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWRechargeViewController.h"
#import "MWRechargeCell.h"
#import "LeftTitleTextField.h"
#import "FPNetwork.h"
#import "AliPayUtil.h"

@interface MWRechargeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView* _table;
    LeftTitleTextField* _tf;
    
}

@property(nonatomic,retain) NSArray* sectionTitle;
@property(nonatomic,retain) NSMutableArray* dataSource;

@property(nonatomic,retain) NSMutableDictionary* openDic;



@end

@implementation MWRechargeViewController
-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableDictionary *)openDic{
    if(!_openDic){
        _openDic=[NSMutableDictionary dictionary];
    }
    return _openDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.sectionTitle=@[@"支付方式:"];
    for(int i=0;i<self.sectionTitle.count;++i){
        [self.openDic setObject:@1 forKey:@(i)];
        //支付
        NSArray* pay=@[@"支付宝"];
        [self.dataSource addObject:pay];
    }
}

- (void)setupView{
    self.title = @"账户充值";
    
    [self setupTableView];
    [self setupTableHeaderView];
    [self setupTableFooterView];
}

- (void)setupTableView{
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorColor = UIColorFromRGB(0xdbdbdb);
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_table layoutSubviews];
    
    [_table registerClass:[MWRechargeCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setupTableHeaderView{
    UIView* headerView = [UIView new];
    headerView.backgroundColor = UIColorFromRGB(0xffffff);
    
    _tf = [LeftTitleTextField new];
    _tf.keyboardType = UIKeyboardTypePhonePad;
    _tf.font = [UIFont systemFontOfSize:18];
    _tf.textColor = UIColorFromRGB(0x868686);
    _tf.titleColor = _tf.textColor;
    _tf.titleFont = _tf.font;
    _tf.title = @"请输入充值金额：";
    [headerView addSubview:_tf];
    
    UIView* line = [UIView new];
    line.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [headerView addSubview:line];
    
    _tf.sd_layout.topSpaceToView(headerView,15).leftSpaceToView(headerView,20).rightSpaceToView(headerView,20);
    line.sd_layout.topSpaceToView(_tf,15).leftEqualToView(headerView).rightEqualToView(headerView).heightIs(1);
    [headerView setupAutoHeightWithBottomView:line bottomMargin:0];
    
    [headerView layoutSubviews];
    _table.tableHeaderView = headerView;
}

- (void)setupTableFooterView{
    UIView* footerView = [UIView new];
    footerView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIButton* recharge = [UIButton new];
    recharge.titleLabel.font = [UIFont systemFontOfSize:18];
    [recharge setTitle:@"确认充值" forState:UIControlStateNormal];
    [recharge setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
    [recharge addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:recharge];
    
    recharge.sd_layout.topSpaceToView(footerView,190/2.0).leftSpaceToView(footerView,10).rightSpaceToView(footerView,10).heightIs(40);
    
    [footerView setupAutoHeightWithBottomView:recharge bottomMargin:0];
    [footerView layoutSubviews];
    _table.tableFooterView = footerView;
}

#pragma mark - 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* array=self.dataSource[section];
    if([self.openDic[@(section)] intValue]){
        return array.count;
    }else{
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MWRechargeCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray* array = self.dataSource[indexPath.section];
    cell.title.text = array[indexPath.row];
    
    
    
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
    
    
    titleLabel.sd_layout.topSpaceToView(sectionView,15).autoHeightRatio(0).leftSpaceToView(sectionView,20);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    indactorImage.sd_layout.centerYEqualToView(titleLabel).heightIs(10).rightSpaceToView(sectionView,20).widthIs(18);
    
    line.sd_layout.leftEqualToView(sectionView).rightEqualToView(sectionView).heightIs(1).bottomEqualToView(sectionView);
    
    
    //添加手势
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [sectionView addGestureRecognizer:tap];
    
    return sectionView;
}

#pragma mark - 点击事件

/**
 *  点击talbe的setion标题手势
 *
 *  @param tap <#tap description#>
 */
- (void)handleTapGesture:(UITapGestureRecognizer*) tap{
    NSInteger index=tap.view.tag-100;
    if([[self.openDic objectForKey:@(index)] integerValue]){
        [self.openDic setObject:@0 forKey:@(index)];
    }else{
        [self.openDic setObject:@1 forKey:@(index)];
    }
    [_table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/**
 *  充值
 */
- (void)rechargeAction{
    NSLog(@"确认充值");
    WS(ws);
    NSDictionary * params = @{@"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId],@"Price":[NSNumber numberWithFloat:0.01],@"Business":@"钱包充值",@"PayType":@"支付宝支付"};
    [[FPNetwork POST:API_INSERT_PAYORDER withParams:params] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            NSDictionary* dic = [response.data firstObject];
            NSLog(@"%@",[dic[@"OrderID"] stringValue]);
            [ws submitAlipayRequest:[dic[@"OrderID"] stringValue]];
            
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];
}

- (void)submitAlipayRequest:(NSString *)oderID{
    WS(ws);
    [AliPayUtil payWithTitle:@"钱包充值" withDetail:@"详情" withOrderNum:oderID withPrice:0.01 callback:^(NSDictionary*dict){
        //支付成功调用，订单支付成功接口，并且调用插入咨询表的接口
        NSString* payStatus = dict[@"resultStatus"];
        if([payStatus isEqualToString:@"9000"]){
            NSLog(@"支付成功%@",[ws stringFromDate:[NSDate new]]);
            
//            [ws.presenter tradePaySuccess];
            [ws confirmAlipayRequestSuccess:@"0.01" with:@"支付宝支付" with:@"1" with:@"钱包充值" with:[ws stringFromDate:[NSDate new]]];
            
        }else if([payStatus isEqualToString:@"6001"]){
            NSLog(@"用户中途取消支付");
            [ProgressUtil showInfo:@"用户取消支付"];
        }else if([payStatus isEqualToString:@"6002"]){
            NSLog(@"网络连接出错");
            [ProgressUtil showInfo:@"网络连接出错"];
        }else if([payStatus isEqualToString:@"4000"]){
            NSLog(@"订单支付失败");
            [ProgressUtil showInfo:@"订单支付失败"];
        }else{
            NSLog(@"正在处理中");
        }
        
    }];
    
}

- (void)confirmAlipayRequestSuccess:(NSString *)rechargemoney with:(NSString *)paytype with:(NSString *)rechargestatus with:(NSString *)rechargedescribe with:(NSString *)rechargetime {
    
    WS(ws);
    NSDictionary * params = @{@"userid":[NSString stringWithFormat:@"%ld",kCurrentUser.userId],@"rechargemoney":rechargemoney,@"paytype":@1,@"rechargestatus":rechargestatus};
    [[FPNetwork POST:API_INSERTWALLETRECHARGE withParams:params] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            
            
        }
        else {
            [ProgressUtil showError:@"网络故障"];
        }
    }];

    
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}


@end
