//
//  VaccinePlaneViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccinePlaneViewController.h"
#import "VaccineRemindPresenter.h"
#import "VaccinePlaneCollectionViewCell.h"
#import "VaccineTableViewCell.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "VaccineRemindInfoViewController.h"

@interface VaccinePlaneViewController ()<VaccineRemindPresenterDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
@property(nullable,nonatomic,retain) VaccineRemindPresenter* presenter;
@property(nullable,nonatomic,retain) UICollectionView* collection;
@property(nullable,nonatomic,retain) UITableView* table;
@property(nullable,nonatomic,retain) NSMutableArray* tableDataSource;
@property(nonatomic) BOOL isOpenReplaceCell;
@property(nullable,nonatomic,retain) UIImageView* indactorImageView;
@end

@implementation VaccinePlaneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(242, 242, 242);
    self.title = @"接种计划";
    
    if(self.childBirtDay.length != 0){
        [ProgressUtil show];
        [self.presenter loadVaccinePlaneByChildBirth:self.childBirtDay];
    }else{
        [ProgressUtil showInfo:@"请先添加宝宝"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//        });
    }
    
}

#pragma mark - 加载视图
-(void)setupView{
    
    [self setupCollectionView];
    [self setupTableView];
}

- (void)setupCollectionView{
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(138/2.0, 140/2.0);
    
    UICollectionView* collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.showsHorizontalScrollIndicator = NO;
    collection.backgroundColor = UIColorFromRGB(0xffffff);
    collection.dataSource = self;
    collection.delegate = self;
    [collection registerClass:[VaccinePlaneCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    [self.view addSubview:collection];
    self.collection = collection;
    
    UIView* line = [UIView new];
    line.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [self.view addSubview:line];
    
    collection.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(70);
    
    line.sd_layout.topSpaceToView(collection,0).leftEqualToView(collection).rightEqualToView(collection).heightIs(1);
}

-(void)setupTableView{
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:table];
    self.table = table;
    
    table.sd_layout.topSpaceToView(self.collection,1).leftSpaceToView(self.view,25).rightSpaceToView(self.view,25).bottomSpaceToView(self.view,0);
    
    [table registerClass:[VaccineTableViewCell class] forCellReuseIdentifier:@"table"];
}

#pragma mark - 代理
#pragma mark * collection代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.presenter.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VaccinePlaneCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    cell.vaccineMonth.text = self.presenter.dataSource[indexPath.item].inoculationTime;
    

    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VaccinePlaneEntity* vaccine = self.presenter.dataSource[indexPath.item];
    
    self.tableDataSource = vaccine.vaccineDataSource;
    self.isOpenReplaceCell = NO;
    [self.table reloadData];
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.01;
}

#pragma mark * table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableDataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* array = self.tableDataSource[section];
    if(section == self.tableDataSource.count - 2){
        //替代疫苗
        if(self.isOpenReplaceCell){
            return array.count;
        }else{
            return 0;
        }
    }else{
        return array.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VaccineTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"table"];

    
    NSMutableArray* array = self.tableDataSource[indexPath.section];
    NSDictionary* dic = array[indexPath.row];
    
    
    
    NSArray* vaccine =self.tableDataSource[self.tableDataSource.count - 2];
    
    if (vaccine.count==0) {
        
        cell.showBottomView = (indexPath.row == (array.count - 1));

        cell.hiddenMustBottomView = NO;


    }else {
        cell.showBottomView = (indexPath.row == (array.count - 1));
        cell.hiddenMustBottomView = indexPath.section == 0;

    }

    if(indexPath.section == 0){
        cell.showMustTopView = indexPath.row == 0;
    }else{
        cell.showMustTopView = NO;
    }

    
    cell.dic = dic;

    
    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* array = self.tableDataSource[indexPath.section];
    
    NSDictionary* dic = [array objectAtIndex:indexPath.row];
    
    //疫苗ID
    NSString* vaccineID = [dic objectForKey:@"ID"];
//    WSLog(@"%@",vaccineID);
    VaccineRemindInfoViewController *vc = [VaccineRemindInfoViewController new];
    vc.vaccineID = vaccineID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 86/2.0;
