//
//  RankingViewController.m
//  FamilyPlatForm
//
//  Created by Mac on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RankingViewController.h"
#import "RankingCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "RankingPresenter.h"
#import "DailyArticleViewController.h"
#import "MoreViewController.h"
@interface RankingViewController ()<UITableViewDelegate,UITableViewDataSource,RankingPresenterDelegate>
{
    NSInteger  PraiseIndex;
    
    NSNumber *CategoryID;
    
    NSString *moreTitle;
    
    UIView *headVeiws;
    
    NSInteger index;
    
    NSMutableArray *mutArray;
    
}
@property(nonatomic,strong)UITableView*table;
@property(nonatomic,strong)RankingPresenter *presenter;
@property(nonatomic,strong)UIButton  *starButton;
@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [kdefaultCenter addObserver:self selector:@selector(refreshDailyArticleMoreList) name:Notification_RefreshDailyArticleMore object:nil];
}
-(void)setupView
{
    _presenter = [RankingPresenter  new];
    _presenter.delegate = self;
//
//    UITableView  *table = [UITableView  new];
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[RankingCell class] forCellReuseIdentifier:@"cell"];
    [self.view  addSubview:table];
    self.table = table;
    table.sd_layout.topSpaceToView(self.view, 0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight - 64 -49);
    
    WS(ws);
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        table.userInteractionEnabled = NO;
        [ws.presenter GetDailyArticleList];
        
    }];
    [table.mj_header beginRefreshing];
//    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        table.userInteractionEnabled = NO;
//        [ws.presenter GetDailyArticleMoreList];
//    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presenter.dataSource.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.presenter.rootArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankingCell* cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
    cell.todayRecommend  = self.presenter.dataSource[indexPath.row];
    [cell.praiseBtn  addTarget:self action:@selector(PraiseCountClicks:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  
    cell.praiseBtn.tag = indexPath.row;
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    index = indexPath.section;
    
    [_table deselectRowAtIndexPath:indexPath animated:YES];
    DailyArticleViewController *vc = [DailyArticleViewController new];
    vc.TodayRecommend = [self.presenter.dataSource objectAtIndex:indexPath.row];
    [self.delegate  pushToVc:vc];
#pragma 打点统计*头条-->排行--每行
    [BasePresenter  EventStatisticalDotTitle:DotRankingRow Action:DotEventEnter  Remark:nil];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    mutArray = [NSMutableArray array];
    for (NSDictionary *dic in self.presenter.rootArray) {
        NSDictionary *tit = dic[@"Key"];
        [mutArray addObject:tit];
    }
    
    
    UIView *headVeiw = [UIView new];
    headVeiw.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MoreTap)];
    
    [headVeiw addGestureRecognizer:tap];
    
    NSDictionary *dic = mutArray[section];
    UILabel *titleLb  = [UILabel new];
    titleLb.textColor = UIColorFromRGB(0x2dcbc4);
    titleLb.text = dic[@"NAME"];
    titleLb.font = [UIFont systemFontOfSize:16];
    [headVeiw addSubview:titleLb];
    
    moreTitle = dic[@"NAME"];
    CategoryID = dic[@"ID"];
    
    UILabel *moreLb = [UILabel new];
    moreLb.userInteractionEnabled = YES;
    moreLb.text = @"更多";
    moreLb.textColor = UIColorFromRGB(0x999999);
    moreLb.font = [UIFont systemFontOfSize:12];
    [headVeiw addSubview:moreLb];
    
    UIImageView *rowImg = [UIImageView new];
    rowImg.userInteractionEnabled = YES;
    rowImg.image = [UIImage imageNamed:@"go"];
    [headVeiw addSubview:rowImg];
    
    titleLb.sd_layout.topSpaceToView(headVeiw,25/2).leftSpaceToView(headVeiw,15).autoHeightRatio(0).widthIs(16);
    titleLb.width = [JMFoundation  calLabelWidth:titleLb];
    [titleLb updateLayout];
    rowImg.sd_layout.centerYEqualToView (titleLb).rightSpaceToView(headVeiw,15).heightIs(12).widthIs(12);
    moreLb.sd_layout.centerYEqualToView(titleLb).rightSpaceToView(rowImg,5).heightIs(12).widthIs([JMFoundation calLabelWidth:moreLb]);
    
    return headVeiw;
}
-(void)MoreTap
{
    NSLog(@"index= is - %@",index);
    
    
    
    MoreViewController *vc = [[MoreViewController alloc]init];
    vc.CategoryID = CategoryID;
    vc.Moretitle = moreTitle;
    [self.delegate pushToVc:vc];
    
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
    
    TodayRecommend  *model = _presenter.dataSource[PraiseIndex];
    RankingCell* cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
    if ([model.IsPraise integerValue] == 1) {
        //取消点赞
        //            [cell.DailyPraiseLb setTitle:[NSString  stringWithFormat:@"%d",[model.PraiseCount  integerValue]-1] forState:UIControlStateNormal];
        cell.praiseLabel.text = [NSString  stringWithFormat:@"%ld",[model.PraiseCount  integerValue]-1];
        [cell.praiseBtn  setImage:[UIImage  imageNamed:@"Heart_gray"]  forState:UIControlStateNormal];
        [_presenter  CancelArticlePraiseByArticleID:model.ID];
        
    }else{
        //点赞
        //            [_DailyPraiseCountBt setTitle:[NSString  stringWithFormat:@"%d",[model.PraiseCount  integerValue]+1] forState:UIControlStateNormal];
        cell.praiseLabel.text = [NSString  stringWithFormat:@"%ld",[model.PraiseCount  integerValue]+1];
        [cell.praiseBtn  setImage:[UIImage  imageNamed:@"hear_red"]  forState:UIControlStateNormal];
        [_presenter  InsertArticlePraiseByArticleID:model.ID];
        
        
    }
}
//点赞完成回调
-(void)InsertArticlePraiseCommentCompletion:(BOOL)success info:(NSString*)message{
    if (success) {
        [ProgressUtil showSuccess:@"点赞成功"];
        [_presenter GetDailyArticleList];
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
        
        [_presenter GetDailyArticleList];
        //发送通知，刷新首页每日必读点赞数量
        [kdefaultCenter postNotificationName:Notification_Refresh_DailyArticlePraiseCount object:nil userInfo:nil];
    }else{
        
        [ProgressUtil  showError:message];
    }
    
}

#pragma mark --网络请求回调－－
-(void)GetDailyArticleListCompletion:(BOOL)success info:(NSString *)message
{
    _table.userInteractionEnabled = YES;
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    
    if (success) {
        [_table reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark - 监听通知回调
- (void)refreshDailyArticleMoreList{
    [_table.mj_header beginRefreshing];
}

-(void)dealloc{
    
    NSLog(@"%@ ==== %@ is Dealloc", self.title, [[self class] description]);
    
    //
    [kdefaultCenter removeObserver:self name:Notification_RefreshDailyArticleMore object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#pragma 打点统计*头条-->排行segment

    [BasePresenter  EventStatisticalDotTitle:DotRanking Action:DotEventEnter  Remark:nil];
    
}

@end
