//
//  CSystemNoticeViewController.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CSystemNoticeViewController.h"
#import "NoticeAndSystemCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "SystemNotiecPresenter.h"

//系统消息进入相应页面
#import "HotDetailConsulationViewController.h"      //问题详情
#import "HotDetailConsulationInfoViewController.h"  //问题评论回复
#import "PublicPostDetailViewController.h"   //帖子详情
#import "CommentDetailViewController.h"     //帖子评论回复
#import "RelatedAnswerViewController.h"  //医生待回答页面
#import "ReplyAnswerViewController.h"  //医生已回答页面
#import "DailyArticleViewController.h" //每日必读详情页
#import "PushPresenter.h"

@interface CSystemNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,SystemNotiecPresenterDelegate,PushPresenterDelegate>
{
    NSNumber  *uuid;

}
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)SystemNotiecPresenter *presenter;
@property (nonatomic, strong) PushPresenter *PushPresenter;

@end

@implementation CSystemNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [kdefaultCenter addObserver:self selector:@selector(RefreshSegmentNoticeTypeViewController) name:@"SegmentNoticeTypeRefresh" object:nil];
}

-(void)RefreshSegmentNoticeTypeViewController{
    
    [_table.mj_header  beginRefreshing];
    
}

-(void)setupView
{
    _presenter = [SystemNotiecPresenter new];
    _presenter.delegate = self;
    
    _table = [UITableView new];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight-64);
    NSString *url = API_gettempsystemmessage;
    
    WS(ws);
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _table.userInteractionEnabled = YES;
        [ws.presenter loadSystemNotice:url];
    }];
    [_table.mj_header beginRefreshing];
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _table.userInteractionEnabled = NO;
        [ws.presenter loadSystemMoreNotiec:url];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.presenter.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NoticeAndSystemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[NoticeAndSystemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.systemModel  = [self.presenter.dataSource objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNotice *systemNotice = [self.presenter.dataSource objectAtIndex:indexPath.row] ;
    
    return [_table cellHeightForIndexPath:indexPath model:systemNotice keyPath:@"systemModel" cellClass:[NoticeAndSystemCell class] contentViewWidth:[self cellContentViewWith]];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     SystemNotice *chat = [self.presenter.dataSource objectAtIndex:indexPath.row] ;
    NSString *userString = chat.Params;
    NSData *data = [[NSData alloc]initWithData:[userString dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    if ([chat.Type  isEqualToString:@"10"]) {
        
        
    }else if ([chat.Type  isEqualToString:@"8"]||[chat.Type  isEqualToString:@"9"]){
        
        uuid = [dic  objectForKey:@"uuid"];
        
    }else{
        
        uuid = [dic  objectForKey:@"UUID"];
        
    }

    
    NSLog(@"uuid:%@-----类型%@",uuid,chat.Type);
    
    if ([chat.Type  isEqualToString:@"0"]||[chat.Type  isEqualToString:@"2"]||[chat.Type  isEqualToString:@"3"]) {
        //问题咨询被评论、旁听问题、点赞
        HotDetailConsulationViewController  *vc = [HotDetailConsulationViewController new];
        vc.UUID = uuid;
        [self.delegate pushToVc:vc];

        
    }else if ([chat.Type  isEqualToString:@"1"]){
        //问题评论被回复
        HotDetailConsulationInfoViewController  *vc = [HotDetailConsulationInfoViewController new];
        vc.commentID = uuid;
        [self.delegate pushToVc:vc];

        
        
    }else if ([chat.Type  isEqualToString:@"4"]||[chat.Type  isEqualToString:@"6"]){
        //帖子被评论、点赞
        PublicPostDetailViewController  *vc = [PublicPostDetailViewController new];
        vc.UUID = uuid;
        [self.delegate pushToVc:vc];

        
        
    }else if ([chat.Type  isEqualToString:@"7"]){
        //帖子评论被回复
        CommentDetailViewController  *vc = [CommentDetailViewController new];
        vc.commentID = uuid;
        [self.delegate pushToVc:vc];

        
        
    }else if ([chat.Type  isEqualToString:@"-1"]){
        //-1正式服务器Bug
        
    }else if ([chat.Type  isEqualToString:@"8"]||[chat.Type  isEqualToString:@"9"]){
        //医生待回答页面
        _PushPresenter = [PushPresenter  new];
        _PushPresenter.delegate = self;
        [_PushPresenter  loadPushDoctorAnswerinfoWithType:[NSNumber  numberWithInteger:[chat.Type integerValue]] UUID:uuid];
    
        
    }else  if ([chat.Type  isEqualToString:@"10"]){
        //每日必读详情页
        DailyArticleViewController  *vc = [DailyArticleViewController new];
        /**    DATA = "{\"ID\":\"39\",\"Title\":\"世界早产日活动\",\"Url\":\"http://www.zhongkang365.com/MobileHtml/everyday/childgm161110.html\",\"Photo\":\"http://tigerhuang007.xicp.io/MobileHtml/everyday/images/pic16926.png\",\"PraiseCount\":4,\"badgeID\":1624.0}";
         TYPE = 10;
         
         */
        vc.TodayRecommend = [TodayRecommend mj_objectWithKeyValues:dic];
        NSLog(@"每日必读带导航栏推送：---%@-----%@-----%@-----%@-----%@",vc.TodayRecommend.ID,vc.TodayRecommend.Title,vc.TodayRecommend.Url,vc.TodayRecommend.Photo,vc.TodayRecommend.PraiseCount);
        
        [self.delegate pushToVc:vc];
    }

}
#pragma  mark----push进入页面网络请求
-(void)loadPushDoctorAnswerCompletion:(BOOL)success  info:(NSString*)message{
    if (success) {
        if ([_PushPresenter.IsAnwer  integerValue] == 0) {
            //待回答
            NSLog(@"待回答");
            
            RelatedAnswerViewController  *Relatedvc = [RelatedAnswerViewController new];
//            Relatedvc.uuid = uuid;
            Relatedvc.uuid =[NSNumber  numberWithInteger:[_PushPresenter.AnswerSource[0].uuid  integerValue]];
            
            [self.delegate pushToVc:Relatedvc];
            
        }else if ([_PushPresenter.IsAnwer  integerValue] == 1) {
            //已回答
            ReplyAnswerViewController  *vc = [ReplyAnswerViewController new];
            vc.MyAnswerEntity = _PushPresenter.AnswerSource[0];
            NSLog(@"已回答");
            NSLog(@"医生待回答接口数据：%@---医生待回答vc数据：%@",_PushPresenter.AnswerSource[0],vc.MyAnswerEntity);
            [self.delegate pushToVc:vc];
        }
    }
}

#pragma mark --网络请求回调－－
-(void)GetSystemNoticeCompletion:(BOOL)success info:(NSString *)message
{
    _table.userInteractionEnabled = YES;
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    
    if (success) {
        
        [_table reloadData];
        
    }
}
-(void)GetSystemNoticeMoreListCompletion:(BOOL)success info:(NSString *)message
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
-(void)dealloc{
    NSLog(@"%@ ==== %@ is Dealloc", self.title, [[self class] description]);
    
    [kdefaultCenter removeObserver:self name:@"SegmentNoticeTypeRefresh" object:nil];
    
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
