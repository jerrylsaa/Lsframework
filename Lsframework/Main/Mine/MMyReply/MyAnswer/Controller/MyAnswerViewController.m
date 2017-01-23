//
//  MyAnswerViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyAnswerViewController.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "MyAnswerPresenter.h"
#import "MyAnswerTableViewCell.h"
#import "UIImage+Category.h"
#import "AwaitAnswerViewController.h"
#import "ReplyAnswerViewController.h"
#import "JMFoundation.h"
#import "MyAnserEntity.h"
#import "RelatedAnswerViewController.h"

@interface MyAnswerViewController ()<UITableViewDataSource,UITableViewDelegate,MyAnswerPresenterDelegate>

@property(nonatomic ,strong) UITableView *myAnswerTableView;
@property(nonatomic ,strong) NSArray *dataSource;
@property(nonatomic ,strong) UIView *noAnswerView;

@property(nonatomic,strong) MyAnswerPresenter* presenter;

@end

@implementation MyAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)setupView{
    

    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _presenter = [MyAnswerPresenter new];
    _presenter.delegate = self;
    _presenter.doctorID = _doctorID;
    _dataSource = [NSMutableArray array];
    [self setupTablwView];

    
}
- (void)setupTablwView{
    _myAnswerTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myAnswerTableView.dataSource = self;
    _myAnswerTableView.delegate = self;
      _myAnswerTableView.backgroundColor = [UIColor clearColor];
      [_myAnswerTableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_myAnswerTableView];
    _myAnswerTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight - 64 - 44);

     __weak typeof(self) weakSelf = self;
    _myAnswerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.myAnswerTableView.userInteractionEnabled = NO;
        weakSelf.presenter.pageIndex = 1;
        [weakSelf.presenter  loadMyAnswerData];
    }];
    
    _myAnswerTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.myAnswerTableView.userInteractionEnabled = NO;
        [weakSelf.presenter loadMoreData];
    }];
    [_myAnswerTableView.mj_header beginRefreshing];
    }

- (void)setupNoAnswerView{
    _noAnswerView = [UIView new];
    _noAnswerView.backgroundColor = [UIColor clearColor];
    [_myAnswerTableView addSubview:_noAnswerView];
    _noAnswerView.frame = _myAnswerTableView.frame;
    
    UIImageView *noAnswerImageView = [UIImageView new];
    noAnswerImageView.image = [UIImage imageNamed:@"icon_noQuestion"];
    [_noAnswerView addSubview:noAnswerImageView];
    noAnswerImageView.sd_layout.leftSpaceToView(_noAnswerView,(_noAnswerView.width - 90)/2).rightSpaceToView(_noAnswerView,(_noAnswerView.width - 90)/2).topSpaceToView(_noAnswerView,120).heightIs(80);
    
    UILabel *tipsLabel = [UILabel new];
    [_noAnswerView addSubview:tipsLabel];
    tipsLabel.text = @"你还没有需要回答的问题哦~";
    tipsLabel.textColor = UIColorFromRGB(0xA5A5A5);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.sd_layout.leftSpaceToView(_noAnswerView,0).rightSpaceToView(_noAnswerView,0).topSpaceToView(noAnswerImageView,30).heightIs(20);
}



#pragma mark - 代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
  // Do any additional setup after loading the view from its nib.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.presenter.dataSource.count;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell_myAnswer";
    MyAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyAnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.myAnswer = self.presenter.dataSource[indexPath.row];
//    MyAnserEntity  *Myanswer = self.presenter.dataSource[indexPath.row];
//    NSString* myAnswerTime = [NSDate getDateCompare:Myanswer.createTime];
//    cell.timeLabel.text = myAnswerTime;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyAnserEntity  *model = self.presenter.dataSource[indexPath.row];
    if (model.consultationStatus == 0) {

        RelatedAnswerViewController *vc = [RelatedAnswerViewController new];
        
        vc.uuid = @([model.uuid integerValue]);
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushToVc:)]) {
                [self.delegate pushToVc:vc];
            }
        //    AwaitAnswerViewController *vc = [AwaitAnswerViewController new];
        //    vc.MyAnswerEntity = model;
        //    vc.uuid = [model.uuid integerValue];
        //    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToVc:)]) {
        //            [self.delegate pushToVc:vc];
        //        }

    }else{
        
    ReplyAnswerViewController *vb = [ReplyAnswerViewController new];
        vb.MyAnswerEntity = model;
        vb.uuid = @([model.uuid integerValue]);
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushToVc:)]) {
            [self.delegate pushToVc:vb];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyAnserEntity  *model = self.presenter.dataSource[indexPath.row];
    return  [self.myAnswerTableView cellHeightForIndexPath:indexPath model:model keyPath:@"myAnswer" cellClass:[MyAnswerTableViewCell class]  contentViewWidth:[self cellContentViewWith]];

}

- (void)loadDataComplete:(BOOL)success message:(NSString *)message{
    if (success == TRUE){
        if (_presenter.pageIndex == 1) {
            [self.myAnswerTableView.mj_header endRefreshing];
            [self.myAnswerTableView.mj_footer endRefreshing];
        }else{
            [self.myAnswerTableView.mj_footer endRefreshing];
        }
    }else if (success == false){
        [self.myAnswerTableView.mj_header endRefreshing];
        if (message.length > 0) {
            [self.myAnswerTableView.mj_footer endRefreshing];
        }else{
            [self.myAnswerTableView.mj_footer endRefreshingWithNoMoreData];
        } 
    }
    [self.myAnswerTableView reloadData];
    self.myAnswerTableView.userInteractionEnabled = YES;
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
