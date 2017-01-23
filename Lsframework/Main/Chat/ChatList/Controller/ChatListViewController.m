//
//  ChatListViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListPresenter.h"
#import "ChatViewController.h"
#import "ChatListCell.h"
#import "JMChatViewController.h"
//推送进入相关页面头文件
#import "HotDetailConsulationViewController.h"      //问题详情
#import "HotDetailConsulationInfoViewController.h"  //问题评论回复
#import "PublicPostDetailViewController.h"   //帖子详情
#import "CommentDetailViewController.h"     //帖子评论回复
#import "ChatViewController.h"     //聊天页面
#import "AwaitAnswerViewController.h"  //医生待回答页面
#import "DailyArticleViewController.h" //每日必读详情页

#import "TodayRecommend.h"
#import "MyAnserEntity.h"


#import "ClearBadgePresenter.h"

@interface ChatListViewController ()<UITableViewDataSource,UITableViewDelegate,ChatListPresenterDelegate>{
    
    NSNumber  *uuid;
    
}

@property (nonatomic, strong) UITableView *chatListView;
@property (nonatomic, strong) ChatListPresenter *presenter;


@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [kdefaultCenter addObserver:self selector:@selector(RefreshSegmentChatListTypeRefreshViewController) name:@"SegmentChatListTypeRefresh" object:nil];
    

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.rdv_tabBarController setTabBarHidden:NO animated:animated];
     self.isHideTabbar = YES;
    
//    [_chatListView.mj_header beginRefreshing];
//    [kdefaultCenter addObserver:self selector:@selector(PushGeTuiViewController:) name:Notification_PushGeTui object:nil];
    


}
-(void)RefreshSegmentChatListTypeRefreshViewController{
    [_chatListView.mj_header  beginRefreshing];


}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [kdefaultCenter removeObserver:self name:Notification_PushGeTui object:nil];
}

//-(void)PushGeTuiViewController:(NSNotification *)noti{
//    
//    NSLog(@"由推送进入问题详情");
//    dispatch_async(dispatch_get_main_queue(), ^{
//    ClearBadgePresenter  *ClearPresenter = [ClearBadgePresenter  new];
//        
//        NSDictionary* userInfo = noti.userInfo;
//        NSString  *type = [userInfo  objectForKey:@"TYPE"];
//        
//        NSString   *userString = [userInfo  objectForKey:@"DATA"];
//        NSData  *data = [[NSData  alloc]initWithData:[userString  dataUsingEncoding:NSUTF8StringEncoding]];
//        NSDictionary  *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        if ([type  isEqualToString:@"10"]||[type  isEqualToString:@"8"]||[type  isEqualToString:@"9"]) {
//            
//            
//        }else{
//            
//            uuid = [dic  objectForKey:@"UUID"];
//            
//        }
//        NSNumber  *bageID = [dic  objectForKey:@"badgeID"];
//        //角标重新从接口获取
//        [ClearPresenter  ClearBadgeByBadgeID:[bageID  integerValue]
//                                  finish:^(BOOL success, NSString * _Nonnull message) {
//                                      [[UIApplication sharedApplication] setApplicationIconBadgeNumber:ClearPresenter.badgeCount];//可用全局变量累加消息
//                            NSLog(@"角标111：%d",ClearPresenter.badgeCount);
//                                  }];
//
//        
//        if ([type  isEqualToString:@"0"]||[type  isEqualToString:@"3"]) {
//            //问题详情
//            NSLog(@"问题详情返回聊天界面---%@",uuid);
//            HotDetailConsulationViewController  *VC = [HotDetailConsulationViewController  new];
//            VC.UUID = uuid;
//            [self.navigationController  pushViewController:VC animated:YES];
//            
//        }else if ([type  isEqualToString:@"1"]){
//            //问题评论回复
//            NSLog(@"问题评论回复返回聊天界面---%@",uuid);
//            HotDetailConsulationInfoViewController  *VC = [HotDetailConsulationInfoViewController  new];
//            VC.commentID = uuid;
//            [self.navigationController  pushViewController:VC animated:YES];
//            
//        }else if ([type  isEqualToString:@"4"]){
//            //帖子详情
//            NSLog(@"帖子详情返回聊天界面---%@",uuid);
//
//            
//            PublicPostDetailViewController  *VC = [PublicPostDetailViewController  new];
//            VC.UUID = uuid;
//            [self.navigationController  pushViewController:VC animated:YES];
//            
//        }else if ([type  isEqualToString:@"7"]){
//            //帖子评论回复
//            NSLog(@"帖子评论回复返回聊天界面---%@",uuid);
//            CommentDetailViewController  *VC = [CommentDetailViewController  new];
//            VC.commentID = uuid;
//            [self.navigationController  pushViewController:VC animated:YES];
//        }else if ([type  isEqualToString:@"5"]){
//            //消息
//            /**
//             *      DATA = "{\"UUID\":\"396\",\"ReceiveUserID\":\"4\",\"SendUserID \":\"19\",\"NickName\":\"洋洋\"}";
//             
//             */
//
//        NSString  *NickName = [dic objectForKey:@"NickName"];
//        NSNumber  *SendUserID = [dic objectForKey:@"SendUserID"];
//    NSNumber  *ReceiveUserID = [dic objectForKey:@"ReceiveUserID"];
//            
//    ChatViewController *vc = [ChatViewController new];
//    vc.RowID = uuid;
//    vc.nickName = NickName;
//    vc.ReceiveUserID =[ ReceiveUserID  integerValue];
//    vc.SendUserID =  [SendUserID  integerValue];
//    vc.chatType = ChatTypePush;
//    [self.navigationController pushViewController:vc animated:YES];
//        }else if ([type  isEqualToString:@"8"]||[type  isEqualToString:@"9"]){
//            //医生待回答页面
//            AwaitAnswerViewController  *vc = [AwaitAnswerViewController new];
//            /**
//             *
//             uuid
//             answerType
//             Expert_ID
//             consultationContent
//             Image1
//             Image2、
//             Image3
//             createTime
//             hearCount
//             imageUrl
//             TraceID
//             doctorName
//             {"UUID":"1","answerType":"1","Expert_ID":"1","consultationContent":"888","Image1":"1","Image2":"1","Image3":"1","createTime":"2016/10/19 16:10:56","hearCount":"0","imageUrl":"http://121.42.15.43:9020/MobileHtml/images/zhaodongmei.jpg","doctorName":"赵冬梅","TraceID":"1"}
//             
//             */
//            vc.MyAnswerEntity = [MyAnserEntity mj_objectWithKeyValues:dic];
//            NSLog(@"消息页推送医生待回答：uuid%@-----专家id%d----追问id%d-----回答类型%d-----咨询内容%@-----图片1%@-----图片2%@-----图片3%@-----时间：%@-----听过次数%d-----头像url%@-----医生名字%@",vc.MyAnswerEntity.uuid,vc.MyAnswerEntity.Expert_ID,vc.MyAnswerEntity.TraceID,vc.MyAnswerEntity.answerType,vc.MyAnswerEntity.consultationContent,vc.MyAnswerEntity.Image1,vc.MyAnswerEntity.Image2,vc.MyAnswerEntity.Image3,vc.MyAnswerEntity.createTime,vc.MyAnswerEntity.hearCount,vc.MyAnswerEntity.imageUrl,vc.MyAnswerEntity.doctorName);
//
//            
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }else  if ([type  isEqualToString:@"10"]){
//            //每日必读详情页
//            DailyArticleViewController  *vc = [DailyArticleViewController new];
//            /**    DATA = "{\"ID\":\"39\",\"Title\":\"世界早产日活动\",\"Url\":\"http://www.zhongkang365.com/MobileHtml/everyday/childgm161110.html\",\"Photo\":\"http://tigerhuang007.xicp.io/MobileHtml/everyday/images/pic16926.png\",\"PraiseCount\":4,\"badgeID\":1624.0}";
//             TYPE = 10;
//             
//             */
//            vc.TodayRecommend = [TodayRecommend mj_objectWithKeyValues:dic];
//            NSLog(@"每日必读消息页不带导航栏推送：---%@-----%@-----%@-----%@-----%@",vc.TodayRecommend.ID,vc.TodayRecommend.Title,vc.TodayRecommend.Url,vc.TodayRecommend.Photo,vc.TodayRecommend.PraiseCount);
//
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//
//        
//    });
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"消息";
    _presenter = [ChatListPresenter new];
    _presenter.deleagte = self;
    [self setupTableView];
}
- (void)setupTableView{
    _chatListView = [UITableView new];
    _chatListView.delegate = self;
    _chatListView.dataSource = self;
    [_chatListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_chatListView];
//    _chatListView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _chatListView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight-64);
    WS(ws);
    _chatListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.presenter loadChatList:^(BOOL success, NSString *message) {
            if (success == YES) {
                //排序找到系统提示，排在第一条
                [ws sortArrayForSystemMessage];
                [ws.chatListView reloadData];
            }else{
                [ProgressUtil showError:message];
            }
            [ws.chatListView.mj_header endRefreshing];
        }];
    }];
