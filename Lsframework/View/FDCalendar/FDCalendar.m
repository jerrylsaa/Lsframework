//
//  FDCalendar.m
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDCalendar.h"
#import "FDCalendarItem.h"
#import "JHCustomMenu.h"
#import "CalendarCell.h"

#define Weekdays @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]
#define AC_FONT [UIFont systemFontOfSize:(kScreenWidth == 320 ? 14 : 18)]

static NSDateFormatter *dateFormattor;

@interface FDCalendar () <UIScrollViewDelegate, FDCalendarItemDelegate ,JHCustomMenuDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FDCalendarItem *leftCalendarItem;
@property (strong, nonatomic) FDCalendarItem *centerCalendarItem;
@property (strong, nonatomic) FDCalendarItem *rightCalendarItem;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *datePickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (nonatomic ,strong) UIButton *yearButton;
@property (nonatomic,retain)JHCustomMenu *yearMenu;


@property (nonatomic ,strong) NSMutableArray *cellArray;

@property (nonatomic ,assign)CGRect buttonFrame;




@end

@implementation FDCalendar

- (instancetype)initWithCurrentDate:(NSDate *)date {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1.0];
        self.date = date;
        self.stateDic = [NSMutableDictionary dictionary];
        [self initYearMonthday:date];
        [self setupYearBar];
        [self setupMonthBar];
        [self setupWeekHeader];
        [self setupCalendarItems];
        [self setupScrollView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        self.month = [self currentMonth];
        [_monthCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.month-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self setCurrentMonth];
        [self setCurrentDate:self.date];
    }
    return self;
}


#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date {
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"MM-yyyy"];
    }
    return [dateFormattor stringFromDate:date];
}

// 设置上层的titleBar
- (void)setupYearBar {
    UIView *YearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    YearView.backgroundColor = [UIColor whiteColor];
    [self addSubview:YearView];
    UILabel *titleLabel = [UILabel new];
//    titleLabel.text = @"点击日历查看当日随访记录";
    titleLabel.text = @"点击日历查看当日健康日志";
    titleLabel.font = AC_FONT;
    [YearView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(YearView,20).rightSpaceToView(YearView,100).topSpaceToView(YearView,15).heightIs(20);
    
    //年份选择
    _yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [YearView addSubview:_yearButton];
    _yearButton.sd_layout.rightSpaceToView(YearView,20).topSpaceToView(YearView,10).bottomSpaceToView(YearView,10).widthIs(80);
    _buttonFrame = CGRectMake(kScreenWidth - 100, 40, 80, 0);
    _yearButton.layer.borderWidth = 1.f;
    _yearButton.layer.borderColor = UIColorFromRGB(0x71CAEE).CGColor;
    [_yearButton setTitleEdgeInsets:UIEdgeInsetsMake(5, -10, 5, 30)];
    _yearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_yearButton setTitle:@"2016" forState:UIControlStateNormal];
    [_yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_yearButton setImageEdgeInsets:UIEdgeInsetsMake(10, 55, 10, 0)];
    [_yearButton setImage:[UIImage imageNamed:@"ac_down"] forState:UIControlStateNormal];
    [_yearButton addTarget:self action:@selector(yearAction:) forControlEvents:UIControlEventTouchUpInside];
    //分割线
    UIView *speView = [UIView new];
    [self addSubview:speView];
    speView.backgroundColor = UIColorFromRGB(0x71CAEE);
    speView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(YearView,0).heightIs(1);
}

//设置第二层月份选择
- (void)setupMonthBar{
    _cellArray = [NSMutableArray array];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _monthCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 51, kScreenWidth, 50) collectionViewLayout:flowLayout];
    _monthCollectionView.dataSource = self;
    _monthCollectionView.delegate = self;
    _monthCollectionView.showsHorizontalScrollIndicator = NO;
    _monthCollectionView.backgroundColor = [UIColor whiteColor];
    [_monthCollectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"cell_item"];
    [self addSubview:_monthCollectionView];
    //分割线
    UIView *speView = [UIView new];
    [self addSubview:speView];
    speView.backgroundColor = UIColorFromRGB(0x71CAEE);
    speView.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(_monthCollectionView,0).heightIs(1);
}
// 设置星期文字的显示
- (void)setupWeekHeader {
    NSInteger count = [Weekdays count];
    CGFloat offsetX = 5;
    for (int i = 0; i < count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 122, (DeviceWidth - 10) / count, 20)];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.text = Weekdays[i];
        
        if (i == 0 || i == count - 1) {
            weekdayLabel.textColor = [UIColor redColor];
        } else {
            weekdayLabel.textColor = [UIColor grayColor];
        }
        
        [self addSubview:weekdayLabel];
        offsetX += weekdayLabel.frame.size.width;
    }
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 74, DeviceWidth - 30, 1)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineView];
}

// 设置包含日历的item的scrollView
- (void)setupScrollView {
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setFrame:CGRectMake(0, 145, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    [self addSubview:self.scrollView];
}

// 设置3个日历的item
- (void)setupCalendarItems {
    self.scrollView = [[UIScrollView alloc] init];
    
    self.leftCalendarItem = [[FDCalendarItem alloc] init];
    [self.scrollView addSubview:self.leftCalendarItem];
    
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = DeviceWidth;
    self.centerCalendarItem = [[FDCalendarItem alloc] init];
    self.centerCalendarItem.frame = itemFrame;
    self.centerCalendarItem.delegate = self;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    itemFrame.origin.x = DeviceWidth * 2;
    self.rightCalendarItem = [[FDCalendarItem alloc] init];
    self.rightCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.rightCalendarItem];
}

