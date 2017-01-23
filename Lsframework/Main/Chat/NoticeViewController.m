//
//  NoticeViewController.m
//  FamilyPlatForm
//
//  Created by Mac on 16/12/5.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeAndSystemCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "SystemNotiecPresenter.h"
#import "SystemNotice.h"
#import "MyFavorite.h"
#import "CMyComment.h"
#import "CConsultationBeListen.h"
#import "COtherTypeTableViewCell.h"
#import "CCommmentCell.h"
#import "CListenCell.h"

#import "CSystemNoticeViewController.h"
#import "CEnterSystemViewController.h"
@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource,SystemNotiecPresenterDelegate>
{
    UITableView *table;
    
    UISegmentedControl *segmentControl;
    
}
@property(nonatomic,strong)SystemNotiecPresenter *presenter;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _presenter = [SystemNotiecPresenter new];
    _presenter.delegate = self;
    
    [kdefaultCenter addObserver:self selector:@selector(RefreshSegmentNoticeTypeViewController) name:@"SegmentNoticeTypeRefresh" object:nil];
}

-(void)RefreshSegmentNoticeTypeViewController{

    [table.mj_header  beginRefreshing];

}
-(void)setupView
{
    NSArray *array = [NSArray arrayWithObjects:@"系统通知",@"评论",@"喜欢",@"听过", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.tintColor = UIColorFromRGB(0xc9c9c9);
    segment.selectedSegmentIndex = 0;
    
    //选择后的字体颜色（在NSDictionary中 可以添加背景颜色和字体的背景颜色）
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                         
                         NSForegroundColorAttributeName,
                         
                         [UIFont systemFontOfSize:14],
                         
                         NSFontAttributeName,nil];
    
    
    [ segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    //默认字体颜色
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x666666),
                          
                          NSForegroundColorAttributeName,
                          
                          [UIFont systemFontOfSize:14],
                          
                          NSFontAttributeName,nil];
    
    [ segment setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    [segment addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    segmentControl = segment;
    
    segment.sd_layout.topSpaceToView(self.view,15).leftSpaceToView(self.view,25/2).rightSpaceToView(self.view,25/2).heightIs(30);
  
    [self setUpTableView:API_getsystemmessage Nsinter:0];
}
-(void)setUpTableView:(NSString *)url Nsinter:(NSInteger)inter
{
    table = [UITableView new];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor whiteColor];
    table.tableFooterView = [UIView new];
    [self.view addSubview:table];
    table.sd_layout.topSpaceToView(self.view,60).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight-64-60);
    
    UIImageView *lineImg = [UIImageView new];
    lineImg.image = [UIImage imageNamed:@"line_long"];
    [self.view addSubview:lineImg];
    lineImg.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,60).heightIs(1);
    WS(ws);
    
    switch (inter) {
        case 0:
        {
            
            table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                table.userInteractionEnabled = YES;
                [ws.presenter loadSystemNotice:url ModelType:SegmentSystemType];
            }];
            [table.mj_header beginRefreshing];
            table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        table.userInteractionEnabled = NO;
                        [ws.presenter loadSystemMoreNotiec:url ModelType:SegmentSystemType];
                    }];
            
        }
            break;
        case 1:
        {
            table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                table.userInteractionEnabled = YES;
                [ws.presenter loadSystemNotice:url ModelType:SegmentCommentType];
            }];
            [table.mj_header beginRefreshing];
            table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                table.userInteractionEnabled = NO;
                [ws.presenter loadSystemMoreNotiec:url ModelType:SegmentCommentType];
            }];
        }
            break;
        case 2:
        {
            table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                table.userInteractionEnabled = YES;
                [ws.presenter loadSystemNotice:url ModelType:SegmentFavouriteType];
            }];
            [table.mj_header beginRefreshing];
            table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                table.userInteractionEnabled = NO;
                [ws.presenter loadSystemMoreNotiec:url ModelType:SegmentFavouriteType];
            }];
        }
            break;
        case 3:
        {
            table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                table.userInteractionEnabled = YES;
                [ws.presenter loadSystemNotice:url ModelType:SegmentListenType];
            }];
            [table.mj_header beginRefreshing];
            table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                table.userInteractionEnabled = NO;
                [ws.presenter loadSystemMoreNotiec:url ModelType:SegmentListenType];
            }];
        }
            break;
            
        default:
            break;
    }
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segmentControl.selectedSegmentIndex == 0) {
        return self.presenter.dataSource.count;

    }else if (segmentControl.selectedSegmentIndex == 1){
       return self.presenter.commentSource.count;
    }else if (segmentControl.selectedSegmentIndex == 2){
        return self.presenter.favoriteSource.count;
    }else if (segmentControl.selectedSegmentIndex == 3){
        return self.presenter.ListenSource.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentControl.selectedSegmentIndex == 0) {

        NoticeAndSystemCell* cell = [table dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            
            cell = [[NoticeAndSystemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.systemModel  = [self.presenter.dataSource objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sd_tableView = tableView;
        cell.sd_indexPath = indexPath;
        
        return cell;
    }else if (segmentControl.selectedSegmentIndex == 1){
        
        CCommmentCell *comment = [table dequeueReusableCellWithIdentifier:@"comment"];
        if (comment == nil) {
            comment = [[CCommmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
        }
        comment.comment = [self.presenter.commentSource objectAtIndex:indexPath.row];
        comment.selectionStyle = UITableViewCellSelectionStyleNone;
        comment.sd_tableView = tableView;
        comment.sd_indexPath = indexPath;
        return comment;
        
        
    }else if(segmentControl.selectedSegmentIndex == 2){
      
        COtherTypeTableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"favorite"];
        if (cell == nil) {
            cell = [[COtherTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favorite"];
        }
        cell.favorite = [self.presenter.favoriteSource objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sd_tableView = tableView;
        cell.sd_indexPath = indexPath;
        return cell;
    }else if (segmentControl.selectedSegmentIndex == 3){
        
        CListenCell *listen = [table dequeueReusableCellWithIdentifier:@"listen"];
        if (listen == nil) {
            listen = [[CListenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listen"];
        }
        
        listen.listen = [self.presenter.ListenSource objectAtIndex:indexPath.row];
        listen.selectionStyle = UITableViewCellSelectionStyleNone;
        listen.sd_tableView = tableView;
        listen.sd_indexPath = indexPath;
        return listen;
        
        }
    
    return [UITableViewCell new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (segmentControl.selectedSegmentIndex == 0) {
        
        SystemNotice *systemNotice = [self.presenter.dataSource objectAtIndex:indexPath.row] ;
        
        return [table cellHeightForIndexPath:indexPath model:systemNotice keyPath:@"systemModel" cellClass:[NoticeAndSystemCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (segmentControl.selectedSegmentIndex == 1){
        
        CMyComment *comment = [self.presenter.commentSource objectAtIndex:indexPath.row] ;
        
        return [table cellHeightForIndexPath:indexPath model:comment keyPath:@"comment" cellClass:[CCommmentCell class] contentViewWidth:[self cellContentViewWith]];
        
    }else if (segmentControl.selectedSegmentIndex == 2){
        
        MyFavorite *favorite = [self.presenter.favoriteSource objectAtIndex:indexPath.row];
        return [table cellHeightForIndexPath:indexPath model:favorite keyPath:@"favorite" cellClass:[COtherTypeTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else if (segmentControl.selectedSegmentIndex == 3){
        
        CConsultationBeListen *listen = [self.presenter.ListenSource objectAtIndex:indexPath.row];
       
        return [table cellHeightForIndexPath:indexPath model:listen keyPath:@"listen" cellClass:[CListenCell class] contentViewWidth:[self cellContentViewWith]];
    }
    
    
    
   return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WS(ws);
    

    switch (segmentControl.selectedSegmentIndex) {
        case 0:
        {
            NoticeAndSystemCell *cellNotiec = [NoticeAndSystemCell new];
            cellNotiec.systemModel = [self.presenter.dataSource objectAtIndex:indexPath.row];
            [ws.presenter isReadNoticeWithUuid:cellNotiec.systemModel.uuid sysBlock:^(BOOL success) {
                cellNotiec.systemModel.IsRead = success;
                [tableView reloadData];
            }];
            CEnterSystemViewController *vc = [CEnterSystemViewController new];
            vc.systemModel = cellNotiec.systemModel;
            vc.Types = 0;
            [self.delegate pushToVc:vc];
        }
            break;
        case 1:
        {
            CCommmentCell *cellComment = [CCommmentCell new];
            cellComment.comment = [self.presenter.commentSource objectAtIndex:indexPath.row];
            [ws.presenter isReadNoticeWithUuid:cellComment.comment.uuid sysBlock:^(BOOL success) {
                cellComment.comment.IsRead = success;
                [tableView reloadData];
            }];
            CEnterSystemViewController *vc = [CEnterSystemViewController new];
            vc.comment = cellComment.comment;
            vc.Types = 1;
            [self.delegate pushToVc:vc];
        }
            break;
        case 2:
        {
            
            COtherTypeTableViewCell *favorite = [COtherTypeTableViewCell new];
            favorite.favorite = [self.presenter.favoriteSource objectAtIndex:indexPath.row];
            NSLog(@"favorite.favorite.uuid--is%@",favorite.favorite.uuid);
            //        [ws.presenter isReadNoticeWithUuid:favorite.favorite.uuid];
            [ws.presenter isReadNoticeWithUuid:favorite.favorite.uuid sysBlock:^(BOOL success) {
                NSLog(@"favorite.favorite.success--is %hhd",success);
                favorite.favorite.IsRead = success;
                [tableView reloadData];
            }];
            CEnterSystemViewController *vc = [CEnterSystemViewController new];
            vc.favorite = favorite.favorite;
            vc.Types = 2;
            [self.delegate pushToVc:vc];
            
        }
            break;
        case 3:
        {
            CListenCell *CellListen = [CListenCell new];
            CellListen.listen = [self.presenter.ListenSource objectAtIndex:indexPath.row];
            [ws.presenter isReadNoticeWithUuid:CellListen.listen.uuid sysBlock:^(BOOL success) {
                CellListen.listen.IsRead = success;
                [tableView reloadData];
            }];
            CEnterSystemViewController *vc = [CEnterSystemViewController new];
            vc.listen = CellListen.listen;
            vc.Types = 3;
            [self.delegate pushToVc:vc];
            
            
        }
            break;
            
        default:
            break;
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

#pragma mark--UISegmentedController--
-(void)segmentedChanged:(UISegmentedControl*)sender
{
    NSLog(@"sender: %ld",(long)sender.selectedSegmentIndex); //输出当前的索引值
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [self setUpTableView:API_getsystemmessage Nsinter:0];
            
        }
            break;
        case 1:
        {
           [self setUpTableView:API_GetCommontMessage Nsinter:1];
            
        }
            break;
        case 2:
        {
          [self setUpTableView:API_getmyfavorite Nsinter:2];
            
        }
            break;
        case 3:
        {
           [self setUpTableView:API_GetConsultationBeListen Nsinter:3];
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark --网络请求回调－－
-(void)GetSystemNoticeCompletion:(BOOL)success info:(NSString *)message
{
    table.userInteractionEnabled = YES;
    [table.mj_footer resetNoMoreData];
    [table.mj_header endRefreshing];
    
    if (success) {
        
        [table reloadData];
    }
}
-(void)GetSystemNoticeMoreListCompletion:(BOOL)success info:(NSString *)message
{
    
    table.userInteractionEnabled = YES;
    
    self.presenter.noMoreData? [table.mj_footer endRefreshingWithNoMoreData]: [table.mj_footer endRefreshing];
    
    if(success){
        [table reloadData];
    
    }else{
        [ProgressUtil showError:message];
    }
    
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
