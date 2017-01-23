//
//  DailyArticleMoreViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/10/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DailyArticleMoreViewController.h"
#import "DailyArticleMorePresenter.h"
#import "DailyFirstArticle.h"
#import "DailyArticleMoreTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "JMFoundation.h"
#import "DailyArticleViewController.h"

@interface DailyArticleMoreViewController()<DailyArticleMorePresenterDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSInteger  PraiseIndex;

}

@property(nonatomic,retain) UITableView* table;
@property(nonatomic,strong)DailyArticleMorePresenter*presenter;
@property(nonatomic,strong)UIButton  *starButton;

@end

@implementation DailyArticleMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"往期文章";
    
        [kdefaultCenter addObserver:self selector:@selector(refreshDailyArticleMoreList) name:Notification_RefreshDailyArticleMore object:nil];
}
-(void)setupView{

    _presenter = [DailyArticleMorePresenter  new];
    _presenter.delegate = self;

    UITableView  *table = [UITableView  new];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[DailyArticleMoreTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view  addSubview:table];
    self.table = table;
    table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    
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

#pragma mark -tableview 代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.presenter.dataSource.count;
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    DailyArticleMoreTableViewCell* cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.DailyArticle = [self.presenter.dataSource  objectAtIndex:indexPath.row];
    
    [cell.DailyPraiseCountBt  addTarget:self action:@selector(PraiseCountClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.DailyPraiseCountBt.tag = indexPath.row;
    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    return cell;
 
    
   }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    DailyArticleViewController  *vc = [DailyArticleViewController  new];
    DailyFirstArticle  *model = [self.presenter.dataSource  objectAtIndex:indexPath.row];
//    vc.DailyFirstArticle = model;
    [self.navigationController  pushViewController:vc animated:YES];
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DailyFirstArticle *DailyFirstmodel = [self.presenter.dataSource   objectAtIndex:indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:DailyFirstmodel keyPath:@"DailyArticle" cellClass:[DailyArticleMoreTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}
#pragma mark----网络请求回调
-(void)GetDailyArticleListCompletion:(BOOL)success info:(NSString *)messsage{
    _table.userInteractionEnabled = YES;
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    
    
    if(success){
        [_table reloadData];
        
    }else{
        
    }
}

-(void)GetDailyArticleMoreListCompletion:(BOOL)success info:(NSString *)message{
    
    _table.userInteractionEnabled = YES;
    
    self.presenter.noMoreData? [_table.mj_footer endRefreshingWithNoMoreData]: [_table.mj_footer endRefreshing];
    
    if(success){
        [_table reloadData];
        
    }else{
        [ProgressUtil showError:message];
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

#pragma mark - 文章点赞事件
-(void)PraiseCountClick:(UIButton*)btn{
    if(btn!=self.starButton){
        self.starButton.selected=NO;
        self.starButton=btn;
    }
    self.starButton.selected=YES;
    if (btn.selected == YES) {
        PraiseIndex = btn.tag;
    }
    NSLog(@"点赞");
    NSLog(@"点击行数%d",PraiseIndex);
    
 DailyFirstArticle  *model = _presenter.dataSource[PraiseIndex];
 DailyArticleMoreTableViewCell* cell = [_table dequeueReusableCellWithIdentifier:@"cell"];
        if ([model.IsPraise integerValue] == 1) {
            //取消点赞
//            [cell.DailyPraiseLb setTitle:[NSString  stringWithFormat:@"%d",[model.PraiseCount  integerValue]-1] forState:UIControlStateNormal];
         cell.DailyPraiseLb.text = [NSString  stringWithFormat:@"%d",[model.PraiseCount  integerValue]-1];
            [cell.DailyPraiseCountBt  setImage:[UIImage  imageNamed:@"Heart_icon"]  forState:UIControlStateNormal];
            [_presenter  CancelArticlePraiseByArticleID:model.ID];
            
        }else{
            //点赞
//            [_DailyPraiseCountBt setTitle:[NSString  stringWithFormat:@"%d",[model.PraiseCount  integerValue]+1] forState:UIControlStateNormal];
        cell.DailyPraiseLb.text = [NSString  stringWithFormat:@"%d",[model.PraiseCount  integerValue]+1];
            [cell.DailyPraiseCountBt  setImage:[UIImage  imageNamed:@"Heart_red_icon"]  forState:UIControlStateNormal];
        [_presenter  InsertArticlePraiseByArticleID:model.ID];
            
            
        }
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


@end