//    _chatListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _chatListView.userInteractionEnabled = NO;
//        [ws.presenter GetChatList];
//    }];
//    [_chatListView.mj_header beginRefreshing];
    
}
#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _presenter.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_chatList";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.conversation = _presenter.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        Conversation *conversation = _presenter.dataSource[indexPath.row];
        WS(ws);
        [_presenter cancelCell:[conversation.RowID integerValue] complete:^(BOOL success, NSString *message) {
            if (success == YES) {
//                [ws.presenter.dataSource removeObject:conversation];
//                [ws.chatListView reloadData];
                [ws.chatListView.mj_header beginRefreshing];
            }else{
                [ProgressUtil showError:@"删除失败"];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *vc = [ChatViewController new];
    vc.conversation = _presenter.dataSource[indexPath.row];
//    [self.presenter isReadNoticeWithUuid:vc.conversation.RowID sysBlock:^(BOOL success) {
//        vc.conversation.IsRead = success;
//        [tableView reloadData];
//    }];
    vc.chatType = ChatTypeConversation;
//    [self.navigationController pushViewController:vc animated:YES];
    [self.delegate pushToVc:vc];
    
}

#pragma mark private
//数组排序，找到ID为-1的条目排在首位，其余位置不变
- (void)sortArrayForSystemMessage{
    Conversation *systemMessage;
    NSInteger index = -1;
    for (Conversation *conversation in _presenter.dataSource) {
        if ([conversation.row_number isEqual:@(-1)]) {
            systemMessage = conversation;
            index = [_presenter.dataSource indexOfObject:conversation];
        }
    }
    if (systemMessage && index != 0) {
        [_presenter.dataSource insertObject:systemMessage atIndex:0];
        [_presenter.dataSource removeObjectAtIndex:index+1];
    }
}
#pragma mark-- 网络delegate－－
//-(void)GetChatListCompletion:(BOOL)success info:(NSString *)message
//{
//    _chatListView.userInteractionEnabled = YES;
//    [_chatListView.mj_footer resetNoMoreData];
//    [_chatListView.mj_header endRefreshing];
//    if (success) {
//        
//        [self sortArrayForSystemMessage];
//        [self.chatListView reloadData];
//    }
//    
//    
//}
@end
