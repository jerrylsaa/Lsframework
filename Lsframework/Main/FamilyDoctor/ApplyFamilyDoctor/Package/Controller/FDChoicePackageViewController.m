//
//  FDChoicePackageViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDChoicePackageViewController.h"
#import "FDChoicePackagePresenter.h"

@interface FDChoicePackageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *packageTableView;
@property (nonatomic ,strong)FDChoicePackagePresenter *presenter;
@property (nonatomic ,strong)NSMutableDictionary *sectionState;
@property (nonatomic ,strong)NSMutableDictionary *foldState;

@end

@implementation FDChoicePackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"家庭医生套餐";
    _presenter = [FDChoicePackagePresenter new];
    _sectionState = [NSMutableDictionary dictionary];
    _foldState = [NSMutableDictionary dictionary];
    //初始化
    for (int i = 0; i < 5; i ++) {
        [_sectionState setObject:@0 forKey:@(i)];
        [_foldState setObject:@0 forKey:@(i)];
    }
    [self setupTableView];
    [self loadData];
}

- (void)setupTableView{
    _packageTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _packageTableView.dataSource = self;
    _packageTableView.delegate = self;
    _packageTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_packageTableView];
    _packageTableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}

- (void)loadData{
    WS(ws);
    //传递过来的医生ID
    [_presenter loadPackageByDoctorId:@7 with:^(BOOL success, NSArray *entityArray) {
        if (success) {
            [ws.packageTableView reloadData];
        }
    }];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _presenter.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[_foldState objectForKey:[NSNumber numberWithInteger:section]] boolValue] == YES) {
        Package *packageEntity = (Package *)_presenter.dataSource[section];
        return ((NSArray *)packageEntity.packageInfo).count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_package";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    Package *packageEntity = (Package *)_presenter.dataSource[indexPath.section];
    NSDictionary *dic = ((NSArray *)packageEntity.packageInfo)[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"PackageInfo"];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [UIView new];
    sectionView.size = CGSizeMake(kScreenWidth, 50);
    sectionView.backgroundColor = [UIColor whiteColor];
    //选中状态
    UIButton *selectButton = [UIButton new];
    [selectButton setImageEdgeInsets:UIEdgeInsetsMake(15, 20, 15, 20)];
    selectButton.tag = section;
    if ([[self.sectionState objectForKey:[NSNumber numberWithInteger:section]] boolValue] == YES) {
        [selectButton setImage:[UIImage imageNamed:@"remeberpsw_sel"] forState:UIControlStateNormal];
    }else{
        [selectButton setImage:[UIImage imageNamed:@"remeberpsw_nor"] forState:UIControlStateNormal];
    }
    [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:selectButton];
    selectButton.sd_layout.leftSpaceToView(sectionView,0).topSpaceToView(sectionView,0).widthIs(60).heightIs(50);
    //套餐标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = ((Package *)_presenter.dataSource[section]).packageName;
    [sectionView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(selectButton,0).topSpaceToView(sectionView,15).rightSpaceToView(sectionView,50).heightIs(20);
    //右侧下拉箭头
    UIButton *downButton = [UIButton new];
    [downButton setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 25)];
    [downButton setImage:[UIImage imageNamed:@"ac_down"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(downAction:) forControlEvents:UIControlEventTouchUpInside];
    downButton.tag = 100 + section;
    [sectionView addSubview:downButton];
    downButton.sd_layout.topSpaceToView(sectionView,0).rightSpaceToView(sectionView,0).widthIs(70).heightIs(50);
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_presenter.dataSource.count > 0) {
        if (section == _presenter.dataSource.count - 1) {
            UIView *commitView = [UIView new];
            commitView.backgroundColor = [UIColor whiteColor];
            commitView.size = CGSizeMake(kScreenWidth, 100);
            //commitButton
            UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [commitButton setTitle:@"确认选择套餐" forState:UIControlStateNormal];
            [commitButton setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
            [commitButton addTarget:self action:@selector(FDCommitAction) forControlEvents:UIControlEventTouchUpInside];
            [commitView addSubview:commitButton];
            commitButton.sd_layout.leftSpaceToView(commitView,10).rightSpaceToView(commitView,10).topSpaceToView(commitView,50).heightIs(40);
            return commitView;
        }
        return nil;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _presenter.dataSource.count - 1) {
        return 100;
    }
    return 1;
}
//Action
- (void)selectAction:(UIButton *)button{
    NSNumber *state = [_sectionState objectForKey:[NSNumber numberWithInteger:button.tag]];
    state = [NSNumber numberWithBool:![state boolValue]];
    [_sectionState setObject:state forKey:[NSNumber numberWithInteger:button.tag]];
    if ([state boolValue] == YES) {
        [button setImage:[UIImage imageNamed:@"remeberpsw_sel"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"remeberpsw_nor"] forState:UIControlStateNormal];
    }
}
- (void)downAction:(UIButton *)button{
    NSNumber *state = [_foldState objectForKey:[NSNumber numberWithInteger:button.tag - 100]];
    state = [NSNumber numberWithBool:![state boolValue]];
    [_foldState setObject:state forKey:[NSNumber numberWithInteger:button.tag - 100]];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:button.tag - 100];
    [_packageTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)FDCommitAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
