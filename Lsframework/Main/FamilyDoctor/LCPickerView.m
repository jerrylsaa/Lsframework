//
//  LCPickerView.m
//  省市pickerView
//
//  Created by lichen on 16/4/18.
//  Copyright © 2016年 lichen. All rights reserved.
//

#import "LCPickerView.h"

#define kHeight 216

@interface LCPickerView (){
    LCPickerViewBlock pickerviewBlock;
}

@property(nonatomic,retain) UIView* pickerBgView;
@property(nonatomic,retain) UIButton* cancelbt;//取消
@property(nonatomic,retain) UIButton* confirmbt;//确定




@end

@implementation LCPickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];

        
        [self setupSubviews];
    }
    return self ;
}

- (void)setupSubviews{

    //pickerBgView
    self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, kHeight)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerBgView];
    //取消和确定按钮
    CGFloat width = 50;
    CGFloat height = 30;
    CGFloat marginSpace = 9;
    self.cancelbt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelbt.frame = CGRectMake(marginSpace, marginSpace, width, height);
    [self.cancelbt setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelbt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.cancelbt addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.cancelbt];
    
    self.confirmbt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmbt.frame = CGRectMake(self.frame.size.width-marginSpace-width, marginSpace, width, height);
    [self.confirmbt setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmbt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.confirmbt addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.confirmbt];

    //pickerView
    CGFloat pickerWidth = self.frame.size.width;
    CGFloat pickerHeight = self.pickerBgView.frame.size.height -CGRectGetMaxY(self.cancelbt.frame);
    
    self.postionPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.cancelbt.frame),pickerWidth,pickerHeight)];
    self.postionPickerView.dataSource = self;
    self.postionPickerView.delegate = self;
    [self.pickerBgView addSubview:self.postionPickerView];
    
}

#pragma mark - 代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return self.proArray.count;
    }else{
        return self.cityArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(component == 0){
        return 0.3*kScreenWidth;
    }else{
        return 0.6*kScreenWidth;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* title = nil;
    if(component ==0){
        title = self.proArray[row];
    }else{
//        NSDictionary* dic = self.cityArray[row];
//        title = dic[@"city"];
        title = self.cityArray[row];
    }
    NSString* result = nil;
    if([title hasPrefix:@"内蒙古"]){
        result = @"内蒙古";
    }else if([title hasPrefix:@"广西壮族"]){
        result = @"广西省";
    }else if([title hasPrefix:@"西藏"]){
        result = @"西藏";
    }else if([title hasPrefix:@"宁夏回族"]){
        result = @"宁夏";
    }else if([title hasPrefix:@"新疆"]){
        result = @"新疆";
    }else if([title hasPrefix:@"香港"]){
        result = @"香港";
    }else if([title hasPrefix:@"澳门"]){
        result = @"澳门";
    }else{
        result = title;
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        NSString* proName =self.proArray[row];
        NSArray* city = [CityEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"provinceName CONTAINS %@",proName]];
        NSMutableArray* cityArray = [NSMutableArray arrayWithCapacity:city.count];
        for(CityEntity* c in city){
            [cityArray addObject:c.ssqName];
        }
        self.cityArray = nil;
        if(cityArray.count !=0 ){
            self.cityArray = cityArray;
        }
        
    }else if(component == 1){
        
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    
}

#pragma mark - 点击事件
- (void)cancelAction{
    [self dismissPickerView];
}

- (void)confirmAction{
    NSInteger provinceRow = [self.postionPickerView selectedRowInComponent:0];
    NSInteger cityRow = [self.postionPickerView selectedRowInComponent:1];
    
    NSString* province = [self.proArray objectAtIndex:provinceRow];
    NSString* city = [self.cityArray objectAtIndex:cityRow];
   
    pickerviewBlock(province, city);
//    [self dismissPickerView];
}

#pragma mark - 公有方法
-(void)showPickerViewCompletetionHandler:(LCPickerViewBlock)block{
    pickerviewBlock = [block copy];
    CGRect rect = self.pickerBgView.frame;
    rect.origin.y -= kHeight;
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.pickerBgView.frame = rect;
    }];
}

- (void)dismiss{
    [self dismissPickerView];
}


#pragma mark - set方法
-(void)setProArray:(NSArray<NSString *> *)proArray{
    _proArray = proArray;
    
    if(self.cityArray.count!=0){
        [self.postionPickerView reloadAllComponents];
    }
}

-(void)setCityArray:(NSArray<NSString *> *)cityArray{
    _cityArray = cityArray;
    
    if(self.proArray.count !=0){
        [self.postionPickerView reloadAllComponents];
    }
}


-(void)setCurrentProvince:(NSString *)currentProvince{
    _currentProvince = currentProvince;
    
    NSString* province = nil;
    if(currentProvince.length != 0 && self.proArray.count != 0){
        province = currentProvince;
    }else {
        province = @"北京";
    }
    //滚动到指定省份
    NSArray* temArray = [self.proArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS %@",province]];
    NSString* pro = [temArray firstObject];
    NSInteger row = [self.proArray indexOfObject:pro];
    [self.postionPickerView selectRow:row inComponent:0 animated:NO];
}

-(void)setCurrentCity:(NSString *)currentCity{
    _currentCity = currentCity;
    NSString* defaultCity = nil;
    if(currentCity.length !=0 && self.cityArray.count != 0){
        defaultCity = currentCity;
    }else{
        defaultCity = @"东城区";
        NSArray* city = [CityEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"provinceName CONTAINS %@",@"北京"]];

        NSMutableArray* cityArray = [NSMutableArray arrayWithCapacity:city.count];
        
        for(CityEntity* c in city){
            [cityArray addObject:c.ssqName];
        }
        self.cityArray = nil;
        self.cityArray = cityArray;
    }
    //滚动到指定市
    NSArray* temArray = [self.cityArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS %@",defaultCity]];
    NSString* city = [temArray firstObject];
    NSInteger row = [self.cityArray indexOfObject:city];
    if(!city){
        row = 0;
    }
    [self.postionPickerView selectRow:row inComponent:1 animated:NO];
}

#pragma mark - private
- (void)dismissPickerView{
    CGRect rect = self.pickerBgView.frame;
    rect.origin.y += kHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0f;
        self.pickerBgView.frame = rect;
    }completion:^(BOOL finished) {
        [self.pickerBgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    UIView* view = touch.view;
    if([view isEqual:self]){
        //隐藏
        [self dismissPickerView];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(!self.currentProvince || self.currentProvince.length == 0){
        self.currentProvince = nil;
    }
    
    if(!self.currentCity || self.currentCity.length == 0){
        self.currentCity = nil;
    }
}









@end
