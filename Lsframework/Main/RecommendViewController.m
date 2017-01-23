//
//  RecommendViewController.m
//  FamilyPlatForm
//
//  Created by Mac on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendCell.h"
#import "RecommendPresenter.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "DailyArticleViewController.h"
@interface RecommendViewController ()<UITableViewDelegate,UITableViewDataSource,RecommendPresenterDelegate>
{
    NSInteger  PraiseIndex;
    
}
/** table*/
@property(nonatomic,strong)UITableView*recommendTable;
@property(nonatomic,strong)RecommendPresenter *presenter;
@property(nonatomic,strong)UIButton  *starButton;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [self setUpTableView];
    
    [kdefaultCenter addObserver:self selector:@selector(refreshDailyArticleMoreList) name:Notification_RefreshDailyArticleMore object:nil];
    
}
-(void)setupView
{
    _presenter = [RecommendPresenter  new];
    _presenter.delegate = self;
    
    UITableView  *table = [UITableView  new];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[RecommendCell class] forCellReuseIdentifier:@"cell"];
    [self.view  addSubview:table];
    self.recommendTable = table;
    table.sd_layout.topSpaceToView(self.view, 0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight - 64 -49);
    
    WS(ws);
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        table.userInteractionEnabled = NO;
        [ws.presenter getRecommendList];
        
    }];
    [table.mj_header beginRefreshing];
    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        table.userInteractionEnabled = NO;
        [ws.presenter getMoreRecommendList];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presenter.reommendSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendCell* cell = [_recommendTable dequeueReusableCellWithIdentifier:@"cell"];
    cell.todayRecommend  = [self.presenter.reommendSource objectAtIndex:indexPath.row];
    [cell.praiseButton  addTarget:self action:@selector(PraiseCountClicks:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayRecommend *recommend = [self.presenter.reommendSource objectAtIndex:indexPath.row];

    return [_recommendTable cellHeightForIndexPath:indexPath model:recommend keyPath:@"todayRecommend" cellClass:[RecommendCell class] contentViewWidth:[self cellContentViewWith]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_recommendTable deselectRowAtIndexPath:indexPath animated:YES];
    DailyArticleViewController *vc = [DailyArticleViewController new];
    vc.TodayRecommend = [self.presenter.reommendSource objectAtIndex:indexPath.row];
    [self.delegate  pushToVc:vc];
    
#pragma 打点统计*头条-->今日推荐--每行
    [BasePresenter  EventStatisticalDotTitle:DotRecommendRow Action:DotEventEnter  Remark:nil];
   
    
}

//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil showSuccess:@"点赞成功"];
        [_presenter getRecommendList];
        //发送通知，刷新首页每日必读点赞数量
        [kdefaultCenter postNotificationName:Notification_Refresh_DailyArticlePraiseCount object:nil userInfo:nil];
    }else{
        
        [ProgressUtil  showError:message];
    }
    
}

//取消点赞回调
-(void)CancelArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil showSuccess:@"取消点赞成功"];
        
        [_presenter getRecommendList];
        //发送通知，刷新首页每日必读点赞数量
        [kdefaultCenter postNotificationName:Notification_Refresh_DailyArticlePraiseCount object:nil userInfo:nil];
    }else{
        
        [ProgressUtil  showError:message];
    }
    
}
#pragma mark - 文章点赞事件
-(void)PraiseCountClicks:(UIButton*)btn{
    if(btn!=self.starButton){
        self.starButton.selected=NO;
        self.starButton=btn;
    }
    self.starButton.selected=YES;
    if (btn.selected == YES) {
        PraiseIndex = btn.tag;
    }
    
    TodayRecommend  *model = _presenter.reommendSource[PraiseIndex];
    RecommendCell* cell = [_recommendTable dequeueReusableCellWithIdentifier:@"cell"];
    if ([model.IsPraise integerValue] == 1) {
        //取消点赞
        //            [cell.DailyPraiseLb setTitle:[NSString  stringWithFormat:@"%d",[model.PraiseCount  integerValue]-1] forState:UIControlStateNormal];
        cell.praiseLabel.text = [NSString  stringWithFormat:@"%ld",[model.PraiseCount  integerValue]-1];
        [cell.praiseButton  setImage:[UIImage  imageNamed:@"Heart_gray"]  forState:UIControlStateNormal];
        [_presenter  CancelArticlePraiseByArticleID:model.ID];
        
    }else{
        //点赞
        //            [_DailyPraiseCountBt setTitle:[NSString  stringWithFormat:@"%d",[model.PraiseCount  integerValue]+1] forState:UIControlStateNormal];
        cell.praiseLabel.text = [NSString  stringWithFormat:@"%ld",[model.PraiseCount  integerValue]+1];
        [cell.praiseButton  setImage:[UIImage  imageNamed:@"hear_red"]  forState:UIControlStateNormal];
        [_presenter  InsertArticlePraiseByArticleID:model.ID];
        
        
    }
}
#pragma mark - 监听通知回调
- (void)refreshDailyArticleMoreList{
    [_recommendTable.mj_header beginRefreshing];
}

-(void)dealloc{
    NSLog(@"%@ ==== %@ is Dealloc", self.title, [[self class] description]);
    
    [kdefaultCenter removeObserver:self name:Notification_RefreshDailyArticleMore object:nil];
    
}

#pragma mark --网络请求回调－－
-(void)GetRecommendListCompletion:(BOOL)success info:(NSString *)message
{
    _recommendTable.userInteractionEnabled = YES;
    [_recommendTable.mj_footer resetNoMoreData];
    [_recommendTable.mj_header endRefreshing];
    
    if (success) {
        [_recommendTable reloadData];
    }
}
-(void)GetRecommendMoreListCompletion:(BOOL)success info:(NSString *)message{
    
    _recommendTable.userInteractionEnabled = YES;
    
    self.presenter.noMoreData? [_recommendTable.mj_footer endRefreshingWithNoMoreData]: [_recommendTable.mj_footer endRefreshing];
    
    if(success){
        [_recommendTable reloadData];
        
    }else{
        [ProgressUtil showError:message];
    }
    
    
}

#pragma mark - 私有方法

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#pragma 打点统计*头条
    [BasePresenter  EventStatisticalDotTitle:Dottoptab Action:DotEventEnter  Remark:nil];



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
