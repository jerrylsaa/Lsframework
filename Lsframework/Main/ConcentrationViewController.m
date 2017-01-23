//
//  ConcentrationViewController.m
//  FamilyPlatForm
//
//  Created by Mac on 16/11/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ConcentrationViewController.h"
#import "ConcentationCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
//#import "ConcentrationPresenter.h"
#import "DailyArticleViewController.h"
@interface ConcentrationViewController ()<UITableViewDelegate,UITableViewDataSource,ConcentrationPresenterDelegate>
//{
//    NSInteger  PraiseIndex;
//
//}
//@property(nonatomic,strong)ConcentrationPresenter *presenter;
//@property(nonatomic,strong)UIButton  *starButton;
///** table*/
//@property(nonatomic,strong)UITableView*table;
@end

@implementation ConcentrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [kdefaultCenter addObserver:self selector:@selector(refreshDailyArticleMoreList) name:Notification_RefreshDailyArticleMore object:nil];
    
    [self seTupView];
    
}
-(void)seTupView
{
    _presenter = [ConcentrationPresenter  new];
    _presenter.delegate = self;
    
    UITableView  *table = [UITableView  new];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[ConcentationCell class] forCellReuseIdentifier:@"cell"];
    [self.view  addSubview:table];
    self.table = table;
    table.sd_layout.topSpaceToView(self.view, 0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight - 64 -49);
    
    WS(ws);
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        table.userInteractionEnabled = NO;
        [ws.presenter GetDailyArticleList];
        
    }];
    [table.mj_header beginRefreshing];
    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            table.userInteractionEnabled = NO;
            [ws.presenter GetDailyArticleMoreList];
        }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.presenter.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConcentationCell* cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
    cell.todayRecommend  = [self.presenter.dataSource objectAtIndex:indexPath.row];
    [cell.praiseBtn  addTarget:self action:@selector(PraiseCountClicks:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  
    cell.praiseBtn.tag = indexPath.row;
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_table deselectRowAtIndexPath:indexPath animated:YES];
    DailyArticleViewController *vc = [DailyArticleViewController new];
    vc.TodayRecommend = [self.presenter.dataSource objectAtIndex:indexPath.row];
    [self.delegate  pushToVc:vc];
    
#pragma 打点统计*头条-->精选--每行
    [BasePresenter  EventStatisticalDotTitle:DotConcentrationRow Action:DotEventEnter  Remark:nil];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TodayRecommend *recommend = [self.presenter.dataSource objectAtIndex:indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:recommend keyPath:@"todayRecommend" cellClass:[ConcentationCell class] contentViewWidth:[self cellContentViewWith]];
    
//    return 150;
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
    ConcentationCell* cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
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
-(void)GetDailyArticleMoreListCompletion:(BOOL)success info:(NSString *)message
{
    
    _table.userInteractionEnabled = YES;
    
    self.presenter.noMoreData? [_table.mj_footer endRefreshingWithNoMoreData]: [_table.mj_footer endRefreshing];
    
    if(success){
        [_table reloadData];
        
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
#pragma 打点统计*头条-->精选segment
    [BasePresenter  EventStatisticalDotTitle:DotConcentration Action:DotEventEnter  Remark:nil];
    
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
