//
//  CircleViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CircleViewController.h"
#import "CirclePresenter.h"
#import "CircleMenuView.h"
#import "CircleTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "PhotoWallTableViewCell.h"
#import "SFPhotoBrowser.h"
#import "ApiMacro.h"
#import "AudioPhotoTableViewCell.h"
#import "AVRecorderPlayerManager.h"
#import "NSUserDefaults+Category.h"
#import "PublicPostViewController.h"
#import "ChatViewController.h"
#import "PublicPostDetailViewController.h"
#import "HEAParentQuestionEntity.h"
#import "HotDetailConsulationViewController.h"
#import "ScreenAppraiseController.h"
#import "DefaultChildEntity.h"
#import "PersonFileViewController.h"
#import "ArchivesMainViewController.h"
#import "HRHealthAssessmentViewController.h"
#import "DiscoverViewController.h"
#import "HotDetailPresenter.h"
#import "HealthTeachViewController.h"

@interface CircleViewController ()<CirclePresenterDelegate,UITableViewDelegate,UITableViewDataSource,CircleTableViewCellDelegate,PhotoBrowerDelegate,UIActionSheetDelegate>{
    BOOL isUpdateHeaderHeight;
    CGFloat currentOffsetY;
}

@property(nullable,nonatomic,retain) CirclePresenter* presenter;
@property(nullable,nonatomic,retain) UITableView* table;
@property(nullable,nonatomic,retain) NSArray* photoWallDataSource;
@property(nullable,nonatomic,retain) NSArray<NSString* >* photoWallURL;
@property(nonatomic,retain) NSMutableDictionary* stateDic;//语音按钮状态字典
@property(nullable,nonatomic,retain) NSIndexPath* currentIndexPath;
@property(nullable,nonatomic,retain) UIView* tableHeaderView;



@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHideTabbar = NO;
    [self initBackBarWithImage:nil];
    [self initRightBarWithImage:[UIImage imageNamed:@"circle_publish"]];
    
    [kdefaultCenter addObserver:self selector:@selector(refreshCircleList) name:Notification_RefreshCircleList object:nil];
