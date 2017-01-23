//
//  ExpertDPViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ExpertDPViewController.h"
#import "ExpertDPCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "HEAInfoPresenter.h"
@interface ExpertDPViewController ()<UITableViewDataSource,UITableViewDelegate,HEAInfoPresenterDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) HEAInfoPresenter *presenter;
@end

@implementation ExpertDPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"医生点评";
    // Do any additional setup after loading the view.
    [ProgressUtil show];
    [_presenter getExpertCommentListByExpertID:_expertEntity.doctorID];
}

-(void)setupView{
    _presenter =[HEAInfoPresenter new];
    _presenter.delegate =self;
    
    _table = [UITableView new];
    _table.tag =1001;
    _table.backgroundColor =[UIColor whiteColor];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_table registerClass:[ExpertDPCell class] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _presenter.myCommentListDataSource.count?_presenter.myCommentListDataSource.count:0;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpertDPCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.cellEntity =_presenter.myCommentListDataSource[indexPath.row];
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSLog(@"点击单元格");
//
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [tableView cellHeightForIndexPath:indexPath model:_presenter.myCommentListDataSource[indexPath.row] keyPath:@"cellEntity" cellClass:[ExpertDPCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (CGFloat)cellContentViewWith{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)getExpertCommentListSuccess{
    [_table reloadData];
    [ProgressUtil dismiss];
    
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
