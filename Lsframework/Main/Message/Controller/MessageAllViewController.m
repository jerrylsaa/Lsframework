//
//  MessageAllViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MessageAllViewController.h"
#import "MessageTableViewCell.h"
#import "MessagePresenter.h"
#import "JMChatViewController.h"

@interface MessageAllViewController ()<MessagePresnterDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MessagePresenter * presenter;

@end

@implementation MessageAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isHideTabbar = NO;
}

-(void)setupView{
    _presenter = [MessagePresenter new];
    _presenter.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    WS(ws);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter refreshMessageData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.presenter loadMoreMessageData];
    }];
    [_tableView.mj_header beginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark MessagePresnterDelegate

-(void)onChangeMessageStatusComplete:(BOOL)success withPosition:(NSUInteger)position{
    
}

-(void)onRefreshComplete:(BOOL)success{
    [_tableView reloadData];
    [_tableView.mj_footer resetNoMoreData];
    [_tableView.mj_header endRefreshing];
}

-(void)onLoadMessageComplete:(BOOL)success hasMoreData:(BOOL)hasMoreData{
        [_tableView reloadData];
    if (hasMoreData) {
        [_tableView.mj_footer endRefreshing];
    }else{
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _presenter.messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell configCell:_presenter.messages[indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    BaseViewController * vc = [[ BaseViewController alloc] init];
    
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
    
    
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
