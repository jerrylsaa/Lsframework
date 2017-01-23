//
//  CheckHospitalViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CheckHospitalViewController.h"
#import "CooperationHospitalListViewCell.h"
#import "HospitalListPresenter.h"
#import "HospitalList.h"

@interface CheckHospitalViewController ()<UITableViewDataSource, UITableViewDelegate, hospitalNameDelegate>

{
    NSArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) HospitalListPresenter *presenter;

@end

@implementation CheckHospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupView {
    
    self.presenter = [[HospitalListPresenter alloc] init];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter request];
    
    self.title = @"检查医院";
    
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
    cell.hospitalName.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HospitalList *model = _dataArray[indexPath.row];
    _sendName(model.hName, model.keyID);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendData:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [ProgressUtil dismiss];
    [_listTableView reloadData];
    
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
