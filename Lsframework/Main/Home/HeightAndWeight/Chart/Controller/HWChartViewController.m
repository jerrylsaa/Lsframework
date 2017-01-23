//
//  HWChartViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HWChartViewController.h"
#import "PNChart.h"
#import "HWChartPresenter.h"
#import "ButtonsView.h"
#import "DataInputViewController.h"


@interface HWChartViewController ()<HWChartDelegate,ButtonsViewDelegate>

@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) UIView *legend ;
@property (nonatomic, strong) HWChartPresenter *presenter;
@property (nonatomic, strong) ButtonsView *buttons;

@property (nonatomic, strong) NSMutableArray *totalHArray;
@property (nonatomic, strong) NSMutableArray *totalMArray;
@property (nonatomic, strong) NSMutableArray *totalLArray;
@property (nonatomic, strong) NSMutableArray *totalDataArray;

@property (nonatomic, strong) NSArray *hArray;
@property (nonatomic, strong) NSArray *mArray;
@property (nonatomic, strong) NSArray *lArray;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) float maxY;
@property (nonatomic, assign) float minY;
@property (nonatomic, assign) NSInteger selectIndex;


@end

@implementation HWChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_selectIndex == 0) {
        _selectIndex = 1;
    }
    _presenter = [HWChartPresenter new];
    _presenter.delegate = self;
    NSString *typeStr = @"";
    if ([self.title isEqualToString:@"身高"]){
        typeStr = @"0";
    }else{
        typeStr = @"1";
    }
     [_presenter loadData:typeStr];
}

- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initRightBarWithTitle:@"编辑"];
}

- (void)dealWithData{
    
    NSMutableArray *xKeys = [NSMutableArray array];
    for (int i = 0; i < _presenter.highArray.count; i ++) {
        [xKeys addObject:@(i)];
    }
    _totalHArray = [NSMutableArray array];
    _totalMArray = [NSMutableArray array];
    _totalLArray = [NSMutableArray array];
    
    NSInteger count = _presenter.highArray.count;
    if (count > _presenter.middleArray.count) {
        count = _presenter.middleArray.count;
    }
    if (count > _presenter.lowArray.count) {
        count = _presenter.lowArray.count;
    }
    
    
    for (int i = 0; i < count; i++) {
        
        NSDictionary *hDic = _presenter.highArray[i];
        NSDictionary *mDic = _presenter.middleArray[i];
        NSDictionary *lDic = _presenter.lowArray[i];
        
        if ([self.title isEqualToString:@"身高"]) {
            [_totalHArray addObject:hDic[@"HeightHight"]];
            [_totalMArray addObject:mDic[@"HeightMiddle"]];
            [_totalLArray addObject:lDic[@"HeightLow"]];
        }else{
            [_totalHArray addObject:hDic[@"WeightHight"]];
            [_totalMArray addObject:mDic[@"WeightMiddle"]];
            [_totalLArray addObject:lDic[@"WeightLow"]];
        }
    }
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    NSMutableArray *monthArray = [NSMutableArray array];
    for (NSDictionary *dic in _presenter.dataArray) {
        [monthArray addObject:dic[@"Month"]];
        [dataDic setObject:dic[@"DataValue"] forKey:dic[@"Month"]];
   }
    NSMutableDictionary *dataSource = [NSMutableDictionary dictionary];
    for (int i = 0; i <= [self findMax:@[monthArray]]; i ++ ) {
        NSNumber *month = xKeys[i];
        if ([[dataDic allKeys] containsObject:month]) {
            [dataSource setObject:dataDic[month] forKey:month];
        }else{
            [dataSource setObject:@0 forKey:month];
        }
    }
    _totalDataArray = [NSMutableArray array];
    for (NSNumber *month in xKeys) {
        if (dataSource[month]) {
            [_totalDataArray addObject:dataSource[month]];
        }
    }
}
//生成需要的数组
- (void)getArrays:(NSInteger)index{
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    NSMutableArray *monthArray = [NSMutableArray array];
    for (NSDictionary *dic in _presenter.dataArray) {
        [monthArray addObject:dic[@"Month"]];
        [dataDic setObject:dic[@"DataValue"] forKey:dic[@"Month"]];
    }
    
    _hArray = [self rangeArray:_totalHArray index:index];
    _mArray = [self rangeArray:_totalMArray index:index];
    _lArray = [self rangeArray:_totalLArray index:index];
    _dataArray = [self rangeArray:_totalDataArray index:index];
    
    
    _maxY = [self findMax:@[_hArray,_dataArray]];
    _minY = [self findMin:@[_lArray,_dataArray]];
    
    //是否需要完整的对照表来设定区间
    
    if ([self.title isEqualToString:@"身高"]) {
        _maxY = (((NSInteger)_maxY/10)+1)*10;
        _minY = (((NSInteger)_minY/10)-1)*10;
    }else{
        _maxY = (((NSInteger)_maxY/10)+1)*10;
        _minY = (((NSInteger)_minY/10)-1)*10;
    }
    if (_minY < 0) {
        _minY = 0;
    }
    if ([self.title isEqualToString:@"身高"]) {
        if (_minY < 40) {
            _minY = 40;
       }
        if (_maxY > 300) {
            _maxY = 300;
        }
    }else{
        if (_maxY > 200) {
            _maxY = 200;
        }
//        NSArray *min = @[@2,@4,@6,@8,@8,@10,@10,@0,@0];
//        NSArray *max = @[@12,@19,@16,@18,@18,@20,@20,@20,@20];
//        _minY = [min[_selectIndex - 1] integerValue];
//        _maxY = [max[_selectIndex - 1] integerValue];
    }
    
//    if (_maxY == 0) {
//        _maxY = 100;
//        [ProgressUtil showInfo:@"没有更多的数据了"];
//        _buttons.nextButton.userInteractionEnabled = NO;
//        return;
//    }else{
//        _buttons.nextButton.userInteractionEnabled = YES;
//    }
    
}

