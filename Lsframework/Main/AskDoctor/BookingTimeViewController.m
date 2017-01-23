//
//  BookingTimeViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BookingTimeViewController.h"
#import "BookingTimeCollectionViewCell.h"
#import "OutpatientSuccessViewController.h"
#import "CaseInfoViewController.h"
#import "BookingTimePresenter.h"


@interface BookingTimeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BookingTimePresenterDelegate>{
    UILabel* _headerLabel;
    UICollectionView* _collection;
    UIButton* _currentSelectbt;
}

@property(nonatomic,retain) NSArray* dataSource;

@property(nonatomic,retain) BookingTimePresenter* presenter;

@property(nonatomic,retain) NSMutableDictionary* selectDic;

@property(nonatomic) NSInteger currentSelectIndex;

@end

@implementation BookingTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [BookingTimePresenter new];
    self.presenter.delegate = self;
    [self.presenter loadBookTimeList:self.bookDate andDoctorID:self.doctor.DoctorID];

}


-(void)setupView{
    self.title = @"普通门诊预约";
       
    self.view.backgroundColor=UIColorFromRGB(0xffffff);
    
    [self setupHeaderLabel];
    [self setupCollectionView];
    [self setupCommitButton];
}

- (void)setupHeaderLabel{
    _headerLabel=[UILabel new];
    _headerLabel.font=[UIFont systemFontOfSize:18];
//    _headerLabel.text=@"上午可预约时间";
    _headerLabel.text=@"可预约时间";
    _headerLabel.textColor=UIColorFromRGB(0x555555);
    [self.view addSubview:_headerLabel];
    _headerLabel.sd_layout.topSpaceToView(self.view,15).heightIs(20).leftSpaceToView(self.view,20).widthIs(kScreenWidth);
}

- (void)setupCollectionView{
//
    [_headerLabel updateLayout];
    UICollectionViewFlowLayout* layout=[UICollectionViewFlowLayout new];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.itemSize=CGSizeMake(170/2.0, 30);
    
    _collection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, _headerLabel.bottom+15, kScreenWidth, 570/2.0) collectionViewLayout:layout];
    _collection.backgroundColor=UIColorFromRGB(0xf2f2f2);
    _collection.showsVerticalScrollIndicator=NO;
    _collection.dataSource=self;
    _collection.delegate=self;
    [_collection registerClass:[BookingTimeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collection];
    
}

/**
 *  提交
 */
- (void)setupCommitButton{
    UIButton* commitbt=[UIButton new];
    [commitbt setBackgroundImage:[UIImage imageNamed:@"baby_commit"] forState:UIControlStateNormal];
    [commitbt setTitle:@"确认预约门诊" forState:UIControlStateNormal];
    [commitbt addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitbt];

    CGFloat height = 80;
    if(kScreenHeight==480){
        height=25;
    }
    commitbt.sd_layout.topSpaceToView(_collection,height).heightIs(40).leftSpaceToView(self.view,10).rightSpaceToView(self.view,10);
}

#pragma mark - 点击事件
- (void)commitAction{
    
//    CaseInfoViewController *vc = [CaseInfoViewController new];
//    vc.caseInfoType = CaseInfoTypeNormal;
//    [self.navigationController pushViewController:vc animated:YES];
//
    
    //判断是否选中预约时间段
    BOOL isSelect = NO;
    for(int i = 0; i < self.selectDic.count; ++i){
        if([[self.selectDic objectForKey:@(i)] intValue]){
            isSelect = YES;
            break ;
        }
    }
    
    if(!isSelect){
        [ProgressUtil showInfo:@"请选择时间"];
        return ;
    }
    
    
    
    BookTimeEntity* bookTime = [self.presenter.dataSource objectAtIndex:_currentSelectIndex];
    
    [ProgressUtil show];
    [self.presenter commitBook:@(bookTime.keyID) andDoctorID:self.doctor.DoctorID];
    
}


#pragma mark - 代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.presenter.dataSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BookingTimeCollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    BookTimeEntity* bookTime = self.presenter.dataSource[indexPath.item];
    NSString* title= bookTime.appointmentTime;
    
//    if(indexPath.item>5){
//        cell.timebt.enabled=NO;
//    }
    
    [cell.timebt setTitle:title forState:UIControlStateNormal];
    
    if([[self.selectDic objectForKey:@(indexPath.item)] intValue]){
    //选中
        cell.timebt.selected = YES;
    }else{
        cell.timebt.selected = NO;
    }
    
    WS(ws);
    [cell clickItemOnComplete:^(UIButton *bt) {
        for(BookTimeEntity* bookTime in ws.presenter.dataSource){
            if([bt.titleLabel.text isEqualToString:bookTime.appointmentTime]){
                NSInteger index = [ws.presenter.dataSource indexOfObject:bookTime];
                
                if([[ws.selectDic objectForKey:@(ws.currentSelectIndex)] intValue]){
                    //清空上次的选中状态
                    [ws.selectDic setObject:@0 forKey:@(ws.currentSelectIndex)];
                }
                ws.currentSelectIndex = index;
                [ws.selectDic setObject:@1 forKey:@(index)];
                
                [_collection reloadData];
                break ;
            }
        }
    }];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 10, 15, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

-(void)onCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        
        for(int i = 0; i < self.presenter.dataSource.count; ++i){
            [self.selectDic setObject:@0 forKey:@(i)];
        }
        
        [_collection reloadData];
    }else{
        [ProgressUtil showError:message];
    }
}

-(void)commitOnCompletion:(BOOL)success info:(NSString *)message{
    
    if(success){
        [ProgressUtil dismiss];
        
        BookTimeEntity* bookTime = [self.presenter.dataSource objectAtIndex:_currentSelectIndex];
        
        NSDate* tempDate = [NSDate format2DateWithStyle:@"yyyy-MM-dd" withDateString:bookTime.appointmentDate];
        
        NSString* date = [NSString stringWithFormat:@"时间: %@%@",[tempDate format2String:@"yyyy年MM月dd日"],bookTime.appointmentTime];
        
        NSString* departName = [NSString stringWithFormat:@"科室: %@",self.doctor.DepartName];
        NSString* hospitalName = [NSString stringWithFormat:@"地点: %@",self.doctor.HName];


        OutpatientSuccessViewController* success = [OutpatientSuccessViewController new];
        success.successTitle = @"您已经预约成功!";
        success.titleArray = @[date,departName,hospitalName];
//        success.tips = @"* 温馨提示: 预约信息可在首页事件提醒中查看";
        [self.navigationController pushViewController:success animated:YES];
        
    }else{
        [ProgressUtil showError:message];
    }
}


#pragma mark - 懒加载

-(NSMutableDictionary *)selectDic{
    if(!_selectDic){
        _selectDic = [NSMutableDictionary dictionary];
        
    }
    return _selectDic;
}


@end
