//
//  BehaviourContentViewController.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BehaviourViewController.h"
//#import "BehaviourContentViewController.h"
#import "BehaviourDetailsViewController.h"
#import "BehaviourTableViewCell.h"
#import "MDoctorGudiePresenter.h"

//#import "BehaviourContentPresenter.h"

@interface BehaviourViewController ()<UITableViewDelegate, UITableViewDataSource,MDoctorBehaviourDelegate>
{
 
    NSMutableArray *_dataArray;
}
@property(nonatomic, strong)UITableView *table;
@property(nonatomic, strong)MDoctorGudiePresenter *presenter;


@end

@implementation BehaviourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    
    }

-(void)setupView
{
    self.title = @"行为及营养指导";
    self.view.backgroundColor =  UIColorFromRGB(0xf2f2f2);
    [self setupTabView];
    
    self.presenter = [[MDoctorGudiePresenter alloc] init];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter request];
}
-(void)setupTabView
{
    _table=[UITableView new];
    _table.backgroundColor=[UIColor clearColor];
    _table.dataSource=self;
    _table.delegate=self;
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_doctor";
    BehaviourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BehaviourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 38;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
//    view.backgroundColor = UIColorFromRGB(0Xefefef);
//    UILabel *doctorLabel = [UILabel new];
//    doctorLabel.text = [timeArray objectAtIndex:section];
//    doctorLabel.textColor = UIColorFromRGB(0x71d4ce);
//    doctorLabel.backgroundColor = [UIColor clearColor];
//    [view addSubview:doctorLabel];
//    doctorLabel.sd_layout.leftSpaceToView(view,20).rightSpaceToView(view,20).topSpaceToView(view,10).bottomSpaceToView(view,10);
//    
//    UIView *sep_2 = [UIView new];
//    sep_2.backgroundColor = UIColorFromRGB(0x71d4ce);
//    [view addSubview:sep_2];
//    sep_2.sd_layout.leftSpaceToView(view,0).rightSpaceToView(view,0).bottomSpaceToView(view,0).heightIs(1);
//    return view;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BehaviourDetailsViewController *vc = [[BehaviourDetailsViewController alloc] init];
//     vc.doctorId = ((BehaviourGuide *)_presenter.dataSource[indexPath.row]).doctorName;
    vc.model = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendData:(NSArray *)dataArray {
    
    [ProgressUtil dismiss];
    
    _dataArray = dataArray;

    NSLog(@"%@", dataArray);
    
    [_table reloadData];
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