- (NSArray *)rangeArray:(NSArray *)array index:(NSInteger )index{
    index = index - 1;
    NSMutableArray *rangeArray = [NSMutableArray array];
    for (NSInteger i = 12*index; i < 12*(index + 1); i ++) {
        if (i < array.count) {
            [rangeArray addObject:array[i]];
        }
    }
    return rangeArray;
}



- (void)setupChartView{
    
    NSArray *xArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 60.0, SCREEN_WIDTH, kScreenHeight - 200)];
    [_lineChart setXLabels:xArray withWidth:(SCREEN_WIDTH - 50)/xArray.count];
    _lineChart.chartType = self.title;
    if ([self.title isEqualToString:@"身高"]) {
        _lineChart.yUnit = @"cm";
    }else{
        _lineChart.yUnit = @"kg";
    }

    _lineChart.yFixedValueMax = _maxY;
    _lineChart.yFixedValueMin = _minY;
    
    [self.view addSubview:_lineChart];
    
    
    // Line Chart No.1
    NSArray * data01Array = _hArray;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = data01Array.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // Line Chart No.2
    NSArray * data02Array = _mArray;
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = data02Array.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart No.3
    NSArray * data03Array = _lArray;
    PNLineChartData *data03 = [PNLineChartData new];
    data03.color = PNBrown;
    data03.itemCount = data03Array.count;
    data03.getData = ^(NSUInteger index) {
        CGFloat yValue = [data03Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    
    // Line Chart No.4
    PNLineChartData *data04 = [PNLineChartData new];
    if (_presenter.dataArray.count > 0) {
//        NSArray *keyAr = [dataSource allKeys];
//        NSMutableArray * data04Array = [NSMutableArray array];
//        NSArray *array2 = [keyAr sortedArrayUsingSelector:@selector(compare:)];
//        for (id key in array2) {
//            [data04Array addObject:dataSource[key]];
//        }
        data04.color = PNDarkYellow;
        data04.inflexionPointStyle = PNLineChartPointStyleCircle;
        data04.showPointLabel = YES;
        data04.pointLabelColor = PNDarkYellow;
        data04.pointLabelFormat = @"%.1f";
        data04.pointLabelFont = [UIFont systemFontOfSize:10];
        data04.itemCount = _dataArray.count;
        data04.getData = ^(NSUInteger index) {
            CGFloat yValue = [_dataArray[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
    }
    
    data01.dataTitle = @"偏高";
    data02.dataTitle = @"标准";
    data03.dataTitle = @"偏低";
    data04.dataTitle = @"当前";
    if (_presenter.dataArray.count > 0) {
        _lineChart.chartData = @[data01, data02, data03, data04];
    }else{
        _lineChart.chartData = @[data01, data02, data03];
    }
//    _lineChart.showSmoothLines = YES;
    _lineChart.showCoordinateAxis = YES;
    _lineChart.showLabel = YES;
    _lineChart.clipsToBounds = NO;
    _lineChart.xUnit = @"月";
    _lineChart.axisWidth = 1;
    [_lineChart strokeChart];
    
    
    //Build the legend
    _lineChart.legendStyle = PNLegendItemStyleSerial;
    _lineChart.legendFont = [UIFont systemFontOfSize:12.0];
    _legend = [_lineChart getLegendWithMaxWidth:kScreenWidth];
    
    //Move legend to the desired position and add to view
    [_legend setFrame:CGRectMake(35, _lineChart.top - 30, _legend.frame.size.width, _legend.frame.size.height)];
    [self.view addSubview:_legend];
    [self.view addSubview:_lineChart];
}

- (void)setupButtons{
    _buttons = [ButtonsView new];
    _buttons.delegate = self;
    [self.view addSubview:_buttons];
    _buttons.sd_layout.leftSpaceToView(self.view,30).rightSpaceToView(self.view,25).topSpaceToView(_lineChart,10).heightIs(30);
}

#pragma mark delegate
- (void)complete:(BOOL)success message:(NSString *)message{
    if (success == YES) {
        [ProgressUtil dismiss];
        [self dealWithData];
        [self getArrays:1];
        if (_lineChart) {
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
        }
        [self setupChartView];
        [self setupButtons];
    }else{
        [ProgressUtil showError:message];
    }
}

- (void)selectIndex:(NSInteger)index{
    _selectIndex = index;
    if (index == 9) {
        [ProgressUtil showInfo:@"没有更多的数据了"];
        _buttons.nextButton.userInteractionEnabled = NO;
        return;
    }else{
        _buttons.nextButton.userInteractionEnabled = YES;
    }
    [self getArrays:index];
    if (_lineChart) {
        [_lineChart removeFromSuperview];
        [_legend removeFromSuperview];
    }
    [self setupChartView];
//    if (_buttons) {
//        [_buttons removeFromSuperview];
//    }
//    [self setupButtons];
     _buttons.sd_layout.leftSpaceToView(self.view,30).rightSpaceToView(self.view,25).topSpaceToView(_lineChart,10).heightIs(30);
    [_buttons updateLayout];
    
}

-(void)rightItemAction:(id)sender{
    DataInputViewController * vc = [DataInputViewController new];
    if ([self.title isEqualToString:@"身高"]) {
        vc.titleText = @"身高编辑";
    }else{
        vc.titleText = @"体重编辑";
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (float)findMax:(NSArray *)array{
    float max = [[self sortArray:array].lastObject floatValue];
    return max;
}
- (float)findMin:(NSArray *)array{
    float min = [[self sortArray:array].firstObject floatValue];
    return min;
}

- (NSArray *)sortArray:(NSArray *)array{
    NSMutableArray *totalArray = [NSMutableArray array];
    for (NSArray *subArray in array) {
        [totalArray addObjectsFromArray:subArray];
    }
    return [totalArray sortedArrayUsingSelector:@selector(compare:)];
}

@end
