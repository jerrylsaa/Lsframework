//
//  FaceAppointMentViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/6/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FaceAppointMentViewController.h"
#import "FBRadioGroup.h"
#import "LCTextView.h"
#import "AppointSuccessViewController.h"
@interface FaceAppointMentViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIScrollView* _scroll;
    UIView* _containerView;
    
    UIView* _doctorInfobgView;
    UILabel* _doctorName;
    UILabel* _departName;
    UILabel* _doctorTitle;//医生级别
    
    UIView* _appointbgView;
    UIView* _sectionView;
    UITableView* _diseaseTimeTable;
    UILabel* _detailLabel;
    FBRadioGroup* _appointMode;//预约方法是
    
    UILabel* _remarkTitle;
//    UITextView* _remarkTextView;
    LCTextView* _remarkTextView;
    
    UILabel* _tipsTitle;
    UILabel* _tipsDetail;
    UIButton* _commitbt;
}

@property(nonatomic,retain) NSArray* diseaseTimeArray;
@property(nonatomic,retain) NSMutableDictionary* openDic;
@end

@implementation FaceAppointMentViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.openDic setObject:@0 forKey:@(0)];

    _doctorName.text = [NSString stringWithFormat:@"姓       名：%@",@""];
    _departName.text = [NSString stringWithFormat:@"科       室：%@",@""];
    _doctorTitle.text = [NSString stringWithFormat:@"医生级别：%@",@""];
    
    [_appointMode setTitles:@[@"去找医生",@"医生找你"]];
    _appointMode.selection = 0;
    
    _remarkTitle.text = @"备     注：";
}

#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"面诊预约";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _scroll = [UIScrollView new];
    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    _scroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _containerView = [UIView new];
    [_scroll addSubview:_containerView];
    _containerView.sd_layout.topSpaceToView(_scroll,0).leftSpaceToView(_scroll,0).rightSpaceToView(_scroll,0);
    
    [self setupDoctorInfoView];
    [self setupAppointTime];
    [self setupTableView];
    [self setupAppointMode];
    [self setupRemarkView];
    [self setupTispView];
    [self setupCommitButton];
    
    [_containerView setupAutoHeightWithBottomView:_commitbt bottomMargin:0];
    [_scroll setupAutoContentSizeWithBottomView:_containerView bottomMargin:20];
}
/**
 *  医生基本信息
 */
- (void)setupDoctorInfoView{
    _doctorInfobgView = [UIView new];
    [_containerView addSubview:_doctorInfobgView];
    
    _doctorName = [UILabel new];
    _doctorName.font = [UIFont systemFontOfSize:18];
    _doctorName.textColor = RGB(83, 83, 83);
    [_doctorInfobgView addSubview:_doctorName];
    _departName = [UILabel new];
    _departName.font = _doctorName.font;
    _departName.textColor = _doctorName.textColor;
    [_doctorInfobgView addSubview:_departName];
    _doctorTitle = [UILabel new];
    _doctorTitle.font = _doctorName.font;
    _doctorTitle.textColor = _doctorName.textColor;
    [_doctorInfobgView addSubview:_doctorTitle];

    _doctorName.sd_layout.topSpaceToView(_doctorInfobgView,20).autoHeightRatio(0).leftSpaceToView(_doctorInfobgView,20).rightSpaceToView(_doctorInfobgView,0);
    _departName.sd_layout.topSpaceToView(_doctorName,10).autoHeightRatio(0).leftEqualToView(_doctorName).rightEqualToView(_doctorName);
    _doctorTitle.sd_layout.topSpaceToView(_departName,10).autoHeightRatio(0).leftEqualToView(_doctorName).rightEqualToView(_doctorName);
    _doctorInfobgView.sd_layout.topSpaceToView(_containerView,0).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
    [_doctorInfobgView setupAutoHeightWithBottomView:_doctorTitle bottomMargin:10];
}
/**
 *  预约时间
 */