//    [kdefaultCenter addObserver:self selector:@selector(refreshSingle:) name:Notification_RefreshCircleSingle object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
        NSLog(@"停止播放");
        [[AVRecorderPlayerManager sharedManager] pause];
        [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
        [self.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

}

#pragma mark - 子视图
-(void)setupView{
    self.title = @"圈子";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    [_table registerClass:[CircleTableViewCell class] forCellReuseIdentifier:@"circle"];
//    [_table registerClass:[PhotoWallTableViewCell class] forCellReuseIdentifier:@"photo"];
    [_table registerClass:[AudioPhotoTableViewCell class] forCellReuseIdentifier:@"audioPhoto"];
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    WS(ws);
    //下拉刷新
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.table.userInteractionEnabled = NO;
        [ws.presenter loadCircleData];
    }];
    [_table.mj_header beginRefreshing];
    //上拉加载
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.table.userInteractionEnabled = NO;
        
        [ws.presenter loadMoreCircleData];
    }];
    

}
#pragma mark---移除tableview的头视图
/*
- (void)setupTableHeaderView{
    
    UIView* headerView = [UIView new];
    headerView.backgroundColor = UIColorFromRGB(0xf5fffe);
    
    //查看报告
    CircleMenuView* report = [CircleMenuView new];
    report.menuImage = @"circle_ckbg_icon";
    report.menuTitle = @"查看报告";
    report.tag = 101;
    report.menuTitleColor = UIColorFromRGB(0x666666);
    
//    //基本信息
//    CircleMenuView* infomation = [CircleMenuView new];
//    infomation.menuImage = @"circle_jbxx_icon";
//    infomation.menuTitle = @"基本信息";
//    infomation.tag = 102;
//    infomation.menuTitleColor = UIColorFromRGB(0x666666);
    
    //测评结果
    CircleMenuView* testResult = [CircleMenuView new];
    testResult.menuImage = @"circle_cpjg_icon";
    testResult.menuTitle = @"测评结果";
    testResult.tag = 103;
    testResult.menuTitleColor = UIColorFromRGB(0x666666);
    
    //宝宝日记
    CircleMenuView* diary = [CircleMenuView new];
    diary.menuImage = @"circle_bbrj_icon";
    diary.menuTitle = @"宝宝日记";
    diary.tag = 104;
    diary.menuTitleColor = UIColorFromRGB(0x666666);
    
    //健康教育
    CircleMenuView* education = [CircleMenuView new];
    education.menuImage = @"circle_education_icon";
    education.menuTitle = @"健康教育";
    education.tag = 102;
    education.menuTitleColor = UIColorFromRGB(0x666666);
    
    [headerView sd_addSubviews:@[report,education,testResult,diary]];
    
    CGFloat width = 110/2.0;
    CGFloat height = 128/2.0;
    CGFloat count = 4;
    CGFloat marginSpace = (kScreenWidth - (width*count))* 1.0 /(count + 1);
    
    report.sd_layout.topSpaceToView(headerView,15/2.0).leftSpaceToView(headerView,marginSpace).heightIs(height).widthIs(width);
    
//    infomation.sd_layout.topEqualToView(report).leftSpaceToView(report,marginSpace).heightRatioToView(report,1).widthRatioToView(report,1);
    education.sd_layout.topEqualToView(report).leftSpaceToView(report,marginSpace).heightRatioToView(report,1).widthRatioToView(report,1);
    testResult.sd_layout.topEqualToView(report).leftSpaceToView(education,marginSpace).heightRatioToView(report,1).widthRatioToView(report,1);
    diary.sd_layout.topEqualToView(report).leftSpaceToView(testResult,marginSpace).heightRatioToView(report,1).widthRatioToView(report,1);
    
    
    [headerView setupAutoHeightWithBottomViewsArray:@[report,education,testResult,diary] bottomMargin:5];
    
    [headerView layoutSubviews];

    
    _table.tableHeaderView = headerView;
    
    
    //添加手势
    UITapGestureRecognizer* reportGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    [report addGestureRecognizer:reportGesture];
//    UITapGestureRecognizer* informationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
//    [infomation addGestureRecognizer:informationGesture];
    UITapGestureRecognizer* testResultGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    [testResult addGestureRecognizer:testResultGesture];
    UITapGestureRecognizer* dirayGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    [diary addGestureRecognizer:dirayGeture];
    UITapGestureRecognizer* eduGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    [education addGestureRecognizer:eduGeture];

}
*/
#pragma mark---移除tableview的头视图的点击效果
/*
 #pragma mark * 手势点击事件
 - (void)clickGestureAciton:(UITapGestureRecognizer*) tap{
 CircleMenuView* menuView = (CircleMenuView*)tap.view;
 NSInteger menuIndex = menuView.tag;
 switch (menuIndex) {
 case 101:{
 NSLog(@"查看报告");
 NSArray *entityArray = [DefaultChildEntity MR_findAll];
 if (entityArray.count > 0) {
 DefaultChildEntity *entity = entityArray.lastObject;
 if ([entity.babyID intValue] != 0) {
 [self.navigationController pushViewController:[HRHealthAssessmentViewController new] animated:YES];
 }else{
 [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
 }
 }else{
 [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
 }
 }
 break;
 case 102:{
 //健康服务
 NSLog(@"健康教育");
 [self.navigationController pushViewController:[HealthTeachViewController new] animated:YES];
 }
 break;
 //        case 102:{
 //            NSLog(@"基本信息");
 //            NSArray *entityArray = [DefaultChildEntity MR_findAll];
 //            if (entityArray.count > 0) {
 //                DefaultChildEntity *entity = entityArray.lastObject;
 //                NSLog(@"=====%@",entity.babyID);
 //                if ([entity.babyID intValue] != 0) {
 //                    [self.navigationController pushViewController:[PersonFileViewController new] animated:YES];
 //
 //                }else{
 //                    [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
 //                }
 //            }else{
 //                [self.navigationController pushViewController:[[ArchivesMainViewController alloc] init] animated:YES];
 //            }
 //
 //        }
 //            break;
 case 103:{
 NSLog(@"点击测评结果");
 [self.navigationController pushViewController:[ScreenAppraiseController new] animated:YES];
 }
 break;
 case 104:{
 NSLog(@"宝贝日记");
 [self.navigationController pushViewController:[DiscoverViewController new] animated:YES];
 }
 break;
 
 }
 
 
 }
 */


#pragma mark---移除tableview的头视图的高度
/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    //    return 248 / 2.0;
    return 155 / 2.0;
}
*/

