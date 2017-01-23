//
//  FollowUpMainViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FollowUpMainViewController.h"
#import "DailyRecordViewController.h"
#import "ChartViewController.h"
#import "FollowUpMainPresenter.h"
#import "DateEntity.h"

@interface FollowUpMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DateDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) FDCalendar *calendar;
@property (nonatomic ,strong) UILabel *followUpLabel;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSArray *titlesArray;
@property (nonatomic ,strong) FollowUpMainPresenter *presenter;

@end

@implementation FollowUpMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)setupView{
//  self.title = @"随访记录";
    self.title = @"健康日志";
    self.view.backgroundColor = [UIColor whiteColor];
    _titlesArray = @[@"母乳喂养",@"配方奶喂养",@"睡眠",@"大便",@"营养补充"];
    _presenter = [FollowUpMainPresenter new];
    [ProgressUtil show];
    [_presenter loadFolloeUpHistoryByMonth:0 complete:^(BOOL success, NSArray *dataSource) {
        if (success == YES) {
            [ProgressUtil dismiss];
            [_calendar reloadCalendar];
        }else{
            [ProgressUtil dismiss];
//            [ProgressUtil showError:@"加载健康日志记录失败，请检查网络"];
        }
    }];

    [self setupScrollView];
    [self setupCalendar];
    [self setupFollowUpView];
    [self setupButtons];
}

- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 740);
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
}
- (void)setupCalendar{
    _calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame = _calendar.frame;
    frame.origin.y = 0;
    _calendar.frame = frame;
    _calendar.delegate = self;
    [_scrollView addSubview:_calendar];
    
    UIView *sepView = [UIView new];
    sepView.backgroundColor = UIColorFromRGB(0x71CAEE);
    [_scrollView addSubview:sepView];
    sepView.sd_layout.leftSpaceToView(_scrollView,0).topSpaceToView(_calendar,0).rightSpaceToView(_scrollView,0).heightIs(1);
}
- (void)setupFollowUpView{
    _followUpLabel = [UILabel new];
    _followUpLabel.backgroundColor = [UIColor whiteColor];
    _followUpLabel.text = @"日志统计";
//    _followUpLabel.text = @"随访统计";
    _followUpLabel.textColor = UIColorFromRGB(0x71CAEE);
    [_scrollView addSubview:_followUpLabel];
    _followUpLabel.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,0).topSpaceToView(_calendar,1).heightIs(50);
    
    UIView *sepView_2 = [UIView new];
    sepView_2.backgroundColor = UIColorFromRGB(0x71caee);
    [_scrollView addSubview:sepView_2];
    sepView_2.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_followUpLabel,0).heightIs(1);
}
- (void)setupButtons{
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell_button"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_collectionView];
    _collectionView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_followUpLabel,11).heightIs(200);
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_button" forIndexPath:indexPath];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, kScreenWidth/2/3)];
    label.layer.borderColor = UIColorFromRGB(0xDBDBDB).CGColor;
    label.layer.borderWidth = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _titlesArray[indexPath.row];
    label.textColor = UIColorFromRGB(0x3CC4BC);
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    label.backgroundColor = [UIColor clearColor];
    cell.backgroundView = label;
    cell.transform = CGAffineTransformMakeScale(.7, .7);
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/2, kScreenWidth/2/3);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row = %ld",(long)indexPath.row);
    ChartViewController *vc = [ChartViewController new];
    switch (indexPath.row) {
        case 0:
        {
            vc.chartType = ChartTypeBreastFeeding;
            break;
        }
        case 1:
        {
            vc.chartType = ChartTypeFormulaFeeding;
            break;
        }
        case 2:
        {
            vc.chartType = ChartTypeSleeping;
            break;
        }
        case 3:
        {
            vc.chartType = ChartTypeShit;
            break;
        }
        case 4:
        {
            vc.chartType = ChartTypeNutritionalSupplement;
        }
        default:
        {
            break;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma DateDelegate
- (void)selectDate:(NSDate *)date{
    date = [self getNowDateFromatAnDate:date];
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    [formattor setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [formattor stringFromDate:date];
    NSString *nowDateStr = [formattor stringFromDate:[self getPriousDateFromDate:[NSDate date] withDay:0]];
    NSLog(@"date = %@",dateStr);
    DailyRecordViewController *vc = [DailyRecordViewController new];
    [formattor setDateFormat:@"yyyy-MM-dd"];
    vc.date = [formattor stringFromDate:date];
    if ([dateStr integerValue] == [nowDateStr integerValue]) {
        vc.dailyType = DailyRecordTypeCurrent;
    }else{
        vc.dailyType = DailyRecordTypeHistory;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectMonth:(NSInteger)month{

    //        //根据年月查询日期数组
    NSArray *dateArray = [DateEntity MR_findAll];
    if (dateArray.count != 0) {
        NSLog(@"%ld月",(long)month+1);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:month inSection:0];
        if (!_calendar.indexPath) {
            _calendar.indexPath = indexPath;
        }
        [_calendar.stateDic setObject:@0 forKey:_calendar.indexPath];
        [_calendar.stateDic setObject:@1 forKey:indexPath];
        _calendar.indexPath = indexPath;
        [_calendar.monthCollectionView reloadData];
        
        //计算选择月份到当前月份差值，计算出NSDate
        _calendar.month = month + 1;
        
        [_calendar reloadCalendar];

    }else{
        [ProgressUtil show];
        [_presenter loadFolloeUpHistoryByMonth:month complete:^(BOOL success, NSArray *dataSource) {
            
            NSLog(@"%ld月",(long)month+1);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:month inSection:0];
            if (!_calendar.indexPath) {
                _calendar.indexPath = indexPath;
            }
            [_calendar.stateDic setObject:@0 forKey:_calendar.indexPath];
            [_calendar.stateDic setObject:@1 forKey:indexPath];
            _calendar.indexPath = indexPath;
            [_calendar.monthCollectionView reloadData];
            
            
            //计算选择月份到当前月份差值，计算出NSDate
            _calendar.month = month + 1;

            [_calendar reloadCalendar];
            
        }];
    }
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
-(NSDate *)getPriousDateFromDate:(NSDate *)date withDay:(int)Day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:Day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
}
@end

