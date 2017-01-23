//
//  DataInputCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/10/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DataInputCell.h"
#import "MonthInputCell.h"
#import "DataValue.h"
#import "DefaultChildEntity.h"

@interface DataInputCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MonthCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation DataInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    self.clipsToBounds = YES;
    return self;
}

- (void)setupInptView{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    [flowLayout setMinimumLineSpacing:35];
    [flowLayout setMinimumInteritemSpacing:25];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12.5, 22, kScreenWidth - 25, 313-44) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.clipsToBounds = NO;
    [_collectionView registerClass:[MonthInputCell class]
        forCellWithReuseIdentifier:@"cell"];
    [_collectionView setScrollEnabled:NO];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (kScreenWidth - 75)/3;
    CGFloat height = (313-145)/4;//_colHeight == 0?0:(_colHeight - 145)/4.f;
    return CGSizeMake(width, height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MonthInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.sd_indexPath = indexPath;
    cell.delegate = self;

    if ([_dataDic objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {
        cell.value = [_dataDic objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        NSLog(@"%d===-===%d===-===%d",indexPath.row+1,[cell.value.Month integerValue],[cell.value.DataValue integerValue]);
    }else{
        cell.value = nil;
    }
    cell.type = _type;
    
    NSString *ageStr = [DefaultChildEntity defaultChild].nL;
    NSInteger month;
    NSInteger year;
    ageStr = [ageStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSRange range = [ageStr rangeOfString:@"月"];
    NSRange rangeAge = [ageStr rangeOfString:@"岁"];
    if (rangeAge.length == 0) {
        //0岁(开放1岁)
        year = 1;
        if (range.length == 0) {
            month = 0;
        }else{
            NSRange monthRange = {0,range.location};
            month = [[ageStr substringWithRange:monthRange] integerValue];
        }
    }else{
        if (range.length == 0) {
            month = 0;
        }else{
            NSRange monthRange = {rangeAge.location+rangeAge.length,range.location};
            month = [[ageStr substringWithRange:monthRange] integerValue];
        }
        NSRange rangeYear = {0,rangeAge.location};
        year = [[ageStr substringWithRange:rangeYear] integerValue];;
    }
    month++;
    //判断可编辑状态
    NSInteger section = self.sd_indexPath.section+1;
    if (section <= year && rangeAge.length != 0) {
        //全部可编辑
        cell.userInteractionEnabled = YES;
        cell.editEnable = YES;
    }else{
        //部分可编辑
        if (indexPath.row + 1 <= month) {
            //可编辑
            cell.userInteractionEnabled = YES;
            cell.editEnable = YES;
        }else{
            //不可编辑
            cell.userInteractionEnabled = NO;
            cell.editEnable = NO;
        }
    }
    
    
    return cell;
}
- (void)setColHeight:(CGFloat )colHeight{
    _colHeight = colHeight;
}
- (void)reloadData{
    [_collectionView reloadData];
}

- (void)inputText:(NSString *)text index:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:self.sd_indexPath.section];
    if (self.delegate) {
        [self.delegate input:text indexPath:indexPath];
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = dataArray;
    }else{
        [_dataDic removeAllObjects];
        _dataArray = dataArray;
    }
    if (_dataArray != nil) {
        for (DataValue *value in dataArray) {
            NSInteger month = [value.Month integerValue];
            NSInteger row = month%12;
            if (month !=0 && row == 0) {
                row = 12;
            }
            [_dataDic setObject:value forKey:[NSNumber numberWithInteger:row]];
        }
    }else{
        [_dataDic removeAllObjects];
    }
    if (_collectionView) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
    [self setupInptView];
}

@end
