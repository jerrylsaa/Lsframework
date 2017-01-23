//
//  HWViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#define keyStr [NSString stringWithFormat:@"%ld%@",(long)kCurrentUser.userId,[DefaultChildEntity defaultChild].babyID]

#define kDHeight [NSString stringWithFormat:@"dailyHeight%@",keyStr]
#define kDWeight [NSString stringWithFormat:@"dailyWeight%@",keyStr]
#define kDHInfo [NSString stringWithFormat:@"dailyHeightInfo%@",keyStr]
#define kDWInfo [NSString stringWithFormat:@"dailyWeightInfo%@",keyStr]

#import "HWViewController.h"
#import "HWView.h"
#import "HWPresenter.h"
#import "DefaultChildEntity.h"
#import "HWChartViewController.h"
#import "WeightInputViewController.h"
#import "HeightInputViewController.h"

@interface HWViewController ()<UIScrollViewDelegate,HWPresenterDelegate,HWDelegate,WeightInputViewDelegate,HeightInputViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HWView *heightView;
@property (nonatomic, strong) HWView *weightView;
@property (nonatomic, strong) HWPresenter *presenter;

@end

@implementation HWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.bodyType == BodyTypeWeight) {
        _segControl.selectedSegmentIndex = 1;
        [self change:_segControl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _presenter = [HWPresenter new];
    _presenter.delegate = self;
    [self setupSeg];
    [self setupScrollView];
    [self setupHeightView];
    [self setupWeightView];
//    [self initRightBarWithTitle:@"保存"];
}
- (void)setupSeg{
    _segControl = [[UISegmentedControl alloc] initWithItems:@[@"身高",@"体重"]];
    [_segControl setWidth:120.f];
    [_segControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segControl;
    [_segControl setSelectedSegmentIndex:0];
}
- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (void)setupHeightView{
    _heightView = [HWView new];
    _heightView.tag = 101;
    _heightView.delegate = self;
    _heightView.title = @"身高";
    [_scrollView addSubview:_heightView];
    _heightView.sd_layout.leftSpaceToView(_scrollView,0).topSpaceToView(_scrollView,0).bottomSpaceToView(_scrollView,0).widthIs(kScreenWidth);
    
    
    NSString *height = [kDefaultsUser objectForKey:kDHeight];
    if (height) {
        if ([height isEqualToString:[self dateString]]) {
            NSString *str = [kDefaultsUser objectForKey:kDHInfo];
            NSArray *array = [str componentsSeparatedByString:@"|"];
            _heightView.text = array[0];
            _heightView.compareText = array[1];
            _heightView.tipsText = array[2];
            NSString *tips = array[2];
//            tips = [tips stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"];
            _heightView.defaultLabel.hidden = YES;
            _heightView.unitLabel.hidden = NO;
            _heightView.field.userInteractionEnabled = NO;
            
        }else{
            [kDefaultsUser removeObjectForKey:kDHeight];
            [kDefaultsUser removeObjectForKey:kDHInfo];
        }
    }
}

- (void)setupWeightView{
    _weightView = [HWView new];
    _weightView.tag = 102;
    _weightView.delegate = self;
    _weightView.title = @"体重";
    [_scrollView addSubview:_weightView];
    _weightView.sd_layout.leftSpaceToView(_heightView,0).topSpaceToView(_scrollView,0).bottomSpaceToView(_scrollView,0).widthIs(kScreenWidth);
    [_scrollView setupAutoContentSizeWithRightView:_weightView rightMargin:0];
    NSString *weight = [kDefaultsUser objectForKey:kDWeight];
    if (weight) {
        if ([weight isEqualToString:[self dateString]]) {
            NSString *str = [kDefaultsUser objectForKey:kDWInfo];
            NSArray *array = [str componentsSeparatedByString:@"|"];
            _weightView.text = array[0];
            _weightView.compareText = array[1];
            NSString *tips = array[2];
//            tips = [tips stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"];
            _weightView.tipsText = tips;;
            _weightView.defaultLabel.hidden = YES;
            _weightView.unitLabel.hidden = NO;
            _weightView.field.userInteractionEnabled = NO;
        }else{
            [kDefaultsUser removeObjectForKey:kDWeight];
            [kDefaultsUser removeObjectForKey:kDWInfo];
        }
    }

}
#pragma mark action
- (void)change:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 0) {
        //身高
        _scrollView.contentOffset = CGPointMake(0, 0);
        self.bodyType = BodyTypeHeight;
    }else{
        //体重
        _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        self.bodyType = BodyTypeWeight;
    }
}
//- (void)rightItemAction:(id)sender{
//  }