- (void)setupAppointTime{
    _appointbgView = [UIView new];
    _appointbgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_containerView addSubview:_appointbgView];
    
    _sectionView=[UIView new];
    _appointbgView.backgroundColor = UIColorFromRGB(0xffffff);
    [_appointbgView addSubview:_sectionView];
    //添加手势
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_sectionView addGestureRecognizer:tap];
    UILabel * titleLabel=[UILabel new];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor= RGB(83, 83, 83);
    titleLabel.text=@"预约时间：";
    [_sectionView addSubview:titleLabel];
    _detailLabel=[UILabel new];
    _detailLabel.font=titleLabel.font;
    _detailLabel.textColor=titleLabel.textColor;
    [_sectionView addSubview:_detailLabel];
    UIImageView * indactorImage=[UIImageView new];
    indactorImage.image=[UIImage imageNamed:@"trangtle"];
    indactorImage.userInteractionEnabled=YES;
    [_sectionView addSubview:indactorImage];
    
    //添加约束
    titleLabel.sd_layout.topSpaceToView(_sectionView,10).autoHeightRatio(0).leftSpaceToView(_sectionView,20);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _detailLabel.sd_layout.topEqualToView(titleLabel).autoHeightRatio(0).leftSpaceToView(titleLabel,10);
    [_detailLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    indactorImage.sd_layout.centerYEqualToView(titleLabel).heightIs(10).rightSpaceToView(_sectionView,20).widthIs(18);
    
    _sectionView.sd_layout.topSpaceToView(_appointbgView,0).leftSpaceToView(_appointbgView,0).rightSpaceToView(_appointbgView,0);
    [_sectionView setupAutoHeightWithBottomViewsArray:@[titleLabel,_detailLabel,indactorImage] bottomMargin:10];
    _appointbgView.sd_layout.topSpaceToView(_doctorInfobgView,0).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0);
}

/**
 *  tableView
 */
- (void)setupTableView{
    UIView* separatorLine = [UIView new];
    separatorLine.backgroundColor = RGB(231, 231, 231);
    [_appointbgView addSubview:separatorLine];
    
    _diseaseTimeTable = [UITableView new];
    _diseaseTimeTable.dataSource = self;
    _diseaseTimeTable.delegate = self;
    _diseaseTimeTable.separatorColor = RGB(231, 231, 231);
    _diseaseTimeTable.scrollEnabled = NO;
    _diseaseTimeTable.backgroundColor = [UIColor clearColor];
    [_diseaseTimeTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_appointbgView addSubview:_diseaseTimeTable];

    separatorLine.sd_layout.topSpaceToView(_sectionView,0).heightIs(1).leftSpaceToView(_appointbgView,0).rightSpaceToView(_appointbgView,0);
    _diseaseTimeTable.sd_layout.topSpaceToView(separatorLine,0).heightIs(0).leftSpaceToView(_appointbgView,0).rightSpaceToView(_appointbgView,0);
}
/**
 *  预约方式
 */
- (void)setupAppointMode{
    _appointMode = [FBRadioGroup new];
    _appointMode.type = FBRadioGroupTypeHorizontal;
    [_appointbgView addSubview:_appointMode];
    
    _appointMode.sd_layout.topSpaceToView(_diseaseTimeTable,10).heightIs(30).leftSpaceToView(_appointbgView,60).widthIs(250);
    
}

/**
 *  备注
 */
- (void)setupRemarkView{
    UIView* separatorLine = [UIView new];
    separatorLine.backgroundColor = RGB(231, 231, 231);
    [_appointbgView addSubview:separatorLine];

    _remarkTitle = [UILabel new];
    _remarkTitle.font = _doctorName.font;
    _remarkTitle.textColor = _doctorName.textColor;
    [_appointbgView addSubview:_remarkTitle];
    
    _remarkTextView = [LCTextView new];
    _remarkTextView.textColor = _doctorName.textColor;
    _remarkTextView.placeholder = @"请填写您与医生沟通面诊的地址以便您方便查询";
    _remarkTextView.placeholderColor = RGB(117, 117, 117);
    [_appointbgView addSubview:_remarkTextView];
    
    separatorLine.sd_layout.topSpaceToView(_appointMode,0).heightIs(1).leftSpaceToView(_appointbgView,0).rightSpaceToView(_appointbgView,0);

    
    _remarkTitle.sd_layout.topSpaceToView(separatorLine,10).autoHeightRatio(0).leftSpaceToView(_appointbgView,20);
    [_remarkTitle setSingleLineAutoResizeWithMaxWidth:150];
    _remarkTextView.sd_layout.topSpaceToView(separatorLine,0).heightIs(80).leftSpaceToView(_remarkTitle,0).rightSpaceToView(_appointbgView,0);
    
    [_appointbgView setupAutoHeightWithBottomView:_remarkTextView bottomMargin:10];
    
}