/*
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* headerView = [UIView new];
    headerView.backgroundColor = UIColorFromRGB(0xf5fffe);
    self.tableHeaderView = headerView;
    //    headerView.backgroundColor = [UIColor redColor];
    //查看报告
    CircleMenuView* report = [CircleMenuView new];
    report.menuImage = @"circle_ckbg_icon";
    report.menuTitle = @"查看报告";
    report.tag = 101;
    report.menuTitleColor = UIColorFromRGB(0x666666);
    
    //    //基本信息
    //    CircleMenuView* infomation = [CircleMenuView new];
    //    infomation.menuImage = @"circle_jbxx_icon";
    //    infomation.menuTitle = @"基本信息";
    //    infomation.tag = 102;
    //    infomation.menuTitleColor = UIColorFromRGB(0x666666);
    
    //测评结果
    CircleMenuView* testResult = [CircleMenuView new];
    testResult.menuImage = @"circle_cpjg_icon";
    testResult.menuTitle = @"测评结果";
    testResult.tag = 103;
    testResult.menuTitleColor = UIColorFromRGB(0x666666);
    
    //宝宝日记
    CircleMenuView* diary = [CircleMenuView new];
    diary.menuImage = @"circle_bbrj_icon";
    diary.menuTitle = @"宝宝日记";
    diary.tag = 104;
    diary.menuTitleColor = UIColorFromRGB(0x666666);
    
    //宝宝日记
    CircleMenuView* education = [CircleMenuView new];
    education.menuImage = @"circle_education_icon";
    education.menuTitle = @"健康教育";
    education.tag = 102;
    education.menuTitleColor = UIColorFromRGB(0x666666);
    
    [headerView sd_addSubviews:@[report,education,testResult,diary]];
    
    CGFloat width = 110/2.0;
    CGFloat height = 128/2.0;
    CGFloat count = 4;
    CGFloat marginSpace = (kScreenWidth - (width*count))* 1.0 /(count + 1);
    
    report.sd_layout.topSpaceToView(headerView,15/2.0).leftSpaceToView(headerView,marginSpace).heightIs(height).widthIs(width);
    //    infomation.sd_layout.topEqualToView(report).leftSpaceToView(report,marginSpace).heightRatioToView(report,1).widthRatioToView(report,1);
    education.sd_layout.topEqualToView(report).leftSpaceToView(report,marginSpace).heightRatioToView(report,1).widthRatioToView(report,1);
    
    testResult.sd_layout.topEqualToView(report).leftSpaceToView(education,marginSpace).heightRatioToView(report,1).widthRatioToView(report,1);
    diary.sd_layout.topEqualToView(report).leftSpaceToView(testResult,marginSpace).heightRatioToView(report,1).widthRatioToView(report,1);
    
    [headerView setupAutoHeightWithBottomViewsArray:@[report,education,testResult,diary] bottomMargin:5];
    
    //添加手势
    UITapGestureRecognizer* reportGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    [report addGestureRecognizer:reportGesture];
    //    UITapGestureRecognizer* informationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    //    [infomation addGestureRecognizer:informationGesture];
    UITapGestureRecognizer* testResultGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    [testResult addGestureRecognizer:testResultGesture];
    UITapGestureRecognizer* dirayGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    [diary addGestureRecognizer:dirayGeture];
    UITapGestureRecognizer* eduGeture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGestureAciton:)];
    [education addGestureRecognizer:eduGeture];
    
    return headerView;
}



#pragma mark * scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if(scrollView.contentOffset.y <= 0) return;
    
    CGFloat minusY = scrollView.contentOffset.y -currentOffsetY;
    
    if(minusY > 0){
        //向上拉
        if(minusY > 160/2.0){
            
            [UIView animateWithDuration:.2f animations:^{
                self.tableHeaderView.hidden = YES;
            }];
            
            currentOffsetY = scrollView.contentOffset.y;
        }
    }else{
        //向下拉
        
        if(abs((int)minusY) > 20){
            [UIView animateWithDuration:.2f animations:^{
                self.tableHeaderView.hidden = NO;
            }];
            currentOffsetY = scrollView.contentOffset.y;
        }
        
    }
}
*/

