//
//  BaseViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "EventRemindViewController.h"
#import <RongIMKit/RongIMKit.h>
//推送进入相关页面头文件
#import "HotDetailConsulationViewController.h"      //问题详情
#import "HotDetailConsulationInfoViewController.h"  //问题评论回复
#import "PublicPostDetailViewController.h"   //帖子详情
#import "CommentDetailViewController.h"     //帖子评论回复
#import "ChatViewController.h"     //聊天页面
#import "RelatedAnswerViewController.h"  //医生待回答页面
#import "ReplyAnswerViewController.h"  //医生已回答页面
#import "DailyArticleViewController.h" //每日必读详情页



#import "ClearBadgePresenter.h"

#import "TodayRecommend.h"
#import "MyAnserEntity.h"
#import "PushPresenter.h"

@interface BaseViewController ()<PushPresenterDelegate>{

     NSNumber  *uuid;

}

@property (nonatomic, strong) ClearBadgePresenter *presenter;
@property (nonatomic, strong) PushPresenter *PushPresenter;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBackBarWithImage:[UIImage imageNamed:@"back_icon"]];
    [self setupView];
    }

-(void)setupView{
    
}

-(void)initBackBarWithImage:(UIImage *)image{
    _isHideTabbar = image != nil;
    if (image == nil) {
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:barItem,item1,nil];
        
    }
}

-(void)initLeftBarWithTitle:(NSString *)leftTitle{
    _isHideTabbar = leftTitle != nil;
    if (leftTitle == nil) {
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:[UIButton buttonWithType:UIButtonTypeCustom]];
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:barItem,item1,nil];
        
    }
}

-(void)initRightBarWithBarItem:(UIBarButtonItem*)item{
    if (item == nil) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        
        self.navigationItem.rightBarButtonItem = item;
    }
}

-(void)initRightBarWithTitle:(NSString *)leftTitle{
    
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    [self initRightBarWithBarItem:barItem];
}

-(void)initRightBarWithImage:(UIImage *)rightImage{
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    [self initRightBarWithBarItem:barItem];
}

-(void)initRightBarWithView:(UIView *)rightImage{
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    [rightImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightItemAction:)]];
    [self initRightBarWithBarItem:barItem];
}

-(void)rightItemAction:(id)sender{
    EventRemindViewController * vc = [EventRemindViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backItemAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)isCanDragBack{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:_isHideTabbar animated:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChatMsg:) name:@"getChatMsg" object:nil];
    

    [kdefaultCenter addObserver:self selector:@selector(PushGeTuiViewController:) name:Notification_PushGeTui object:nil];
    


}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getChatMsg" object:nil];
    
    [kdefaultCenter removeObserver:self name:Notification_PushGeTui object:nil];
//

}