- (void)setupTispView{
    _tipsTitle = [UILabel new];
    _tipsTitle.font = [UIFont systemFontOfSize:12];
    _tipsTitle.textColor = RGB(190, 48, 51);
    _tipsTitle.text = @"* 温馨提示";
    [_containerView addSubview:_tipsTitle];
    
    _tipsDetail = [UILabel new];
    _tipsDetail.font = _tipsTitle.font;
    _tipsDetail.textColor = _tipsTitle.textColor;
    _tipsDetail.text = @"请您务必在发起预约前与医生沟通好时间及地点";
    [_containerView addSubview:_tipsDetail];

    _tipsTitle.sd_layout.topSpaceToView(_appointbgView,40).autoHeightRatio(0).leftSpaceToView(_containerView,20).rightSpaceToView(_containerView,0);
    _tipsDetail.sd_layout.topSpaceToView(_tipsTitle,5).autoHeightRatio(0).leftSpaceToView(_containerView,25).rightSpaceToView(_containerView,20);
}

- (void)setupCommitButton{
    _commitbt = [UIButton new];
    [_commitbt setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
    [_commitbt setTitle:@"提交" forState:UIControlStateNormal];
    [_commitbt addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_commitbt];

    _commitbt.sd_layout.topSpaceToView(_tipsDetail,40).heightIs(40).leftSpaceToView(_containerView,20).rightSpaceToView(_containerView,20);
    
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
    return self.diseaseTimeArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.diseaseTimeArray[indexPath.row];
    cell.backgroundColor = UIColorFromRGB(0xf2f2f2);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = RGB(83, 83, 83);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self setTableViewHeight];
    [self.openDic setObject:@0 forKey:@0];

    _detailLabel.text = _diseaseTimeArray[indexPath.row];

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}


#pragma mark - 手势回调
- (void)handleTapGesture:(UITapGestureRecognizer*) tap{
    
    [self setTableViewHeight];
    if([self.openDic[@0] intValue]){
        [self.openDic setObject:@0 forKey:@0];
    }else{
        [self.openDic setObject:@1 forKey:@0];
    }
    
//    [_diseaseTimeTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 点击事件
- (void)commitAction{
    [self.navigationController pushViewController:[AppointSuccessViewController new] animated:YES];
}


#pragma mark - 懒加载

-(NSMutableDictionary *)openDic{
    if(!_openDic){
        _openDic=[NSMutableDictionary dictionary];
    }
    return _openDic;
}

-(NSArray *)diseaseTimeArray{
    if(!_diseaseTimeArray){
        _diseaseTimeArray = @[@"刚刚", @"一周内", @"一个月内", @"半年内", @"大于半年"];
    }
    return _diseaseTimeArray;
}

#pragma mark - 私有方法

- (void)setTableViewHeight{
    CGFloat height = 44 * self.diseaseTimeArray.count;
   
    if([self.openDic[@0] intValue]){
        height = 0;
    }
//    [UIView animateWithDuration:.2f animations:^{
//        _diseaseTimeTable.sd_layout.heightIs(height);
//        _appointMode.sd_layout.topSpaceToView(_diseaseTimeTable,10);
//    }];
    _diseaseTimeTable.sd_layout.heightIs(height);
    _appointMode.sd_layout.topSpaceToView(_diseaseTimeTable,10);

    [_diseaseTimeTable updateLayout];
    [_appointbgView updateLayout];
    [_containerView updateLayout];
    
    [_diseaseTimeTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

}







@end
