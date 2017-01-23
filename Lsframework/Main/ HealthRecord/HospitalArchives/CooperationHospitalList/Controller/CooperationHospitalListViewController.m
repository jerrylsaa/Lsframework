//
//  CooperationHospitalListViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CooperationHospitalListViewController.h"
#import "CooperationHospitalListViewCell.h"
#import "HospitalListPresenter.h"

@interface CooperationHospitalListViewController ()<UITableViewDataSource, UITableViewDelegate, hospitalNameDelegate>

{
    NSArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) HospitalListPresenter *presenter;

@end

@implementation CooperationHospitalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupView {
    
    self.presenter = [[HospitalListPresenter alloc] init];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter request];
    
    self.title = @"合作医院列表";
    
    _listTableView.rowHeight = 50.5;
    [_listTableView registerNib:[UINib nibWithNibName:@"CooperationHospitalListViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _listTableView.separatorStyle = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CooperationHospitalListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
    
}

- (void)sendData:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [_listTableView reloadData];
    
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