-(void)getChatMsg:(NSNotification *)noti{


    dispatch_async(dispatch_get_main_queue(), ^{
        
        RCTextMessage * msg = (RCTextMessage*)noti.object;
    
        
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"新消息"
                                   message:msg.content
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil, nil];
        [alertView show];
        
        
    });
    

    

}
-(void)PushGeTuiViewController:(NSNotification *)noti{
    
    NSLog(@"由推送进入问题详情");
    dispatch_async(dispatch_get_main_queue(), ^{
        _presenter = [ClearBadgePresenter new];

        
        
        NSDictionary* userInfo = noti.userInfo;
        NSString  *type = [userInfo  objectForKey:@"TYPE"];
        
        NSString   *userString = [userInfo  objectForKey:@"DATA"];
        NSData  *data = [[NSData  alloc]initWithData:[userString  dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary  *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if ([type  isEqualToString:@"10"]) {
            
            
        }else if ([type  isEqualToString:@"8"]||[type  isEqualToString:@"9"]){
        
        uuid = [dic  objectForKey:@"uuid"];
        
        }else{
            
        uuid = [dic  objectForKey:@"UUID"];
                
        }
    NSNumber  *bageID = [dic  objectForKey:@"badgeID"];
[_presenter  ClearBadgeByBadgeID:[bageID  integerValue]
                          finish:^(BOOL success, NSString * _Nonnull message) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_presenter.badgeCount];//可用全局变量累加消息
       NSLog(@"角标111：%d",_presenter.badgeCount);
                          }];
        
        if ([type  isEqualToString:@"0"]||[type  isEqualToString:@"3"]
            ) {
            //问题详情
            NSLog(@"问题详情---%@",uuid);
            HotDetailConsulationViewController  *VC = [HotDetailConsulationViewController  new];
                    VC.UUID = uuid;
    [self.navigationController  pushViewController:VC animated:YES];
            
        }else if ([type  isEqualToString:@"1"]){
            //问题评论回复
            NSLog(@"问题评论回复---%@",uuid);
            HotDetailConsulationInfoViewController  *VC = [HotDetailConsulationInfoViewController  new];
            VC.commentID = uuid;
[self.navigationController  pushViewController:VC animated:YES];
            
        }else if ([type  isEqualToString:@"4"]){
            //帖子详情
            NSLog(@"帖子详情---%@",uuid);
            PublicPostDetailViewController  *VC = [PublicPostDetailViewController  new];
            VC.UUID = uuid;
[self.navigationController  pushViewController:VC animated:YES];
            
        }else if ([type  isEqualToString:@"7"]){
            //帖子评论回复
            NSLog(@"帖子评论回复---%@",uuid);
            CommentDetailViewController  *VC = [CommentDetailViewController  new];
            VC.commentID = uuid;
 [self.navigationController  pushViewController:VC animated:YES];           
        }else if ([type  isEqualToString:@"5"]){
            //消息
            /**
             *      DATA = "{\"UUID\":\"396\",\"ReceiveUserID\":\"4\",\"SendUserID \":\"19\",\"NickName\":\"洋洋\"}";
             */
            NSString  *NickName = [dic objectForKey:@"NickName"];
            NSNumber  *SendUserID = [dic objectForKey:@"SendUserID"];
            NSNumber  *ReceiveUserID = [dic objectForKey:@"ReceiveUserID"];

            ChatViewController *vc = [ChatViewController new];
            vc.RowID = uuid;
            vc.nickName = NickName;
            vc.ReceiveUserID =[ ReceiveUserID  integerValue];
            vc.SendUserID =  [SendUserID  integerValue];
            NSLog(@"消息推送---：%@----%@---%@----%@",uuid,NickName,ReceiveUserID,SendUserID);
            vc.chatType = ChatTypePush;
            [self.navigationController pushViewController:vc animated:YES];

        }else if ([type  isEqualToString:@"8"]||[type  isEqualToString:@"9"]){
//        //医生待回答页面  /  已回答页面

   
            _PushPresenter = [PushPresenter  new];
            _PushPresenter.delegate = self;
            [_PushPresenter  loadPushDoctorAnswerinfoWithType:[NSNumber  numberWithInteger:[type integerValue]] UUID:uuid];
            
            
            
    }else  if ([type  isEqualToString:@"10"]){
            //每日必读详情页
            DailyArticleViewController  *vc = [DailyArticleViewController new];
        /**        DATA = "{\"ID\":38,\"Title\":\"【史大夫微课堂】如何防治螨虫？\",\"Url\":\"http://tigerhuang007.xicp.io/MobileHtml/everyday/childgm16926.html\",\"Photo\":\"\",\"PraiseCount\":7,\"badgeID\":3406.0}";

             TYPE = 10;
             
             */
        vc.TodayRecommend = [TodayRecommend mj_objectWithKeyValues:dic];
        NSLog(@"每日必读带导航栏推送：---%@-----%@-----%@-----%@-----%@",vc.TodayRecommend.ID,vc.TodayRecommend.Title,vc.TodayRecommend.Url,vc.TodayRecommend.Photo,vc.TodayRecommend.PraiseCount);
     [self.navigationController pushViewController:vc animated:YES];
        }


    });
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"%@ ==== %@ is Dealloc", self.title, [[self class] description]);
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
