//
//  TreatMentViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "TreatMentViewController.h"
#import "TreatMentRecordCell.h"
#import "TreatMentRecordPresenter.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
@interface TreatMentViewController ()<UITableViewDelegate,UITableViewDataSource,TreatMentRecordPresenterDelegate>{
    UITableView* _table;
}

@property(nonatomic,retain) TreatMentRecordPresenter* presenter;

@property(nonatomic,retain) NSArray<FDAppointManagerEntity* >* dataSource;

@end

@implementation TreatMentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.presenter = [TreatMentRecordPresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter getTreatMentRecord];
}

- (void)setupView{
    self.title = @"已面诊记录";
    
    [self setupTableView];
    [self setupTableHeaderView];
    
}

#pragma mark - 加载子视图

- (void)setupTableView{
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    
    [self.view addSubview:_table];
    
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_table registerClass:[TreatMentRecordCell class] forCellReuseIdentifier:@"treatCell"];
}

- (void)setupTableHeaderView{
    UIView* headerView = [UIView new];
    headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UILabel* title = [UILabel new];
    title.textColor = UIColorFromRGB(0x888888);
    title.font = [UIFont systemFontOfSize:18];
    title.text = @"今天";
    [headerView addSubview:title];
    
    title.sd_layout.topSpaceToView(headerView,10).leftSpaceToView(headerView,10).widthIs(150).autoHeightRatio(0);
    [headerView setupAutoHeightWithBottomView:title bottomMargin:10];
    
    [headerView layoutSubviews];
    _table.tableHeaderView = headerView;
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
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TreatMentRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:@"treatCell"];
    cell.record = self.dataSource[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 170/2.0;
    
    FDAppointManagerEntity* record = self.dataSource[indexPath.row];
    
    return [tableView cellHeightForIndexPath:indexPath model:record keyPath:@"record" cellClass:[TreatMentRecordCell class] contentViewWidth:[self contentHight]];
    
}

-(void)onCompletion:(BOOL)success info:(NSString *)message{

    if(success){
        [ProgressUtil dismiss];
        
        self.dataSource = self.presenter.dataSource;
        [_table reloadData];
        
    }else{
        [ProgressUtil showError:message];
    }
    
}

#pragma mark - 

- (CGFloat)contentHight{
    CGFloat width = kScreenWidth;
    
    if([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}







@end
