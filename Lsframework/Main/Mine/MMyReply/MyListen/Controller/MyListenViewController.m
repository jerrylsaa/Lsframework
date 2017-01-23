//
//  MyListenViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyListenViewController.h"
#import "MyListenPresenter.h"
#import "MyListenCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MyReply.h"
#import "MyListenDetailViewController.h"


@interface MyListenViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *myListenTableView;
@property (nonatomic, strong)MyListenPresenter *presenter;
@property (nonatomic, strong)NSArray *dataSource;

@end

@implementation MyListenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    _presenter = [MyListenPresenter new];
    [self setupTablwView];
}

- (void)setupTablwView{
    _myListenTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myListenTableView.dataSource = self;
    _myListenTableView.delegate = self;
    _myListenTableView.backgroundColor = [UIColor clearColor];
    [_myListenTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_myListenTableView];
    _myListenTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight - 64 - 44);
    __weak typeof(self) weakSelf = self;
    _myListenTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.presenter.pageIndex = 1;
        [weakSelf.presenter loadListenData:^(BOOL success, NSString *message) {
            [weakSelf.myListenTableView.mj_header endRefreshing];
            [weakSelf.myListenTableView.mj_footer endRefreshing];
            if (success == TRUE){
                
                weakSelf.dataSource = weakSelf.presenter.dataSource;
                [weakSelf.myListenTableView reloadData];
                
            }else if (success == false){
                if (message.length > 0) {
                    [weakSelf.myListenTableView.mj_header endRefreshing];
                }
            }
        }];
    }];
    
    _myListenTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.presenter loadMoreData:^(BOOL success, NSString *message) {
            if (success == TRUE){
                [weakSelf.myListenTableView.mj_footer endRefreshing];
                weakSelf.dataSource = weakSelf.presenter.dataSource;
                [weakSelf.myListenTableView reloadData];
            }else if (success == false){
                [weakSelf.myListenTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }];
    [_myListenTableView.mj_header beginRefreshing];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_myListen";
    MyListenCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyListenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.myListen = _dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyReply *model = _dataSource[indexPath.row];
    // 获取cell高度
    return  [self.myListenTableView cellHeightForIndexPath:indexPath model:model keyPath:@"myListen" cellClass:[MyListenCell class]  contentViewWidth:[self cellContentViewWith]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyListenDetailViewController *vc = [MyListenDetailViewController new];
    MyListen *myListen = self.presenter.dataSource[indexPath.row];
    vc.uuid = [myListen.ConsultationID integerValue];
    vc.index = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToVc:)]) {
        [self.delegate pushToVc:vc];
    }

    

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
