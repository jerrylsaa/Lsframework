//
//  ZHCityPicker.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHCityPicker.h"
#import "ProvinceEntity.h"
#import "DataTaskManager.h"

@interface ZHCityPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,strong)UIView *gesView;
@property (nonatomic ,strong)UIPickerView *picker;
@property (nonatomic ,strong)NSArray *provinceArray;
@property (nonatomic ,strong)NSArray *cityArray;
@property (nonatomic ,strong)UIView *pickerBg;
@property (nonatomic ,strong)UIButton *sureButton;
@property (nonatomic ,strong)UIButton *cancelButton;

@property (nonatomic ,assign)NSInteger component;
@property (nonatomic ,assign)NSInteger row;


@end

@implementation ZHCityPicker

- (instancetype)init{
    self = [super init];
    if (self) {
        self.provinceArray = [ProvinceEntity findAll];
        [self setupSubviews];
        [self picker];
    }
    return self;
}

- (UIView *)pickerBg{
    if (!_pickerBg) {
        _picker = [[UIPickerView alloc] init];
        _picker.frame = CGRectMake(0, 20, kScreenWidth, 200);
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.dataSource = self;
        _picker.delegate = self;
        [self pickerView:_picker didSelectRow:0 inComponent:0];
        _pickerBg = [UIView new];
        _pickerBg.backgroundColor = [UIColor whiteColor];
        _pickerBg.frame = CGRectMake(0, kScreenHeight-256, kScreenWidth, 200);
        [_pickerBg addSubview:_picker];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pickerBg addSubview:_sureButton];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.sd_layout.rightSpaceToView(_pickerBg,20).topSpaceToView(_pickerBg,10).widthIs(60).heightIs(20);
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pickerBg addSubview:_cancelButton];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.sd_layout.leftSpaceToView(_pickerBg,20).topSpaceToView(_pickerBg,10).widthIs(60).heightIs(20);
        
    }
    
    return _pickerBg;
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 34;
    }else{
        return self.cityArray.count;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return ((ProvinceEntity *)self.provinceArray[row]).ssqName;
    }else{
        return ((CityEntity *)self.cityArray[row]).ssqName;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 20)];
    label.font = [UIFont systemFontOfSize:(kScreenWidth == 320 ? 14 : 16)];
    if (component == 0) {
        label.text = ((ProvinceEntity *)self.provinceArray[row]).ssqName;
    }else{
        label.text = ((CityEntity *)self.cityArray[row]).ssqName;
    }
    label.textAlignment = NSTextAlignmentCenter;
    return (UIView *)label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _component = component;
    _row = row;
    
    if (_component == 0) {
        //查询是否有符合条件的市区
        NSArray *array = [CityEntity MR_findByAttribute:@"provinceId" withValue:((ProvinceEntity *)self.provinceArray[_row]).ssqId];
        //请求数据并存入数据库
        if (array.count == 0) {
            
            NSDictionary *parameters= [NSDictionary dictionaryWithObject:((ProvinceEntity *)self.provinceArray[_row]).ssqId forKey:@"Province"];
            [[FPNetwork POST:API_PHONE_QUERY_City withParams:parameters] addCompleteHandler:^(FPResponse *response) {
                //插入查询条件省份id
                NSMutableArray *dataArray = [NSMutableArray array];
                for (NSDictionary *subDic in response.data) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:subDic];
                    [dic setObject:((ProvinceEntity *)self.provinceArray[_row]).ssqId forKey:@"provinceId"];
                    [dataArray addObject:dic];
                }
                NSArray * array = [CityEntity mj_objectArrayWithKeyValuesArray:dataArray context:[NSManagedObjectContext MR_defaultContext]];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                self.cityArray = array;
                [_picker reloadComponent:1];
                [_picker selectRow:0 inComponent:1 animated:NO];
                _row = 0;
            }];
            
        }else{
            //从数据库取数据
            self.cityArray = array;
            [_picker reloadComponent:1];
            [_picker selectRow:0 inComponent:1 animated:NO];
            _row = 0;
        }
    }
}
- (void)setupSubviews{
    _gesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _gesView.backgroundColor = [UIColor colorWithWhite:.4 alpha:.2];
    _gesView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_gesView addGestureRecognizer:tap];
    
    
}
- (void)showInView:(UIView *)view{
    
    [view addSubview:self.gesView];
    [_gesView addSubview:self.pickerBg];
    [UIView animateWithDuration:.25 animations:^{
        _gesView.alpha = 1;
        _pickerBg.frame = CGRectMake(0, kScreenHeight-256, kScreenWidth, 200);
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:.25 animations:^{
        _gesView.alpha = 0;
        _pickerBg.frame = CGRectMake(0, kScreenHeight-64, kScreenWidth, 200);
    } completion:^(BOOL finished) {
        [_pickerBg removeFromSuperview];
        [_gesView removeFromSuperview];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:nil];
}

- (void)sureAction{
    self.city = self.cityArray[_row];
    if ([self.delegate respondsToSelector:@selector(selected:)]) {
        [self.delegate selected:self.city];
    }
    [self dismiss];
}

- (void)cancelAction{
    [self dismiss];
}


@end
