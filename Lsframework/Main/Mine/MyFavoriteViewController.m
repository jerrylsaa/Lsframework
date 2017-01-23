//
//  MyFavoriteViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "MyFavoritePresenter.h"
#import "MyFavoriteTableViewCell.h"
#import "MyFavoriteImageTableViewCell.h"
#import "MyFavoriteEntity.h"
#import <UITableView+SDAutoTableViewCellHeight.h>

#import "HotDetailConsulationViewController.h"
#import "DailyArticleViewController.h"
#import "PublicPostDetailViewController.h"





@interface MyFavoriteViewController ()<MyFavoritePresenterDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) UITableView* table;
@property(nonatomic,strong)MyFavoritePresenter*presenter;

@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的喜欢";
    
    // Do any additional setup after loading the view.
}
-(void)setupView{
    
    _presenter = [MyFavoritePresenter  new];
    _presenter.delegate = self;
    
    UITableView  *table = [UITableView  new];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerClass:[MyFavoriteTableViewCell class] forCellReuseIdentifier:@"Wordcell"];
    
    
    [table registerClass:[MyFavoriteImageTableViewCell class] forCellReuseIdentifier:@"Imagecell"];
    
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view  addSubview:table];
    self.table = table;
    table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    
    WS(ws);
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        table.userInteractionEnabled = NO;
        [ws.presenter GetMyFavoriteList];
    }];
    [table.mj_header beginRefreshing];
    table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        table.userInteractionEnabled = NO;
        [ws.presenter GetMyFavoriteMoreList];
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
    // 图片 +文字  cell
    MyFavoriteImageTableViewCell* Imagecell = [tableView dequeueReusableCellWithIdentifier:@"Imagecell"];
    
    // 文字  cell
    MyFavoriteTableViewCell* Wordcell = [tableView dequeueReusableCellWithIdentifier:@"Wordcell"];
   
    
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(indexPath.row < self.presenter.dataSource.count){
        MyFavoriteEntity *model = [self.presenter.dataSource   objectAtIndex:indexPath.row];
        
            if (model.Type == 1){
                //文字
                Wordcell.MyFavorite = [self.presenter.dataSource  objectAtIndex:indexPath.row];
                Wordcell.sd_indexPath = indexPath;
                Wordcell.sd_tableView = tableView;
                return Wordcell;

            }else  if (model.Type == 3 && model.Image1.length == 0) {
                    //文字
                    
                    Wordcell.MyFavorite = [self.presenter.dataSource  objectAtIndex:indexPath.row];
                    Wordcell.sd_indexPath = indexPath;
                    Wordcell.sd_tableView = tableView;
                    return Wordcell;

                }else if (model.Type == 3 && model.Image1.length != 0){
                //文字+图片
                    //文字+图片
                    Imagecell.MyFavoriteImage = [self.presenter.dataSource  objectAtIndex:indexPath.row];
                    Imagecell.sd_indexPath = indexPath;
                    Imagecell.sd_tableView = tableView;
                    return Imagecell;
                }else{
                        //文字+图片  文章
                        Imagecell.MyFavoriteImage = [self.presenter.dataSource  objectAtIndex:indexPath.row];
                        Imagecell.sd_indexPath = indexPath;
                        Imagecell.sd_tableView = tableView;
                        return Imagecell;
                    }
                }else{

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyFavoriteEntity *model = [self.presenter.dataSource   objectAtIndex:indexPath.row];
    NSLog(@"%@",model.NickName);
    if (model.Type == 1) {
        //问题详情
        HotDetailConsulationViewController *vc = [HotDetailConsulationViewController new];
        
        vc.UUID =[NSNumber  numberWithInteger:model.uuid] ;
        [self.navigationController  pushViewController:vc animated:YES];
        
    }else if (model.Type == 2){
    //每日必读
        DailyArticleViewController  *vc = [DailyArticleViewController new];
        NSDictionary *dict = [NSDictionary  dictionaryWithObjectsAndKeys:@(model.uuid),@"ID",model.Title,@"Title",model.Url,@"Url",model.Photo,@"Photo",@(model.PraiseCount),@"PraiseCount", nil];
        NSLog(@"每日必读：%@",dict);
        vc.TodayRecommend = [TodayRecommend mj_objectWithKeyValues:dict];
    NSLog(@"每日必读：---%@-----%@-----%@-----%@-----%@",vc.TodayRecommend.ID,vc.TodayRecommend.Title,vc.TodayRecommend.Url,vc.TodayRecommend.Photo,vc.TodayRecommend.PraiseCount);
        
        [self.navigationController  pushViewController:vc animated:YES];
        
    }else if (model.Type == 3){
    //帖子详情
        PublicPostDetailViewController  *vc = [PublicPostDetailViewController  new];
        
        vc.UUID = [NSNumber  numberWithInteger:model.uuid];
        
        [self.navigationController  pushViewController:vc animated:YES];
        
    
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    MyFavoriteEntity *model = [self.presenter.dataSource   objectAtIndex:indexPath.row];
    
    if (model.Type == 1){
        //文字
        
           return [_table cellHeightForIndexPath:indexPath model:model keyPath:@"MyFavorite" cellClass:[MyFavoriteTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        
        
    }else  if (model.Type == 3 && model.Image1.length == 0) {
        //文字
        
        return [_table cellHeightForIndexPath:indexPath model:model keyPath:@"MyFavorite" cellClass:[MyFavoriteTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        
    }else if (model.Type == 3 && model.Image1.length != 0){
        //文字+图片
        return [_table cellHeightForIndexPath:indexPath model:model keyPath:@"MyFavoriteImage" cellClass:[MyFavoriteImageTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else{
        //文字+图片  文章
        return [_table cellHeightForIndexPath:indexPath model:model keyPath:@"MyFavoriteImage" cellClass:[MyFavoriteImageTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
    }

    
}

#pragma mark----网络请求回调
-(void)GetMyFavoriteListCompletion:(BOOL)success info:(NSString*)message{
    _table.userInteractionEnabled = YES;
    [_table.mj_footer resetNoMoreData];
    [_table.mj_header endRefreshing];
    
    
    if(success){
        [_table reloadData];
        
    }else{
        
    }
}

-(void)GetMyFavoriteMoreListCompletion:(BOOL)success info:(NSString*)message{
    
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
