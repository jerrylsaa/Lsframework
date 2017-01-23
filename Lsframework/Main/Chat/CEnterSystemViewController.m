//
//  CEnterSystemViewController.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CEnterSystemViewController.h"
#import "CSystemNoticeCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>

#import"CEnterCommentCell.h"
#import "CEnterListenCell.h"
#import "CSystemNoticeCell.h"

//系统消息进入相应页面
#import "HotDetailConsulationViewController.h"      //问题详情
#import "HotDetailConsulationInfoViewController.h"  //问题评论回复
#import "PublicPostDetailViewController.h"   //帖子详情
#import "CommentDetailViewController.h"     //帖子评论回复
#import "RelatedAnswerViewController.h"  //医生待回答页面
#import "ReplyAnswerViewController.h"  //医生已回答页面
#import "DailyArticleViewController.h" //每日必读详情页
#import "PushPresenter.h"

@interface CEnterSystemViewController ()<UITableViewDelegate,UITableViewDataSource,PushPresenterDelegate>
{
    NSNumber  *uuid;
    
}
@property (nonatomic, strong) PushPresenter *PushPresenter;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *favoriteArray;

@end

@implementation CEnterSystemViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self setUpView];
    
    
    
}

-(void)setUpData
{
    _favoriteArray = [NSMutableArray array];
    
    switch (self.Types) {
        case 0:
        {
            [_favoriteArray removeAllObjects];
            
            [_favoriteArray addObject:_systemModel];
        }
            break;
        case 1:
        {
            [_favoriteArray removeAllObjects];
            
            [_favoriteArray addObject:_comment];
        }
            break;
        case 2:
        {
            [_favoriteArray removeAllObjects];
            
            [_favoriteArray addObject:_favorite];
        }
            break;
        case 3:
        {
            [_favoriteArray removeAllObjects];
            
            [_favoriteArray addObject:_listen];
        }
            break;
            
        default:
            break;
    }
    
    [_tableView reloadData];
    
}
-(void)setUpView
{
    UITableView *table = [UITableView new];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.scrollEnabled = NO;
//    table.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:0.5];
    [self.view addSubview:table];
    self.tableView = table;
    
    
    table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setUpData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _favoriteArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.Types) {
        case 0:
        {
            CSystemNoticeCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"system"];
            cell.systemModel = _favoriteArray[indexPath.row];
            if (!cell) {
                cell = [[CSystemNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"system"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        case 1:
        {
            CEnterCommentCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.comment = _favoriteArray[indexPath.row];
            if (!cell) {
                cell = [[CEnterCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            CEnterCommentCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.favorite = _favoriteArray[indexPath.row];
            if (!cell) {
                cell = [[CEnterCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:
        {
            CEnterListenCell *Listen = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            Listen.listen = _favoriteArray[indexPath.row];
            if (!Listen) {
                Listen = [[CEnterListenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            Listen.selectionStyle = UITableViewCellSelectionStyleNone;
            return Listen;
        }
            break;
            
        default:
            break;
    }
    
    
    return [UITableViewCell new];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.Types) {
        case 0:
        {
            SystemNotice *chat = [_favoriteArray objectAtIndex:indexPath.row] ;
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
//                [self.delegate pushToVc:vc];
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else if ([chat.Type  isEqualToString:@"1"]){
                //问题评论被回复
                HotDetailConsulationInfoViewController  *vc = [HotDetailConsulationInfoViewController new];
                vc.commentID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if ([chat.Type  isEqualToString:@"4"]||[chat.Type  isEqualToString:@"6"]){
                //帖子被评论、点赞
                PublicPostDetailViewController  *vc = [PublicPostDetailViewController new];
                vc.UUID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if ([chat.Type  isEqualToString:@"7"]){
                //帖子评论被回复
                CommentDetailViewController  *vc = [CommentDetailViewController new];
                vc.commentID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
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
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:
        {
            CMyComment *chat = [_favoriteArray objectAtIndex:indexPath.row] ;
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
                //                [self.delegate pushToVc:vc];
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else if ([chat.Type  isEqualToString:@"1"]){
                //问题评论被回复
                HotDetailConsulationInfoViewController  *vc = [HotDetailConsulationInfoViewController new];
                vc.commentID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if ([chat.Type  isEqualToString:@"4"]||[chat.Type  isEqualToString:@"6"]){
                //帖子被评论、点赞
                PublicPostDetailViewController  *vc = [PublicPostDetailViewController new];
                vc.UUID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if ([chat.Type  isEqualToString:@"7"]){
                //帖子评论被回复
                CommentDetailViewController  *vc = [CommentDetailViewController new];
                vc.commentID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
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
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2:
        {
            MyFavorite *chat = [_favoriteArray objectAtIndex:indexPath.row] ;
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
                //                [self.delegate pushToVc:vc];
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else if ([chat.Type  isEqualToString:@"1"]){
                //问题评论被回复
                HotDetailConsulationInfoViewController  *vc = [HotDetailConsulationInfoViewController new];
                vc.commentID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if ([chat.Type  isEqualToString:@"4"]||[chat.Type  isEqualToString:@"6"]){
                //帖子被评论、点赞
                PublicPostDetailViewController  *vc = [PublicPostDetailViewController new];
                vc.UUID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if ([chat.Type  isEqualToString:@"7"]){
                //帖子评论被回复
                CommentDetailViewController  *vc = [CommentDetailViewController new];
                vc.commentID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
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
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3:
        {
            CConsultationBeListen *chat = [_favoriteArray objectAtIndex:indexPath.row] ;
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
                //                [self.delegate pushToVc:vc];
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else if ([chat.Type  isEqualToString:@"1"]){
                //问题评论被回复
                HotDetailConsulationInfoViewController  *vc = [HotDetailConsulationInfoViewController new];
                vc.commentID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if ([chat.Type  isEqualToString:@"4"]||[chat.Type  isEqualToString:@"6"]){
                //帖子被评论、点赞
                PublicPostDetailViewController  *vc = [PublicPostDetailViewController new];
                vc.UUID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if ([chat.Type  isEqualToString:@"7"]){
                //帖子评论被回复
                CommentDetailViewController  *vc = [CommentDetailViewController new];
                vc.commentID = uuid;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
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
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    
}
#pragma  mark----push进入页面网络请求
-(void)loadPushDoctorAnswerCompletion:(BOOL)success  info:(NSString*)message{
    if (success) {
        if ([_PushPresenter.IsAnwer  integerValue] == 0) {
            //待回答
            NSLog(@"待回答");
            
            RelatedAnswerViewController  *Relatedvc = [RelatedAnswerViewController new];
            
            Relatedvc.uuid =[NSNumber  numberWithInteger:[_PushPresenter.AnswerSource[0].uuid  integerValue]];
            
            [self.navigationController pushViewController:Relatedvc animated:YES];
            
        }else if ([_PushPresenter.IsAnwer  integerValue] == 1) {
            //已回答
            ReplyAnswerViewController  *vc = [ReplyAnswerViewController new];
            vc.MyAnswerEntity = _PushPresenter.AnswerSource[0];
            NSLog(@"已回答");
            NSLog(@"医生待回答接口数据：%@---医生待回答vc数据：%@",_PushPresenter.AnswerSource[0],vc.MyAnswerEntity);
            [self.navigationController  pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (self.Types) {
        case 0:
        {
            SystemNotice  * system = _favoriteArray [indexPath.row];
            
            return  [_tableView cellHeightForIndexPath:indexPath model:system keyPath:@"systemModel" cellClass:[CSystemNoticeCell class] contentViewWidth:[self cellContentViewWith]];
        }
            break;
        case 1:
        {
           CMyComment  * comment = _favoriteArray [indexPath.row];
            
            return  [_tableView cellHeightForIndexPath:indexPath model:comment keyPath:@"comment" cellClass:[CEnterCommentCell class] contentViewWidth:[self cellContentViewWith]];
        }
            break;
        case 2:
        {
            MyFavorite * favorite = _favoriteArray [indexPath.row];
            
            return  [_tableView cellHeightForIndexPath:indexPath model:favorite keyPath:@"favorite" cellClass:[CEnterCommentCell class] contentViewWidth:[self cellContentViewWith]];
        }
            break;
        case 3:
        {
            CConsultationBeListen * listen = _favoriteArray [indexPath.row];
            
            return  [_tableView cellHeightForIndexPath:indexPath model:listen keyPath:@"listen" cellClass:[CEnterListenCell  class] contentViewWidth:[self cellContentViewWith]];
        }
            break;
        default:
            break;
    }
    return 100;
    
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