//    if(section == self.tableDataSource.count - 1){
//        return 50;
//    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == self.tableDataSource.count - 2){
        //替代疫苗疫苗
        NSArray* vaccine =self.tableDataSource[self.tableDataSource.count - 2];
        
        if (vaccine.count==0) {
            
            return 0;
        }else {
            return 30;
        }
    }
    
   else if(section == self.tableDataSource.count - 1){
        //可选疫苗
        NSArray* vaccine =self.tableDataSource[self.tableDataSource.count - 1];
        
        if (vaccine.count==0) {
            return 0;
        }
        else{
            return 50;
        }
    }

    else if(section == 0){
        
        NSArray* vaccine =self.tableDataSource[0];
        
        if (vaccine.count==0) {
            return 0;
        }else{
        
            return 0;
        }
    }else {
        return 86/2.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* array = self.tableDataSource[indexPath.section];
    NSDictionary* dic = array[indexPath.row];

    return [tableView cellHeightForIndexPath:indexPath model:dic keyPath:@"dic" cellClass:[VaccineTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == self.tableDataSource.count - 2){
        //替代品疫苗
        UIView* headerView = [UIView new];
        headerView.backgroundColor = [UIColor clearColor];
    
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReplaceGesture:)];
        [headerView addGestureRecognizer:tap];
        
        UIView* topView = [UIView new];
        topView.backgroundColor = UIColorFromRGB(0x61d8d3);
        [headerView addSubview:topView];
        
        UIView* bgView = [UIView new];
        bgView.backgroundColor = UIColorFromRGB(0x61d8d3);
        [headerView addSubview:bgView];
        
        UILabel * title = [UILabel new];
        title.textColor = UIColorFromRGB(0xffffff);
        title.font = [UIFont systemFontOfSize:bigFont];
        title.text = @"替代疫苗";
        [bgView addSubview:title];
        
        UIImageView* indactorImageView = [UIImageView new];
        indactorImageView.userInteractionEnabled = YES;
        [bgView addSubview:indactorImageView];
        indactorImageView.tag = 201;
        self.indactorImageView = indactorImageView;
        
        UIView* bottomView = [UIView new];
        bottomView.backgroundColor = UIColorFromRGB(0x61d8d3);
        [headerView addSubview:bottomView];

        
        topView.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0).heightIs(10);
        
        bgView.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0);
        
        title.sd_layout.topSpaceToView(bgView,8).leftSpaceToView(bgView,10).heightIs(15);
        [title setSingleLineAutoResizeWithMaxWidth:150];
        
        indactorImageView.sd_layout.centerYEqualToView(title).heightIs(8).widthIs(15).leftSpaceToView(title,15);
        
        [bgView setupAutoHeightWithBottomView:title bottomMargin:10];
        bgView.sd_cornerRadius = @10;
        
        bottomView.sd_layout.topSpaceToView(bgView,-10).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0).heightIs(10);
        
        [headerView setupAutoHeightWithBottomView:bgView bottomMargin:0];
        
        bottomView.hidden = !self.isOpenReplaceCell;
        [bottomView updateLayout];
        
        if(self.isOpenReplaceCell){
            indactorImageView.image = [UIImage imageNamed:@"Vaccine_zd"];
        }else{
            indactorImageView.image = [UIImage imageNamed:@"Vaccine_zk"];

        }

        //替代疫苗疫苗
        NSArray* vaccine =self.tableDataSource[self.tableDataSource.count - 2];
        
        if (vaccine.count==0) {
            
            return nil;
        }
        
        return headerView;
    }else if(section == self.tableDataSource.count - 1){
        //可选疫苗
        UIView* headerView = [UIView new];
        
        UIView* view1 = [UIView new];
        view1.backgroundColor = RGB(242, 242, 242);
        [headerView addSubview:view1];
        
        UIView* titleView = [UIView new];
        titleView.backgroundColor = UIColorFromRGB(0xffffff);
        [headerView addSubview:titleView];
        
        UILabel * title = [UILabel new];
        title.textColor = UIColorFromRGB(0x666666);
        title.font = [UIFont systemFontOfSize:bigFont];
        title.text = @"可选疫苗";
        [titleView addSubview:title];
        
        UIView* bottomView = [UIView new];
        bottomView.backgroundColor = UIColorFromRGB(0xffffff);
        [headerView addSubview:bottomView];
        
        
        //添加约束
        view1.sd_layout.topSpaceToView(headerView,0).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0).heightIs(10);
        titleView.sd_layout.topSpaceToView(view1,0).leftEqualToView(view1).rightEqualToView(view1);
        title.sd_layout.topSpaceToView(titleView,15).leftSpaceToView(titleView,10).heightIs(15).widthIs(150);
        titleView.sd_cornerRadius = @10;
        [titleView setupAutoHeightWithBottomView:title bottomMargin:10];
        
        bottomView.sd_layout.topSpaceToView(titleView,-10).leftSpaceToView(headerView,0).rightSpaceToView(headerView,0).heightIs(10);
        
        [headerView setupAutoHeightWithBottomView:titleView bottomMargin:0];
        
        NSMutableArray* array = [self.tableDataSource lastObject];
        bottomView.hidden = array.count == 0;
        
        
        //可选疫苗
        NSArray* vaccine =self.tableDataSource[self.tableDataSource.count - 1];
        
        if (vaccine.count==0) {
            return nil;
        }
        
        
        return headerView;

    }
    return nil;
}






#pragma mark * 疫苗接种计划代理
-(void)loadVaccinePlaneComplete:(BOOL)success info:(NSString *)message{
    if(success){
        [ProgressUtil dismiss];
        
        [self.collection reloadData];
        
        //默认选中第一个
        [self.collection selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        VaccinePlaneEntity* vaccine = [self.presenter.dataSource firstObject];
        self.tableDataSource = vaccine.vaccineDataSource;
        [self.table reloadData];
        
    }else{
        [ProgressUtil showError:message];
    }
}

#pragma mark - 手势监听
- (void)tapReplaceGesture:(UITapGestureRecognizer*) tap{
    NSArray* array = [self.tableDataSource objectAtIndex:1];
    
    if(array.count == 0){
        
        UIImageView* indactor = (UIImageView*)[tap.view viewWithTag:201];
        indactor.transform = CGAffineTransformRotate(indactor.transform, M_PI);
        
        return ;
    }
    
    
    self.isOpenReplaceCell = !self.isOpenReplaceCell;
    
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 懒加载
-(VaccineRemindPresenter *)presenter{
    if(!_presenter){
        _presenter = [VaccineRemindPresenter new];
        _presenter.delegate = self;
    }
    return _presenter;
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
