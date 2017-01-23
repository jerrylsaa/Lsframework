//
//  MyBindDoctorViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyBindDoctorViewController.h"
#import "MyBindDoctorCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MyBindDoctorPresenter.h"
#import "HEAInfoViewController.h"
#import "ExpertAnswerEntity.h"

@interface MyBindDoctorViewController ()<MyBindDoctorCellDelegate,UITableViewDelegate, UITableViewDataSource,MyBindDoctorPresenterDelegate>
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) MyBindDoctorPresenter *presenter;

@end

@implementation MyBindDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =UIColorFromRGB(0xf2f2f2);
    self.title =@"我的医生";
    [_presenter getBindExpertList];
}

- (void)setupView{
    _presenter =[MyBindDoctorPresenter new];
    _presenter.delegate =self;
    
    _table = [UITableView new];
    _table.tag =1001;
    _table.backgroundColor =UIColorFromRGB(0xf2f2f2);
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    [_table registerClass:[MyBindDoctorCell class] forCellReuseIdentifier:@"cell"];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.presenter.doctorDataSource.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MyBindDoctorCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.cellEntity =[self.presenter.doctorDataSource objectAtIndex:indexPath.row];;
    
    if (!cell.delegate) {
        cell.delegate =self;
    }
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HEAInfoViewController *vc = [HEAInfoViewController new];
    
    MyBindDoctorEntity *bindDoctorEntity = [self.presenter.doctorDataSource objectAtIndex:indexPath.row];
    
    
    ExpertAnswerEntity *expert = [MyBindDoctorEntity convertMybindDoctorToExperAnswerEntity:bindDoctorEntity];
    
    vc.expertEntity = expert;
   
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_table cellHeightForIndexPath:indexPath model:[self.presenter.doctorDataSource objectAtIndex:indexPath.row] keyPath:@"cellEntity" cellClass:[MyBindDoctorCell class] contentViewWidth:[self cellContentViewWith]];
    
    
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

- (void)getBindExpertListSuccess{
    [_table reloadData];
}

- (void)cancelBindAction:(MyBindDoctorEntity *)cellEntity{
    [_presenter cancelBindExpertByExpertID:cellEntity.ID];
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
