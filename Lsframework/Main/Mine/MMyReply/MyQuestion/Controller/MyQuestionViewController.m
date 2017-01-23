//
//  MyQuestionViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "MyQuestionCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MyReply.h"
#import "MyQuestionPresenter.h"
#import "MyQuestionDetailViewController.h"
#import "UIImage+Category.h"

@interface MyQuestionViewController ()<UITableViewDataSource,UITableViewDelegate,MyQuestionPresenterDelegate>

@property(nonatomic ,strong) UITableView *myQuestionTableView;
@property(nonatomic ,strong) NSMutableArray *dataSource;
@property(nonatomic ,strong) MyQuestionPresenter *presenter;

@property(nonatomic ,strong) UIView *noQuestionView;

@end

@implementation MyQuestionViewController

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
    _presenter = [MyQuestionPresenter new];
    _presenter.delegate = self;
    _dataSource = [NSMutableArray array];
    [self setupTableView];
}
- (void)setupTableView{
    _myQuestionTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myQuestionTableView.dataSource = self;
    _myQuestionTableView.delegate = self;
    _myQuestionTableView.backgroundColor = [UIColor clearColor];
    [_myQuestionTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_myQuestionTableView];
    _myQuestionTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight - 64 - 44);
    
    __weak typeof(self) weakSelf = self;
    _myQuestionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.myQuestionTableView.userInteractionEnabled = NO;
        weakSelf.presenter.pageIndex = 1;
        [weakSelf.presenter loadQuestionData];
    }];
    
    _myQuestionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myQuestionTableView.userInteractionEnabled = NO;
        [weakSelf.presenter loadMoreData];
         }];
    [_myQuestionTableView.mj_header beginRefreshing];
}
- (void)setupNoQuestionView{
    _noQuestionView = [UIView new];
    _noQuestionView.backgroundColor = [UIColor clearColor];
    [_myQuestionTableView addSubview:_noQuestionView];
    _noQuestionView.frame = _myQuestionTableView.frame;
    
    UIImageView *noQuestionImageView = [UIImageView new];
    noQuestionImageView.image = [UIImage imageNamed:@"icon_noQuestion"];
    [_noQuestionView addSubview:noQuestionImageView];
    noQuestionImageView.sd_layout.leftSpaceToView(_noQuestionView,(_noQuestionView.width - 90)/2).rightSpaceToView(_noQuestionView,(_noQuestionView.width - 90)/2).topSpaceToView(_noQuestionView,120).heightIs(80);
    
    UILabel *tipsLabel = [UILabel new];
    [_noQuestionView addSubview:tipsLabel];
    tipsLabel.text = @"你还没有提过问题哦~";
    tipsLabel.textColor = UIColorFromRGB(0xA5A5A5);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.sd_layout.leftSpaceToView(_noQuestionView,0).rightSpaceToView(_noQuestionView,0).topSpaceToView(noQuestionImageView,30).heightIs(20);
    
    UIButton *askButton = [UIButton new];
    [_noQuestionView addSubview:askButton];
    [askButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x5ED7D3)] forState:UIControlStateNormal];
    askButton.clipsToBounds = YES;
    [askButton setTitle:@"去问一个" forState:UIControlStateNormal];
    [askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    askButton.layer.cornerRadius = 3.f;
    [askButton addTarget:self action:@selector(askAction) forControlEvents:UIControlEventTouchUpInside];
    askButton.sd_layout.leftSpaceToView(_noQuestionView,120).rightSpaceToView(_noQuestionView,120).topSpaceToView(tipsLabel,20).heightIs(30);
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.presenter.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_myQuestion";
    MyQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.myReply = self.presenter.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyReply *model = self.presenter.dataSource[indexPath.row];
    // 获取cell高度
    return  [self.myQuestionTableView cellHeightForIndexPath:indexPath model:model keyPath:@"myReply" cellClass:[MyQuestionCell class]  contentViewWidth:[self cellContentViewWith]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyQuestionDetailViewController *vc = [MyQuestionDetailViewController new];
    MyReply *myReply = self.presenter.dataSource[indexPath.row];
    vc.myReply = myReply;
    vc.index = 0;
    vc.uuid = [myReply.uuid integerValue];
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

#pragma mark Action

- (void)askAction{
    NSLog(@"去问一个");
}


#pragma mark Delegate
- (void)loadDataComplete:(BOOL)success message:(NSString *)message{
    if (success == TRUE){
        if (_presenter.pageIndex == 1) {
            [self.myQuestionTableView.mj_header endRefreshing];
            [self.myQuestionTableView.mj_footer endRefreshing];
        }else{
            [self.myQuestionTableView.mj_footer endRefreshing];
        }
    }else if (success == false){
        [self.myQuestionTableView.mj_header endRefreshing];
        if (message.length > 0) {
            [self.myQuestionTableView.mj_footer endRefreshing];
        }else{
            [self.myQuestionTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    [self.myQuestionTableView reloadData];
    self.myQuestionTableView.userInteractionEnabled = YES;
}


@end