-(void)clickWeightAndHeightSegment{
    
    NSLog(@"身高：%@----体重：%@", _heightView.field.text,_weightView.field.text);
    if (self.bodyType == BodyTypeHeight) {
        
        HeightInputViewController  *vc = [HeightInputViewController  new];
        vc.delegate = self;
        if (_weightView.field.text != nil) {
            vc.heightTextField = _heightView.field.text ;
            
            
        }

        [self.navigationController  pushViewController:vc animated:YES];

        
        NSLog(@"点击身高框，输入身高");
    }else{
        
        NSLog(@"点击体重框，输入体重");
        WeightInputViewController  *vc = [WeightInputViewController  new];
        vc.delegate = self;
        if (_weightView.field.text != nil) {
            vc.weightTextField = _weightView.field.text ;
        }
        NSLog(@"体重%@", _weightView.field.text);
        [self.navigationController  pushViewController:vc animated:YES];
        
    }
    
}

-(void)WeightText:(NSString *)text{

    [_heightView.field resignFirstResponder];
    [_weightView.field resignFirstResponder];
    //提交
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    if (entityArray.count == 0) {
        [ProgressUtil showInfo:@"请先添加宝贝"];
        return;
    }
    NSDate *date = [DefaultChildEntity defaultChild].birthDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birthday = [formatter stringFromDate:date];
    
//    if ([[kDefaultsUser objectForKey:kDHeight] isEqualToString:[self dateString]] && _segControl.selectedSegmentIndex == 0) {
//        [ProgressUtil showInfo:@"今天已经记录过身高了"];
//        return;
//    }
//    if ([[kDefaultsUser objectForKey:kDWeight] isEqualToString:[self dateString]] && _segControl.selectedSegmentIndex == 1) {
//        [ProgressUtil showInfo:@"今天已经记录过体重了"];
//        return;
//    }
    
    
    if (_segControl.selectedSegmentIndex == 0) {
        [_presenter getAdviseByBody:birthday height:_heightView.field.text weight:@"" sex:[DefaultChildEntity defaultChild].childSex];
    }else{
        NSString *str = [kDefaultsUser objectForKey:kDWInfo];
        NSArray *array = [str componentsSeparatedByString:@"|"];
        _weightView.text = array[0];
        _weightView.compareText = array[1];
        NSString *tips = array[2];
        _weightView.tipsText = tips;;
        _weightView.defaultLabel.hidden = YES;
        _weightView.unitLabel.hidden = NO;
        _weightView.field.userInteractionEnabled = NO;
        _weightView.field.text = text;
        NSLog(@"体重：%@",_weightView.field.text);
        [_presenter getAdviseByBody:birthday height:@"" weight:_weightView.field.text sex:[DefaultChildEntity defaultChild].childSex];
    }

}

