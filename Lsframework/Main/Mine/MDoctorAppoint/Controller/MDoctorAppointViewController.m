//
//  MDoctorAppointViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorAppointViewController.h"
#import "RightViewTextField.h"
#import "MAPhoneOutPatientCell.h"
#import "MAFaceConsultationCell.h"
#import "MAStopCarCell.h"
#import "MAMedicalAssitant.h"
#import "MDoctorAppointPresenter.h"
#import <UITableView+SDAutoTableViewCellHeight.h>


@interface MDoctorAppointViewController ()<UITableViewDelegate,UITableViewDataSource,MDoctorAppointPresenterDelegate>{
    UITableView* _table;
    RightViewTextField* _tf;
}

@property(nonatomic,retain) NSMutableArray* dataSource;
@property(nonatomic,retain) MDoctorAppointPresenter* presenter;
@end

@implementation MDoctorAppointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self initRightBarWithTitle:@"医助"];
    
    self.presenter = [MDoctorAppointPresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter getAppointDoctorData];
    
}
#pragma mark - 加载子视图
-(void)setupView{
    self.title = @"我的预约";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
//    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorColor = RGB(85, 176, 215);
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_table registerClass:[MAPhoneOutPatientCell class] forCellReuseIdentifier:@"cell"];
//    [self setupTableHeaderView];
//    [self setupTableFooterView];
    
    
    //下来刷新
    WS(ws);
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter refreshAppointDoctorData];
    }];
    
    //上拉加载更多
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter loadMoreAppointDoctorData];
    }];
    
}

- (void)setupTableHeaderView{
    UIView* headerView = [UIView new];
    headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);

    _tf = [RightViewTextField new];
    _tf.background = [UIImage imageNamed:@"select_searchBar"];
    _tf.font = [UIFont systemFontOfSize:16];
    _tf.placeholder = @"请输入查询的预约";
    [headerView addSubview:_tf];

    UIView* rightView = [UIView new];
    _tf.rightView = rightView;
    _tf.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView* rightImageView = [UIImageView new];
    rightImageView.userInteractionEnabled = YES;
    rightImageView.image = [UIImage imageNamed: @"select_search"];
    [rightView addSubview:rightImageView];
    
    UIButton* rightButton = [UIButton new];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorFromRGB(0x868686) forState:UIControlStateNormal];
    [rightView addSubview:rightButton];
    
    UIView *line = [UIView new];
    line.backgroundColor = RGB(85, 176, 215);
    [headerView addSubview:line];

    _tf.sd_layout.leftSpaceToView(headerView,10).rightSpaceToView(headerView,10).topSpaceToView(headerView,10).heightIs(40);
    _tf.sd_cornerRadiusFromHeightRatio = @0.5;

    rightView.frame = CGRectMake(0,0,100,_tf.height);
    rightImageView.sd_layout.topSpaceToView(rightView,10).bottomSpaceToView(rightView,10).leftSpaceToView(rightView,10).widthEqualToHeight();
    rightButton.sd_layout.leftSpaceToView(rightImageView,15).rightSpaceToView(rightView,20).topEqualToView(rightImageView).bottomEqualToView(rightImageView);

    line.sd_layout.leftEqualToView(headerView).rightEqualToView(headerView).topSpaceToView(_tf,10).heightIs(1);
    
    [headerView setupAutoHeightWithBottomView:line bottomMargin:0];
    [headerView layoutSubviews];
    
    _table.tableHeaderView = headerView;

}

- (void)setupTableFooterView{
    UIView* footerView = [UIView new];
    footerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UILabel* tips = [UILabel new];
    tips.textColor = RGB(246, 64, 66);
    tips.numberOfLines = 0;
    tips.text = @"*温馨提示：修改或取消您的预约，请按本页右上角医助按钮，我们将尽量满足您的需求";
    tips.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:tips];
    
    tips.sd_layout.topSpaceToView(footerView,0).leftSpaceToView(footerView,20).rightSpaceToView(footerView,20).heightIs(50);
    
    [footerView setupAutoHeightWithBottomView:tips bottomMargin:5];
    [footerView layoutSubviews];
    _table.tableFooterView = footerView;
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
    MAPhoneOutPatientCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.doctor = self.presenter.dataSource[indexPath.row];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = _table;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_table deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppointDoctor* doctor = self.presenter.dataSource[indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:doctor keyPath:@"doctor" cellClass:[MAPhoneOutPatientCell class] contentViewWidth:[self cellContentViewWith]];
}
-(void)onCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        [ProgressUtil dismiss];
        
        if(self.presenter.dataSource.count == 0){
        
            _table.tableHeaderView = nil;
            _table.tableFooterView = nil;
            return;
        }
        [_table reloadData];
    }else{
        [ProgressUtil showError:message];
    }
}

- (void)refreshOnCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        [_table.mj_footer resetNoMoreData];
        [_table.mj_header endRefreshing];
        
        if(self.presenter.dataSource.count == 0){
            
            _table.tableHeaderView = nil;
            _table.tableFooterView = nil;
            return;
        }
        [_table reloadData];
    }else{
        [ProgressUtil showError:message];
    }

}

-(void)loadMoreOnCompletion:(BOOL)succes info:(NSString *)message{
    if(succes){
        if(self.presenter.noMoreData){
            
            [_table.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_table.mj_footer endRefreshing];
        }
        
        
        [_table reloadData];
    }else{
        [_table.mj_footer endRefreshing];
        [ProgressUtil showError:message];
    }
}


#pragma mark - 点击事件
//- (void)rightItemAction:(id)sender{
//    NSLog(@"医助--拨打电话");
//}

#pragma mark -

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
