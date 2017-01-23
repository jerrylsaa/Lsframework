//
//  OrderSubmitViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "OrderSubmitViewController.h"
#import "OrderCommitCell.h"
#import "ACSuccessPageViewController.h"

@interface OrderSubmitViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* _table;
}

@property(nonatomic,retain) NSArray* sectionTitle;

@property(nonatomic,retain) NSMutableArray* datasourceArray;

@property(nonatomic,retain) NSMutableDictionary* openDic;

@end

@implementation OrderSubmitViewController

-(NSMutableArray *)datasourceArray{
    if(!_datasourceArray){
        _datasourceArray=[NSMutableArray array];
    }
    return _datasourceArray;
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
}

-(void)setupView{
    self.title=@"订单提交";
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    
    self.sectionTitle=@[@"订 单 号:",@"咨询大夫:",@"咨询方式:",@"资费标准:",@"优 惠 券:",@"支付方式:",@"应付金额:"];
    for(int i=0;i<self.sectionTitle.count;++i){
        [self.openDic setObject:@0 forKey:@(i)];
        if(i==self.sectionTitle.count-3){
        //优惠券
            NSArray* discount=@[@"优惠券1",@"优惠券2",@"优惠券3",@"优惠券4"];
            [self.datasourceArray addObject:discount];
        }else if(i==self.sectionTitle.count-2){
        //支付
            NSArray* pay=@[@"支付宝",@"微信支付",@"银行卡"];
            [self.datasourceArray addObject:pay];
        }else{
            if(i != self.sectionTitle.count-2 && i != self.sectionTitle.count-3){
                NSArray* array=[NSArray array];
                [self.datasourceArray addObject:array];
            }
        }
    }
    
    
    _table=[[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _table.dataSource=self;
    _table.delegate=self;
    _table.rowHeight=50;
    _table.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_table];
    
    UIView* bgView=[[UIView alloc ] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    bgView.backgroundColor=[UIColor whiteColor];
    _table.tableFooterView=bgView;
    
    //提交按钮
    UIButton* commit=[UIButton new];
    [commit setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [commit setTitle:@"确认支付" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:commit];
    commit.sd_layout.spaceToSuperView(UIEdgeInsetsMake(80, 25, 10, 25));
    
    }

#pragma mark - 代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasourceArray.count;
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
    NSArray* array=self.datasourceArray[section];
    if([self.openDic[@(section)] intValue]){
        return array.count;
    }else{
        return 0;
     }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identy=@"cell";
    OrderCommitCell* cell=[tableView dequeueReusableCellWithIdentifier:identy];
    if(!cell){
        cell=[[OrderCommitCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identy];
    }
    NSArray* array=self.datasourceArray[indexPath.section];
    NSString* title=array[indexPath.row];
//    cell.titleLabel.text=title;
    [cell.title setTitle:title forState:UIControlStateNormal];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
    sectionView.tag=100+section;
    
    UILabel * titleLabel=[UILabel new];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor=UIColorFromRGB(0x666666);
    titleLabel.text=sectionTitle;
    [sectionView addSubview:titleLabel];
    
    UILabel * detailLabel=[UILabel new];
    detailLabel.font=titleLabel.font;
    detailLabel.textColor=titleLabel.textColor;
    detailLabel.text=@"订单*****";
    [sectionView addSubview:detailLabel];
    
    UIImageView * indactorImage=[UIImageView new];
    indactorImage.image=[UIImage imageNamed:@"trangtle"];
    indactorImage.userInteractionEnabled=YES;
    [sectionView addSubview:indactorImage];
    
    UIView* line=[UIView new];
    line.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.3];
    [sectionView addSubview:line];
    
    
    titleLabel.sd_layout.topSpaceToView(sectionView,15).bottomSpaceToView(sectionView,15).leftSpaceToView(sectionView,20).maxWidthIs(150);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    detailLabel.sd_layout.topEqualToView(titleLabel).bottomEqualToView(titleLabel).leftSpaceToView(titleLabel,10).maxWidthIs(300);
    [detailLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    indactorImage.sd_layout.centerYEqualToView(titleLabel).heightIs(10).rightSpaceToView(sectionView,20).widthIs(18);
    
    line.sd_layout.bottomSpaceToView(sectionView,50).heightIs(1).leftSpaceToView(sectionView,0).rightSpaceToView(sectionView,0);

    
    if(section!=self.sectionTitle.count-2 && section!=self.sectionTitle.count-3){
        indactorImage.hidden=YES;
    }else{
        indactorImage.hidden=NO;
    }
    
    //添加手势
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [sectionView addGestureRecognizer:tap];
    
    return sectionView;
}

#pragma mark - 手势

- (void)handleTapGesture:(UITapGestureRecognizer*) tap{
    NSInteger index=tap.view.tag-100;
    if(index!=self.sectionTitle.count-2 && index!=self.sectionTitle.count-3) return ;
    
    if([self.openDic[@(self.sectionTitle.count-2)] intValue]){
        [self.openDic setObject:@0 forKey:@(self.sectionTitle.count-2)];
        [_table reloadSections:[NSIndexSet indexSetWithIndex:self.sectionTitle.count-2] withRowAnimation:UITableViewRowAnimationAutomatic];
        return ;
    }
    
    if([self.openDic[@(self.sectionTitle.count-3)] intValue]){
        [self.openDic setObject:@0 forKey:@(self.sectionTitle.count-3)];
        [_table reloadSections:[NSIndexSet indexSetWithIndex:self.sectionTitle.count-3] withRowAnimation:UITableViewRowAnimationAutomatic];
        return ;
    }
    
    
    if(index==self.sectionTitle.count-2){
        [self.openDic setObject:@1 forKey:@(index)];
    }else if(index==self.sectionTitle.count-3){
        [self.openDic setObject:@1 forKey:@(index)];
    }
    
    [_table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 点击事件

- (void)commitAction{
    [self.navigationController pushViewController:[ACSuccessPageViewController new] animated:YES];
}






@end