#pragma mark - 点击事件
-(void)rightItemAction:(id)sender{
    [self.navigationController pushViewController:[PublicPostViewController new] animated:YES];
}
#pragma mark - 监听通知回调
- (void)refreshCircleList{
    [_table.mj_header beginRefreshing];
}
#pragma mark - 代理
#pragma mark * tableView代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.presenter.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //语音 ＋ 图片 cell
    AudioPhotoTableViewCell* audioPhotoCell = [tableView dequeueReusableCellWithIdentifier:@"audioPhoto"];
    if(!audioPhotoCell.delegate){
        audioPhotoCell.delegate = self;
    }
    //语音 cell
    CircleTableViewCell* circleCell = [tableView dequeueReusableCellWithIdentifier:@"circle"];
    if(!circleCell.delegate){
        circleCell.delegate = self;
    }
    //文字 + 图片 cell
    static NSString *cellID0 = @"cell0";
    static NSString *cellID1 = @"cell1";
    static NSString *cellID2 = @"cell2";
    static NSString *cellID3 = @"cell3";
    static NSString *cellID4 = @"cell4";
    static NSString *cellID5 = @"cell5";
    static NSString *cellID6 = @"cell6";
    
//    PhotoWallTableViewCell* photoCell = [tableView dequeueReusableCellWithIdentifier:@"photo"];
    PhotoWallTableViewCell* photoCell ;
    if(!photoCell.delegate){
        photoCell.delegate = self;
    }

    if(indexPath.row < self.presenter.dataSource.count){

        CircleEntity* circleEntity = self.presenter.dataSource[indexPath.row];

        if(circleEntity.consultationType == 1){
            //语音咨询
            NSNumber* isSelect = (NSNumber*)[self.stateDic objectForKey:@(indexPath.row)];

            if(circleEntity.isOpenImage && [circleEntity.isOpenImage boolValue]){
                //语音＋图片
                audioPhotoCell.circleEntity = circleEntity;
                if(isSelect) audioPhotoCell.voicebtIsSelect = [isSelect intValue];
                
                audioPhotoCell.sd_indexPath = indexPath;
                audioPhotoCell.sd_tableView = tableView;
                return audioPhotoCell;
            }else{
                //只有语音
                circleCell.circleEntity = circleEntity;
                if(isSelect) circleCell.voicebtIsSelect = [isSelect intValue];
                
                circleCell.sd_indexPath = indexPath;
                circleCell.sd_tableView = tableView;
                return circleCell;
            }
        }else{
            //文字 + 图片
            
            if ((circleEntity.image1==nil)|[circleEntity.image1 isEqualToString:@""]) {
                
                photoCell = [tableView dequeueReusableCellWithIdentifier:cellID0];
                
                if (photoCell==nil) {
                    photoCell = [[PhotoWallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0];
                    photoCell.delegate = self;
                }
                
                CircleEntity* circleEntity = self.presenter.dataSource[indexPath.row];
                
                photoCell.circleEntity =circleEntity;
                
//                photoCell.haveImageBgView.sd_layout.widthIs(0).heightIs(0);
                
                
            }else {
                
                if ((circleEntity.image1!=nil&&circleEntity.image1.length!=0)&&((circleEntity.image2==nil)|[circleEntity.image2 isEqualToString:@""])&&((circleEntity.image3==nil)|[circleEntity.image3 isEqualToString:@""])&&((circleEntity.image4==nil)|[circleEntity.image4 isEqualToString:@""])&&((circleEntity.image5==nil)|[circleEntity.image5 isEqualToString:@""])&&((circleEntity.image6==nil)|[circleEntity.image6 isEqualToString:@""])) {
                    
                    photoCell = [tableView dequeueReusableCellWithIdentifier:cellID1];
                    photoCell.delegate = self;
                    
                    if (photoCell==nil) {
                        photoCell = [[PhotoWallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
                        photoCell.delegate = self;
                    }
                    CircleEntity* circleEntity = self.presenter.dataSource[indexPath.row];
                    
                    photoCell.circleEntity =circleEntity;
                    
                }else if ((circleEntity.image2!=nil&&circleEntity.image2.length!=0)&&((circleEntity.image3==nil)|[circleEntity.image3 isEqualToString:@""])&&((circleEntity.image4==nil)|[circleEntity.image4 isEqualToString:@""])&&((circleEntity.image5==nil)|[circleEntity.image5 isEqualToString:@""])&&((circleEntity.image6==nil)|[circleEntity.image6 isEqualToString:@""])){
                    
                    photoCell = [tableView dequeueReusableCellWithIdentifier:cellID2];
                    photoCell.delegate = self;
                    
                    if (photoCell==nil) {
                        photoCell = [[PhotoWallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                        photoCell.delegate = self;
                    }
                    CircleEntity* circleEntity = self.presenter.dataSource[indexPath.row];
                    
                    photoCell.circleEntity =circleEntity;
                }else if ((circleEntity.image3!=nil&&circleEntity.image3.length!=0)&&((circleEntity.image4==nil)|[circleEntity.image4 isEqualToString:@""])&&((circleEntity.image5==nil)|[circleEntity.image5 isEqualToString:@""])&&((circleEntity.image6==nil)|[circleEntity.image6 isEqualToString:@""])){
                    
                    photoCell = [tableView dequeueReusableCellWithIdentifier:cellID3];
                    photoCell.delegate = self;
                    
                    if (photoCell==nil) {
                        photoCell = [[PhotoWallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                        photoCell.delegate = self;
                    }
                    CircleEntity* circleEntity = self.presenter.dataSource[indexPath.row];
                    
                    photoCell.circleEntity =circleEntity;
                    
                }else if ((circleEntity.image4!=nil&&circleEntity.image4.length!=0)&&((circleEntity.image5==nil)|[circleEntity.image5 isEqualToString:@""])&&((circleEntity.image6==nil)|[circleEntity.image6 isEqualToString:@""])){
                    photoCell = [tableView dequeueReusableCellWithIdentifier:cellID4];
                    photoCell.delegate = self;
                    
                    if (photoCell==nil) {
                        photoCell = [[PhotoWallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4];
                        photoCell.delegate = self;
                    }
                    CircleEntity* circleEntity = self.presenter.dataSource[indexPath.row];
                    
                    photoCell.circleEntity =circleEntity;
                    
                }else if ((circleEntity.image5!=nil&&circleEntity.image5.length!=0)&&((circleEntity.image6==nil)|[circleEntity.image6 isEqualToString:@""])){
                    
                    photoCell = [tableView dequeueReusableCellWithIdentifier:cellID5];
                    photoCell.delegate = self;
                    
                    if (photoCell==nil) {
                        photoCell = [[PhotoWallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID5];
                        photoCell.delegate = self;
                    }
                    CircleEntity* circleEntity = self.presenter.dataSource[indexPath.row];
                    
                    photoCell.circleEntity =circleEntity;
                }else{
                    photoCell = [tableView dequeueReusableCellWithIdentifier:cellID6];
                    photoCell.delegate = self;
                    
                    if (photoCell==nil) {
                        photoCell = [[PhotoWallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID6];
                        photoCell.delegate = self;
                    }
                    CircleEntity* circleEntity = self.presenter.dataSource[indexPath.row];
                    
                    photoCell.circleEntity =circleEntity;
                    
                }
                
            }
            
            photoCell.circleEntity = circleEntity;
            photoCell.sd_indexPath = indexPath;
            photoCell.sd_tableView = tableView;
            return photoCell;
        }
        
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleEntity* circleEntity = [self.presenter.dataSource objectAtIndex:indexPath.row];
    
    if(circleEntity.consultationType == 1){
        if(circleEntity.isOpenImage && [circleEntity.isOpenImage boolValue]){
            return [_table cellHeightForIndexPath:indexPath model:circleEntity keyPath:@"circleEntity" cellClass:[AudioPhotoTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        }else{
            return [_table cellHeightForIndexPath:indexPath model:circleEntity keyPath:@"circleEntity" cellClass:[CircleTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        }
    }else{
        return [_table cellHeightForIndexPath:indexPath model:circleEntity keyPath:@"circleEntity" cellClass:[PhotoWallTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[PhotoWallTableViewCell class]]){
        //发帖
        PublicPostDetailViewController* detail = [PublicPostDetailViewController new];
        detail.UUID = [self.presenter.dataSource objectAtIndex:indexPath.row].uuid;
        NSInteger userid = [self.presenter.dataSource objectAtIndex:indexPath.row].userID;
        detail.usrId = userid;
        detail.PublicPostDetailViewControllerBlock  = ^(BOOL isdelete){
            
            if (isdelete == YES) {
                
            [self.presenter.dataSource removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [tableView reloadData];
                
            }
        };
        
//        detail.selectNumber = @(indexPath.row);
        [self.navigationController pushViewController:detail animated:YES];
    }else{
    CircleEntity* circleEntity =  [self.presenter.dataSource objectAtIndex:indexPath.row];
    HEAParentQuestionEntity* question = [CircleEntity convertCircleEntityToHEAParentQuestionEntity:circleEntity];
        HotDetailConsulationViewController  *vc = [HotDetailConsulationViewController  new];
        vc.UUID =[NSNumber  numberWithInteger:question.uuID];
//        vc.row = [NSNumber numberWithInteger:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark * 下拉刷新和上拉加载
-(void)loadCompleteWith:(BOOL)success info:(NSString *)message{
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    _table.userInteractionEnabled = YES;

    if(success){
        [ProgressUtil dismiss];
        [_table reloadData];
    }else{
        [ProgressUtil showError:message];
    }
}
-(void)loadMoreCompleteWith:(BOOL)success info:(NSString *)message{
    
    self.presenter.noMoreData? [self.table.mj_footer endRefreshingWithNoMoreData]: [self.table.mj_footer endRefreshing];
    self.table.userInteractionEnabled = YES;
    
    if(success){
        [self.table reloadData];
    }else{
        [ProgressUtil showError:message];
    }

}

#pragma mark * 监听点击用户头像
-(void)clickBabyIconWithCircleEntity:(CircleEntity *)circleEntity{
//    NSLog(@"点击了用户头像－－%ld",(long)circleEntity.userID);
    if ((long)circleEntity.userID == kCurrentUser.userId) {
        [ProgressUtil showError:@"不能与自己私聊"];
        return;
    }
    ChatViewController *vc = [ChatViewController new];
    vc.chatType = ChatTypeSingal;
    vc.ReceiveUserID = circleEntity.userID;
    vc.nickName = circleEntity.nickName;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark * 监听点击了照片墙
-(void)clickPhotoWallWithCircleEntity:(CircleEntity *)circleEntity currentPhoto:(UIImageView *)imageView photoDataSource:(NSArray<UIImageView *> *)photoDataSource photoURLDataSource:(NSArray<NSString *> * _Nonnull)photoURL{
    
    NSInteger photoIndex = imageView.tag - 201;
    
    
    self.photoWallDataSource = photoDataSource;
    self.photoWallURL = photoURL;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    [SFPhotoBrowser showImageInView:window selectImageIndex:photoIndex delegate:self];
    
}
#pragma mark * 照片墙浏览代理
-(NSUInteger)numberOfPhotosInPhotoBrowser:(SFPhotoBrowser *)photoBrowser{
    return self.photoWallDataSource.count;
}
-(SFPhoto *)photoBrowser:(SFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    SFPhoto* sfPhoto = [SFPhoto new];
    
    //原图
    sfPhoto.srcImageView = self.photoWallDataSource[index];
    
    //缩略图片的url
    NSString *imgUrl = self.photoWallURL[index];
    if(imgUrl && imgUrl.length != 0){
        sfPhoto.url = [NSURL URLWithString:imgUrl];
    }

    
    return sfPhoto;
}
#pragma mark * 点击语音按钮代理
-(void)clickAudioButton:(UIButton *)voiceBt circleEntity:(CircleEntity *)circleEntity currentCell:(UITableViewCell *)currentCell{
    NSIndexPath* currentIndexPath = [self.table indexPathForCell:currentCell];
    
    self.presenter.circleEntity = circleEntity;
    
    //未回答
    if(!circleEntity.voiceUrl || circleEntity.voiceUrl.length == 0){
        [ProgressUtil showInfo:@"请等待医生回答!"];
        return ;
    }
    
    //限时免费
    if(circleEntity.isFree && [circleEntity.isFree intValue] == 1){
        
        NSArray* result = [circleEntity.voiceUrl componentsSeparatedByString:@"/"];
        if([NSString fileIsExist:[result lastObject]]){
            //音频文件存在，说明之前偷听过了，补血药走接口了，直接播放，这样主要是为了优化体验
            //播放
            NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
            if(!voiceBt.selected){
                [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
                    NSLog(@"播放完成");
                    [self.stateDic setObject:@0 forKey:@(currentIndexPath.row)];
                    [self.table reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    player = nil;
                }];
            }
            
            if(self.currentIndexPath && [self.currentIndexPath isEqual:currentIndexPath]){
                //点击了同一个cell
                NSLog(@"点击同一个cell");
                if(voiceBt.selected){
                    [[AVRecorderPlayerManager sharedManager] pause];
                    [self.stateDic setObject:@0 forKey:@(currentIndexPath.row)];
                }else{
                    [self.stateDic setObject:@1 forKey:@(currentIndexPath.row)];
                }
                [self.table reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //点击了不同cell
                [self.stateDic setObject:@1 forKey:@(currentIndexPath.row)];
                [self.table reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                NSLog(@"点击了不同cell");
                if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
                    //清除上次按钮选中状态，暂停上次播放语音
                    NSLog(@"清除上次按钮选中状态");
                    [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                    [self.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            self.currentIndexPath = currentIndexPath;


            
        }else{
            
            if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
                //清除上次按钮选中状态，暂停上次播放语音
                NSLog(@"清除上次按钮选中状态");
                [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                [self.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }

            
            self.currentIndexPath = currentIndexPath;
            
            //判断之前有没有支付成功，但是插入偷听表失败
            NSNumber* consultationUUID = [kDefaultsUser readValueForKey:[NSString stringWithFormat:@"UUID%@",circleEntity.uuid]];
            
            if(consultationUUID && [consultationUUID boolValue]){
                
                NSString* insertListenKeyPath = [NSString stringWithFormat:@"insertListen%@",circleEntity.uuid];
                
                if([kDefaultsUser readValueForKey:insertListenKeyPath]){
                    //处理插入订单表失败
                    NSString* orderID = [kDefaultsUser readValueForKey:insertListenKeyPath];
                    if(orderID && orderID.length != 0){
                        [ProgressUtil show];
                        [self.presenter insertListenQuestion:circleEntity price:0 orderID:orderID];
                    }
                }
            }else{
                //限时免费,走添加偷听表接口
                [ProgressUtil show];
                [self.presenter insertListenQuestion:circleEntity price:0 orderID:@"0"];
            }

        }

        return ;
    }

    //播放音频
    if(circleEntity.isListen && [circleEntity.isListen intValue] == 1){
        NSArray* result = [circleEntity.voiceUrl componentsSeparatedByString:@"/"];
        if([NSString fileIsExist:[result lastObject]]){
            //播放
            NSURL* audioURL = [NSString getAudioURL:[result lastObject]];
            if(!voiceBt.selected){
                [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
                    NSLog(@"播放完成");
                    [self.stateDic setObject:@0 forKey:@(currentIndexPath.row)];
                    [self.table reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    player = nil;
                }];
            }
            
            if(self.currentIndexPath && [self.currentIndexPath isEqual:currentIndexPath]){
                //点击了同一个cell
                NSLog(@"点击同一个cell");
                if(voiceBt.selected){
                    [[AVRecorderPlayerManager sharedManager] pause];
                    [self.stateDic setObject:@0 forKey:@(currentIndexPath.row)];
                }else{
                    [self.stateDic setObject:@1 forKey:@(currentIndexPath.row)];
                }
                [self.table reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                //点击了不同cell
                [self.stateDic setObject:@1 forKey:@(currentIndexPath.row)];
                [self.table reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                NSLog(@"点击了不同cell");
                if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
                    //清除上次按钮选中状态，暂停上次播放语音
                    NSLog(@"清除上次按钮选中状态");
                    [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                    [self.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            self.currentIndexPath = currentIndexPath;
            
        }else{
            //语音文件不存在，下载文件，下载前判断有没有其他语音正在播放，有就停止播放
            NSLog(@"开始下载文件");
            if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
                [[AVRecorderPlayerManager sharedManager] pause];
                [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
                [self.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            self.currentIndexPath = currentIndexPath;
            [ProgressUtil show];
            [self.presenter downloadAudioFile:circleEntity.voiceUrl];
        }
    }else{
        //一元旁听
        
        if(self.currentIndexPath && [(NSNumber*)[self.stateDic objectForKey:@(self.currentIndexPath.row)] intValue] == 1){
            //清除上次按钮选中状态，暂停上次播放语音
            NSLog(@"清除上次按钮选中状态");
            [self.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
            [self.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }

        
        self.currentIndexPath = currentIndexPath;
        //判断之前有没有支付成功，但是插入偷听表失败

        NSNumber* consultationUUID = [kDefaultsUser readValueForKey:[NSString stringWithFormat:@"UUID%@",circleEntity.uuid]];
        
        if(consultationUUID && [consultationUUID boolValue]){
            self.presenter.payPrice = 1;//偷听价格
            
            NSString* paySuccessKeyPath = [NSString stringWithFormat:@"paySuccess%@",circleEntity.uuid];
            NSString* insertListenKeyPath = [NSString stringWithFormat:@"insertListen%@",circleEntity.uuid];
            
            if([kDefaultsUser readValueForKey:paySuccessKeyPath]){
                //处理支付成功，但是走订单支付成功接口失败
                NSString* orderID = [kDefaultsUser readValueForKey:paySuccessKeyPath];
                if(orderID && orderID.length != 0){
                    [ProgressUtil show];
                    [self.presenter paySuccessWithOrderID:orderID];
                }
            }else if([kDefaultsUser readValueForKey:insertListenKeyPath]){
                //处理插入订单表失败
                NSString* orderID = [kDefaultsUser readValueForKey:insertListenKeyPath];
                if(orderID && orderID.length != 0){
                    [ProgressUtil show];
                    [self.presenter insertListenQuestion:circleEntity price:self.presenter.payPrice orderID:orderID];
                }

            }
        }else{
            //选择支付方式
            UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
            [sheet showInView:self.view];

        }
    }
}
#pragma mark * ActionSheet代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        //支付宝
        NSLog(@"支付宝");
        [ProgressUtil show];
        [self.presenter payWithListenPrice:1 payType:@"alipay"];
        
    }else if(buttonIndex == 1){
        //微信
        NSLog(@"微信");
        [ProgressUtil show];
        [self.presenter wxpayWithConsultationID:self.presenter.circleEntity.uuid price:1 type:@"listenBiz"];
        
    }else if(buttonIndex == 2){
        //取消
        NSLog(@"取消");
    }


}
#pragma mark * 偷听付款完成代理
-(void)payCompleteWithAudioURL:(NSURL *)audioURL{
    
    //支付成功以后，改变按钮的选中状态
    self.presenter.circleEntity.isListen = @1;
    [self.stateDic setObject:@1 forKey:@(self.currentIndexPath.row)];
    [self.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];

    WS(ws);
    //播放音频
    [[AVRecorderPlayerManager sharedManager] playerAudio:audioURL completionHandler:^(AVAudioPlayer *player) {
        NSLog(@"播放完成");
        [ws.stateDic setObject:@0 forKey:@(self.currentIndexPath.row)];
        [ws.table reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
//        [ws.table reloadData];
        player = nil;
    }];

}

#pragma mark * 赞
- (void)praiseAtIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
    NSLog(@"点赞");
    HotDetailPresenter *presenter = [HotDetailPresenter new];
    presenter.praiseType = type;
    NSString *consulationID = [NSString stringWithFormat:@"%@",((CircleEntity *)self.presenter.dataSource[indexPath.row]).uuid];
    NSInteger count = [((CircleEntity *)self.presenter.dataSource[indexPath.row]).praiseCount integerValue];
    WS(ws);
    [presenter praise:consulationID success:^(BOOL success, NSString *message) {
        if (success == YES) {
            ((CircleEntity *)ws.presenter.dataSource[indexPath.row]).isPraise = [NSNumber numberWithInteger:1];
            ((CircleEntity *)ws.presenter.dataSource[indexPath.row]).praiseCount = [NSNumber numberWithInteger:count+1];
            [ws.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
             kCurrentUser.hotIsNeedReload = NO;
        }else{
            [ProgressUtil showError:@"点赞失败"];
        }
    }];
}
- (void)cancelPraiseAtIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
    NSLog(@"取消点赞");
    HotDetailPresenter *presenter = [HotDetailPresenter new];
    presenter.praiseType = type;
    NSString *consulationID = [NSString stringWithFormat:@"%@",((CircleEntity *)self.presenter.dataSource[indexPath.row]).uuid];
    NSInteger count = [((CircleEntity *)self.presenter.dataSource[indexPath.row]).praiseCount integerValue];
    WS(ws);
    [presenter cancelPraise:consulationID success:^(BOOL success, NSString *message) {
        if (success == YES) {
            ((CircleEntity *)ws.presenter.dataSource[indexPath.row]).isPraise = [NSNumber numberWithInteger:0];
            ((CircleEntity *)ws.presenter.dataSource[indexPath.row]).praiseCount = [NSNumber numberWithInteger:count-1];
            [ws.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            kCurrentUser.hotIsNeedReload = NO;
        }else{
            [ProgressUtil showError:@"取消点赞失败"];
        }
    }];
}



#pragma mark - 懒加载
-(CirclePresenter *)presenter{
    if(!_presenter){
        _presenter = [CirclePresenter new];
        _presenter.delegate = self;
    }
    return _presenter;
}
-(NSMutableDictionary *)stateDic{
    if(!_stateDic){
        _stateDic = [NSMutableDictionary dictionary];
    }
    return _stateDic;
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

#pragma mark - dealloc
-(void)dealloc{
    [kdefaultCenter removeObserver:self name:Notification_RefreshCircleList object:nil];
//    [kdefaultCenter removeObserver:self name:Notification_RefreshCircleSingle object:nil];
}





@end
