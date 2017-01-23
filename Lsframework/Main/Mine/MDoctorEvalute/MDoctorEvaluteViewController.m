//
//  DoctorEvaluationViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MDoctorEvaluteViewController.h"

#import "DoctorEvaluationViewControllerCell.h"
#import "ACDoctorDetailViewController.h"
#import "BSEvaluateViewController.h"
#import "MDoctorEvalutePresenter.h"
#import "DoctorList.h"
#import "MyDoctorEvaluation.h"

@interface MDoctorEvaluteViewController ()<UITabBarDelegate, UITableViewDataSource, MDoctorEvaluteDelegate>
{
//    MDoctorEvalutePresenter *_presenter;
    NSArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong) MDoctorEvalutePresenter *presenter;


@end

@implementation MDoctorEvaluteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    
}

- (void)setupView {
    
    self.presenter = [[MDoctorEvalutePresenter alloc] init];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter request];
    self.title = @"医生评价";
    
    _listTab.rowHeight = 242;
    [_listTab registerNib:[UINib nibWithNibName:@"DoctorEvaluationViewControllerCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _listTab.separatorStyle = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DoctorEvaluationViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.typeStr = @"0";
    [cell.headButton addTarget:self action:@selector(touchHead:) forControlEvents:UIControlEventTouchUpInside];
//    
     MyDoctorEvaluation *model = _dataArray[indexPath.row];
    cell.headButton.tag = model.doctorID ;
//
    cell.immediateEvaluationBtn.tag = indexPath.row;
    [cell.immediateEvaluationBtn addTarget:self action:@selector(touchEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.model = model;
    
    return cell;
    
}

-(void)touchEvaluation:(UIButton *)btn
{
    NSLog(@"%ld", btn.tag);
    BSEvaluateViewController *vc = [[BSEvaluateViewController alloc] init];
//    vc.doctorId = btn.tag;
//
    vc.model = _dataArray[btn.tag];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchHead:(UIButton *)btn {
    
    ACDoctorDetailViewController *vc = [[ACDoctorDetailViewController alloc] init];
    
    vc.doctorId = [NSNumber numberWithInteger:btn.tag];
    NSLog(@"%ld", (long)btn.tag);
    [self.navigationController pushViewController:vc animated:YES];
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//     BSEvaluateViewController *vc = [[BSEvaluateViewController alloc] init];
////   vc.doctorId = (MyDoctorEvaluation *)_presenter
//    [self.navigationController pushViewController:vc animated:YES];
//}



- (void)sendData:(NSArray *)dataArray {
    
    [ProgressUtil dismiss];
    
    _dataArray = dataArray;
    
//    NSLog(@"%@", _dataArray);
    
    [_listTab reloadData];
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
