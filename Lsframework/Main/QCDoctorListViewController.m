//
//  QCDoctorListViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "QCDoctorListViewController.h"
#import "QCDoctorListTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "ACDoctorDetailViewController.h"
#import "QCDoctorPresenter.h"

@interface QCDoctorListViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,QCDoctorListPresenterDelegate>{
    UITableView* _table;
}

@property(nonatomic,retain) QCDoctorPresenter* presenter;

@end

@implementation QCDoctorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBackBarWithImage:nil];
    [self initLeftBarWithTitle:@"取消咨询"];
    
    [self loadData];
}

-(void)setupView{
    self.title=@"医生列表";
    self.view.backgroundColor=UIColorFromRGB(0xf2f2f2);
    
    self.presenter = [QCDoctorPresenter new];
    self.presenter.delegate = self;
    
    [self setupTableView];
    [self setupTableHedaerView];
}

#pragma mark - 加载数据
- (void)loadData{
    [ProgressUtil show];
    [self.presenter requestData];
}

#pragma mark - 加载视图
- (void)setupTableView{
    _table=[UITableView new];
    _table.dataSource=self;
    _table.delegate=self;
    _table.backgroundColor=[UIColor clearColor];
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    WS(ws);
    _table.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter refreshData];
    }];
    
    _table.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter loadMoreData];
    }];
    
    
}

- (void)setupTableHedaerView{
    UIView* bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
    bgView.backgroundColor=UIColorFromRGB(0xf2f2f2);
    _table.tableHeaderView=bgView;
    
    UILabel* title=[UILabel new];
    title.text=@"医生";
    title.textColor=UIColorFromRGB(0x85d5f1);
    title.font=[UIFont systemFontOfSize:20];
    [bgView addSubview:title];
    title.sd_layout.topSpaceToView(bgView,10).bottomSpaceToView(bgView,10).leftSpaceToView(bgView,20).widthIs(100);
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
    static NSString* identy=@"cell";
    
    QCDoctorListTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[QCDoctorListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
    }

    DoctorList* doctor = self.presenter.dataSource[indexPath.row];
    cell.doctor=doctor;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ACDoctorDetailViewController* vc = [ACDoctorDetailViewController new];
    DoctorList* doctor = self.presenter.dataSource[indexPath.row];
    vc.doctorId = doctor.DoctorID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    DoctorList* doctor=self.presenter.dataSource[indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:doctor keyPath:@"doctor" cellClass:[QCDoctorListTableViewCell class] contentViewWidth:[self cellContentViewWith]];

//    return 180;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickQCDoctorListOnCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        
        [_table reloadData];
        
    }else{
        [ProgressUtil showError:info];
    }
}

-(void)refreshDataOnCompletion:(BOOL)success info:(NSString *)info{
    [_table.mj_footer resetNoMoreData];
    if(success){
        [_table reloadData];
        [_table.mj_header endRefreshing];
        
    }else{
        [_table.mj_header endRefreshing];
        [ProgressUtil showError:info];
    }
}

- (void)loadMoreDataOnCompletion:(BOOL) success hasMoreData:(BOOL) moreData info:(NSString*) info{
    if(success){
        if(moreData){
            [_table.mj_footer endRefreshing];
        }else{
            [_table.mj_footer endRefreshingWithNoMoreData];
        }
        [_table reloadData];
        
    }else{
        [ProgressUtil showError:info];
    }
}


#pragma mark - 点击事件
-(void)backItemAction:(id)sender{
    
    if([[UIDevice currentDevice].systemVersion doubleValue]<8.0){
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"您确定要取消咨询吗?",@"确定",nil];
        [sheet showInView:self.view];
        
        return ;
    }
    //适配ios8以上
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(alert) weakAlert = alert ;
    UIAlertAction* title=[UIAlertAction actionWithTitle:@"您确定要取消咨询吗?" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    WS(ws);
    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];

    }];
    [alert addAction:title];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

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
