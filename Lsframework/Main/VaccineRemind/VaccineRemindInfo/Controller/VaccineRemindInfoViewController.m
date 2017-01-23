//
//  VaccineRemindInfoViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccineRemindInfoViewController.h"
#import "VaccineInfoCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "VaccineRemindInfoPresenter.h"

@interface VaccineRemindInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *vacTableVew;
@property (nonatomic, strong) VaccineRemindInfoPresenter *presenter;

@end

@implementation VaccineRemindInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"疫苗详情";
    self.view.backgroundColor = [UIColor whiteColor];
    _presenter = [VaccineRemindInfoPresenter new];
    WS(ws);
    [_presenter GetVaccineDetailByID:_vaccineID complete:^(BOOL success) {
        [ws setupTableView];
    }];
    
}
- (void)setupTableView{
    _vacTableVew = [UITableView new];
    _vacTableVew.dataSource = self;
    _vacTableVew.delegate = self;
    _vacTableVew.tableHeaderView = [self headerView];
    _vacTableVew.tableFooterView = [self footerView];
    [_vacTableVew setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_vacTableVew];
    _vacTableVew.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_vac";
    VaccineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VaccineInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = _presenter.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VaccineDetail *model = _presenter.dataSource[indexPath.row];
    return [_vacTableVew cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[VaccineInfoCell class]  contentViewWidth:[self cellContentViewWith]];
}
- (UIView *)headerView{
    
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    header.frame = CGRectMake(0, 0, kScreenWidth, 70);
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, 30, kScreenWidth, 15);
    titleLabel.text = [NSString stringWithFormat:@"      %@",_presenter.titleText];
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:17];
    [header addSubview:titleLabel];
    
    UIView *sepView = [UIView new];
    sepView.backgroundColor = UIColorFromRGB(0xefefef);
    [header addSubview:sepView];
    sepView.sd_layout.leftSpaceToView(header,0).rightSpaceToView(header,0).bottomSpaceToView(header,0).heightIs(1);
    return header;
}
- (UIView *)footerView{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    footer.frame = CGRectMake(0, 0, kScreenWidth, 20);
    return footer;
}

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