// 设置当前日期，初始化
// 加载已有健康日志日期数据
- (void)setCurrentDate:(NSDate *)date {
    self.centerCalendarItem.date = date;
    self.leftCalendarItem.date = [self.centerCalendarItem previousMonthDate];
    self.rightCalendarItem.date = [self.centerCalendarItem nextMonthDate];
    
    [self.titleButton setTitle:[self stringFromDate:self.centerCalendarItem.date] forState:UIControlStateNormal];
}

// 重新加载日历items的数据
- (void)reloadCalendarItems {
    CGPoint offset = self.scrollView.contentOffset;
//    NSLog(@"= = = = = %f",offset.x);
    if (offset.x == self.scrollView.frame.size.width) {
        [self setNextMonthDate];
    } else if (offset.x == -self.scrollView.frame.size.width){
        [self setPreviousMonthDate];
    }
}



#pragma mark - SEL

// 跳到上一个月
- (void)setPreviousMonthDate {
    [self setCurrentDate:[self.centerCalendarItem previousMonthDate]];
}

// 跳到下一个月
- (void)setNextMonthDate {
    [self setCurrentDate:[self.centerCalendarItem nextMonthDate]];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_monthCollectionView]) {
        return;
    }
    CGPoint offset = self.scrollView.contentOffset;
//    NSLog(@"= = = = = %f",offset.x);
    [self reloadCalendarItems];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

#pragma mark - FDCalendarItemDelegate

- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date {
    self.date = date;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectDate:)]) {
        [self.delegate selectDate:date];
    }
    [self setCurrentDate:self.date];
}

- (void)yearAction:(UIButton *)button{
    WS(ws);
    __weak typeof(self) weakSelf=self;
            if(!self.yearMenu){
                NSArray* array = @[@"2015",@"2016"];
                ws.yearMenu=[[JHCustomMenu alloc] initWithDataArr:array origin:CGPointMake(_buttonFrame.origin.x, _buttonFrame.origin.y) width:_buttonFrame.size.width rowHeight:30 rowNumber:4];
                ws.yearMenu.tableView.tag = 100;
                ws.yearMenu.delegate = ws;
                [ws addSubview:ws.yearMenu];
                ws.yearMenu.dismiss=^(){
                    weakSelf.yearMenu=nil;
                };
            }else{
                [ws.yearMenu dismissWithCompletion:^(JHCustomMenu *object) {
                    weakSelf.yearMenu=nil;
                }];
            }
}

#pragma mark JHCustomMenuDelegate
- (void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[_yearMenu.tableView cellForRowAtIndexPath:indexPath];
    [_yearButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    self.year = [cell.textLabel.text integerValue];
    [self reloadCalendar];
}


#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_item" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    if (_cellArray.count < 12) {
        [_cellArray addObject:cell];
        if (indexPath.row == self.month - 1 ) {
            self.indexPath = indexPath;
            [_stateDic setObject:@1 forKey:indexPath];
        }else{
            [_stateDic setObject:@0 forKey:indexPath];
        }
    }
    if ([[_stateDic objectForKey:indexPath] isEqual:@1]) {
        cell.isCurrent = YES;
    }else{
        cell.isCurrent = NO;
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 50);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

//    if (!self.indexPath) {
//        self.indexPath = indexPath;
//    }
//    [_stateDic setObject:@0 forKey:self.indexPath];
//    [_stateDic setObject:@1 forKey:indexPath];
//    self.indexPath = indexPath;
//    [collectionView reloadData];
//    NSLog(@"= = = = = = = %ld",(long)indexPath.row);
    //计算选择月份到当前月份差值，计算出NSDate
//    self.month = indexPath.row + 1;
//    [self reloadCalendar];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectMonth:)]) {
        [self.delegate selectMonth:indexPath.row];
    }
}

- (void)reloadCalendar{
    //根据年份获取差值，计算出NSDate
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:self.year];
    [resultComps setMonth:self.month];
    [resultComps setDay:self.day];
    NSDate *date = [calendar dateFromComponents:resultComps];
    date = [self getNowDateFromatAnDate:date];

    [self setCurrentMonth];
    [self setCurrentDate:date];

}
- (void)setCurrentMonth{
    for (int i = 0; i < _cellArray.count; i ++) {
        CalendarCell *cell = _cellArray[i];
        if (i == self.month - 1) {
            cell.isCurrent = YES;
        }else{
            cell.isCurrent = NO;
        }
    }
}
- (void)initYearMonthday:(NSDate *)date{
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    [formattor setDateFormat:@"yyyy-MM-dd"];
    NSString *yearMonth = [formattor stringFromDate:date];
    NSArray *array = [yearMonth componentsSeparatedByString:@"-"];
    self.year = [array[0] integerValue];
    self.month = [array[1] integerValue];
    self.day = [array[2] integerValue];
    [self setCurrentMonth];
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
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

//获取当前月份
- (NSInteger )currentMonth{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *monthStr = [formatter stringFromDate:[NSDate date]];
    return [monthStr integerValue];
}
@end
