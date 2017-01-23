//
//  ZHCollectionView.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHCollectionView.h"
#import "ZHCollectionViewCell.h"
#import "ArchivesRecordViewController.h"
#import "UIView+ViewController.h"
#import "ChildEntity.h"
#import "ArchivesMainViewController.h"

#define IDENTIFIER @"cell_collction"

@interface ZHCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

@property(nonatomic,retain) ZHCollectionViewCell* collectionCell;

@end

@implementation ZHCollectionView

- (instancetype)init{
    self = [super init];
    if (self) {
//        _babyArray = [NSMutableArray array];
        _selectBabyArray = [NSMutableArray array];
        [self setupCollectionView];
    }
    return  self;
}

- (void)setupCollectionView{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ZHCollectionViewCell class] forCellWithReuseIdentifier:IDENTIFIER];
    [self addSubview:_collectionView];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _babyArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER forIndexPath:indexPath];
    cell.cellType = CellTypeBaby;
    if (indexPath.row == _babyArray.count) {
        cell.cellType = CellTypeAdd;
    }
    cell.backgroundColor = [UIColor clearColor];
    if (_babyArray.count != 0 && _babyArray.count != indexPath.row) {
        cell.entity = ((ChildEntity *)self.babyArray[indexPath.row]);

    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZHCollectionViewCell *cell = ((ZHCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]);
    if (indexPath.row == _babyArray.count) {
        //push到添加baby
        ArchivesMainViewController * vc = [ArchivesMainViewController new];
        vc.poptoClass = self.popToClass;
        [self.ViewController.navigationController pushViewController:vc animated:YES];
    }else{
        
        if(self.collectionCell && self.collectionCell.isAdd && ![self.collectionCell isEqual:cell]){
            self.collectionCell.isAdd = NO;
        }
       cell.isAdd = !(cell.isAdd);
    
        if(self.currentChild){
            self.currentChild = nil;
        }
        if(cell.isAdd){
            self.currentChild = _babyArray[indexPath.row];
        }
        self.collectionCell = cell;
    }
}

- (void)reloadData{
    [_collectionView reloadData];
}
@end