-(void)HeightText:(NSString *)text{
    NSLog(@"text:%@",text);
    [_heightView.field resignFirstResponder];
    [_weightView.field resignFirstResponder];
    //提交
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    if (entityArray.count == 0) {
        [ProgressUtil showInfo:@"请先添加宝贝"];
        return;
    }
    NSDate *date = [DefaultChildEntity defaultChild].birthDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birthday = [formatter stringFromDate:date];
    
    //    if ([[kDefaultsUser objectForKey:kDHeight] isEqualToString:[self dateString]] && _segControl.selectedSegmentIndex == 0) {
    //        [ProgressUtil showInfo:@"今天已经记录过身高了"];
    //        return;
    //    }
    //    if ([[kDefaultsUser objectForKey:kDWeight] isEqualToString:[self dateString]] && _segControl.selectedSegmentIndex == 1) {
    //        [ProgressUtil showInfo:@"今天已经记录过体重了"];
    //        return;
    //    }
    
    
    if (_segControl.selectedSegmentIndex == 0) {
        NSString *str = [kDefaultsUser objectForKey:kDWInfo];
        NSArray *array = [str componentsSeparatedByString:@"|"];
        _heightView.text = array[0];
        _heightView.compareText = array[1];
        NSString *tips = array[2];
        _heightView.tipsText = tips;;
        _heightView.defaultLabel.hidden = YES;
        _heightView.unitLabel.hidden = NO;
        _heightView.field.userInteractionEnabled = NO;
        _heightView.field.text = text;
        NSLog(@"身高：%@",_weightView.field.text);
        [_presenter getAdviseByBody:birthday height:_heightView.field.text weight:@"" sex:[DefaultChildEntity defaultChild].childSex];
    }else{
        NSString *str = [kDefaultsUser objectForKey:kDWInfo];
        NSArray *array = [str componentsSeparatedByString:@"|"];
        _weightView.text = array[0];
        _weightView.compareText = array[1];
        NSString *tips = array[2];
        _weightView.tipsText = tips;;
        _weightView.defaultLabel.hidden = YES;
        _weightView.unitLabel.hidden = NO;
        _weightView.field.userInteractionEnabled = NO;
        _weightView.field.text = text;
        NSLog(@"体重：%@",_weightView.field.text);
        [_presenter getAdviseByBody:birthday height:@"" weight:_weightView.field.text sex:[DefaultChildEntity defaultChild].childSex];
    }


}

#pragma mark delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [_segControl setSelectedSegmentIndex:0];
        self.bodyType = BodyTypeHeight;
    }else if (scrollView.contentOffset.x == kScreenWidth){
        [_segControl setSelectedSegmentIndex:1];
        self.bodyType = BodyTypeWeight;
    }
}

- (void)load:(BOOL)success message:(NSString *)message tips:(NSString *)tips isHeight:(BOOL)isHeight{
    if (success == NO) {
        [ProgressUtil showError:@"保存失败"];
    }else{
        if (isHeight == YES) {
            if ([message isEqualToString:@"-1"]) {
                message = @"偏矮";
            }else if ([message isEqualToString:@"0"]){
                message = @"正常";
            }else if ([message isEqualToString:@"1"]){
                message = @"偏高";
            }
            _heightView.compareText = message;
            tips = [tips stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"];
            _heightView.tipsText = tips;
            [kDefaultsUser setObject:[self dateString] forKey:kDHeight];
            [kDefaultsUser setObject:[NSString stringWithFormat:@"%@|%@|%@",_heightView.field.text,message,tips] forKey:kDHInfo];
        }else{
            if ([message isEqualToString:@"-1"]) {
                message = @"偏瘦";
            }else if ([message isEqualToString:@"0"]){
                message = @"正常";
            }else if ([message isEqualToString:@"1"]){
                message = @"偏胖";
            }
            _weightView.compareText = message;
            tips = [tips stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n\n"];
            _weightView.tipsText = tips;
            [kDefaultsUser setObject:[self dateString] forKey:kDWeight];
            [kDefaultsUser setObject:[NSString stringWithFormat:@"%@|%@|%@",_weightView.field.text,message,tips] forKey:kDWInfo];
        }
    }
}
- (void)selectChart:(NSInteger)tag{
    HWChartViewController *vc = [HWChartViewController new];
    if (tag == 101 ) {
        //身高
        vc.title = @"身高";
    }else{
        vc.title = @"体重";
    }
    [self.navigationController pushViewController:vc animated:YES];
}



- (NSString *)dateString{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}


@end
