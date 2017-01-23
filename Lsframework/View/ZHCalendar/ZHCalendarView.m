//
//  ZHCalendarView.m
//  Date
//
//  Created by 中弘科技 on 16/4/2.
//  Copyright © 2016年 中弘科技. All rights reserved.
//


#import "ZHCalendarView.h"

@interface ZHCalendarView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic ,strong)NSDate *date;
@property (nonatomic ,strong)NSArray *days;
@property (nonatomic ,assign)BOOL needReset;




@end

@implementation ZHCalendarView

- (instancetype)initWithFrame:(CGRect)frame withDate:(NSDate *) date andDays:(NSArray *)days{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _indexPathArray = [NSMutableArray array];
        self.date = date;
        self.days = days;
        [self setupWeekHeader];
        [self setupCalendar];
    }
    return self;
}

- (void)setupWeekHeader{

    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < weekArray.count; i ++) {
        NSString *week = weekArray[i];
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(kScreenWidth/7*i, 0, kScreenWidth/7, kScreenWidth/7);
        label.textColor = [UIColor blackColor];
        if (i == 0 || i == weekArray.count - 1) {
            label.textColor = [UIColor redColor];
        }
        label.backgroundColor = UIColorFromRGB(0xf2f2f2);
        label.text = week;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
//        label.sd_layout.leftSpaceToView(self,kScreenWidth/7*i).topSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(kScreenWidth/7);
    }
}

- (void)setupCalendar{
    
    NSInteger lineNumber;
    
    if ([self totaldaysInThisMonth:self.date] + [self firstWeekdayInThisMonth:self.date] > 35) {
        lineNumber = 6;
    }else{
        lineNumber = 5;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenWidth/7*lineNumber) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ZHCalendarCell class] forCellWithReuseIdentifier:@"cell_item"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:_collectionView];
    
    UIView *sep = [UIView new];
    sep.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [self addSubview:sep];
    sep.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(_collectionView,0).heightIs(1);
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger firstWeekDay = [self firstWeekdayInThisMonth:self.date];
    return [self totaldaysInThisMonth:self.date]+firstWeekDay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_item" forIndexPath:indexPath];
    
    NSInteger firstWeekDay = [self firstWeekdayInThisMonth:self.date];
    NSInteger day = indexPath.row -firstWeekDay + 1;
    if (day > 0) {
        cell.title.text = [NSString stringWithFormat:@"%ld",(long)day];
    }
    cell.transform = CGAffineTransformMakeScale(.9, .9);
        
        if (day > 0 && [self.days containsObject:[NSNumber numberWithInteger:day]]) {
            cell.enableSelect = YES;
            if (_indexPathArray.count < 4) {
                [_indexPathArray addObject:indexPath];
            }
        }else{
            cell.enableSelect = NO;
        }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/7, kScreenWidth/7);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:self.date];
    [components setDay:indexPath.row - firstWeekday + 1];
    
    NSDate *selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [fmt stringFromDate:[self getPriousDateFromDate:selectedDate withDay:0]];
        
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:andDateStr:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath andDateStr:dateString];
    }

    
}

#pragma mark private
//本月多少天
- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

//第一天是周几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}


-(NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)Day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:Day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}
//数据源
- (void)updateWithDate:(NSDate *)date andDays:(NSArray *)days{
    self.date = date;
    self.days = days;
    [self.collectionView reloadData];
}



@end
