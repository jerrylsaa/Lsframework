//
//  FDSelectFamilyDoctorViewController.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FDSelectFamilyDoctorViewController.h"
#import "RightViewTextField.h"
#import "ACMainTableViewCell.h"
#import "SelectFamilyDoctorTableViewCell.h"
#import "FDSelectButton.h"
#import "AppDelegate.h"
#import "FDSelectFamilyDoctorPresenter.h"
#import "LCPickerView.h"
#import "LocationManager.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "JHCustomMenu.h"
#import "ACDoctorDetailViewController.h"
#import "FDApplyDoctorViewController.h"
#import "JMFoundation.h"
#import "DepartmentEntity.h"


@interface FDSelectFamilyDoctorViewController ()<UITableViewDataSource,UITableViewDelegate,FDSelectFamilyDoctorPresenterDelegate,JHCustomMenuDelegate>{
    UITableView* _table;
//    UIBarButtonItem * _titleItem;
    RightViewTextField* _tf;
    
    FDSelectButton* _hospitalButton;
    FDSelectButton* _departmentButton;
    
    AppDelegate* _appDelegate;
    
    BOOL _isExist;
}

@property(nonatomic,copy) NSString* province;

@property(nonatomic,copy) NSString* city;

@property(nonatomic,retain) UIButton* rightButton;

@property(nonatomic,retain) NSArray* dataSource;

@property(nonatomic,retain) FDSelectFamilyDoctorPresenter* presenter;

@property(nonatomic,retain) JHCustomMenu* hospitalMenu;
@property(nonatomic,retain) JHCustomMenu* departMenu;

@property(nonatomic,retain) NSArray* hospitalArray;
@property(nonatomic,retain) NSArray* departArray;
@property(nonatomic,copy) NSString* currentHospatial;

@property (nonatomic, strong) UIBarButtonItem * titleItem;


@end

@implementation FDSelectFamilyDoctorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.presenter = [FDSelectFamilyDoctorPresenter new];
    self.presenter.delegate = self;

    
    if([self cityIsExist]){
        _isExist = YES;
        NSString* city = [self getCurrentCity];
        [self resetRightButtonTitle:city];
    }

    [self loadData];

}

- (void)loadData{
    if(_isExist){
        [ProgressUtil show];
        [self.presenter loadDoctorData:self.province City:self.city];
    }else{
     //定位失败后，重新获取城市
        WS(ws);
        [ProgressUtil show];
        [[LocationManager shareInstance] getProvinceAndCityWithBlock:^(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success) {
            if(success){
                [ProgressUtil dismiss];
                ws.province = province;
                ws.city = city;
                [self resetRightButtonTitle:city];
                [ws.presenter loadDoctorData:province City:city];
            }else{
                [ProgressUtil showError:@"定位失败"];
            }
        }];
    }
}

-(void)setupView{
    self.title = self.navgTitle;
    [self setupTableView];
    [self setupHeaderView];
    
    [self setupRightItem];

}

#pragma mark - 加载子视图

- (void)setupTableView{
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate =self;
    _table.separatorColor = UIColorFromRGB(0x68c0de);
    [self.view addSubview:_table];
    _table.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setupHeaderView{
    UIView* headerView = [UIView new];
    headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _tf = [RightViewTextField new];
    _tf.background = [UIImage imageNamed:@"select_searchBar"];
    _tf.font = [UIFont systemFontOfSize:16];
    _tf.placeholder = @"查询医生/科室/病例";
    [headerView addSubview:_tf];
    
    UIView* rightView = [UIView new];
    _tf.rightView = rightView;
    _tf.rightViewMode = UITextFieldViewModeAlways;
    UIImageView* rightImageView = [UIImageView new];
    rightImageView.userInteractionEnabled = YES;
    rightImageView.image = [UIImage imageNamed: @"select_search"];
    [rightView addSubview:rightImageView];
    UIButton* rightButton = [UIButton new];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorFromRGB(0x868686) forState:UIControlStateNormal];
    [rightView addSubview:rightButton];
    
    _hospitalButton = [FDSelectButton new];
    _hospitalButton.title = @"医院:";
    [headerView addSubview:_hospitalButton];
    [_hospitalButton addTarget:self action:@selector(hospitalAction) forControlEvents:UIControlEventTouchUpInside];
    
    _departmentButton = [FDSelectButton new];
    _departmentButton.title = @"科室:";
    [headerView addSubview:_departmentButton];
    [_departmentButton addTarget:self action:@selector(departmentAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = @"医生";
    titleLabel.textColor = UIColorFromRGB(0x85d5f1);
    [headerView addSubview:titleLabel];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorFromRGB(0x68c0de);
    [headerView addSubview:line];
    
    _tf.sd_layout.leftSpaceToView(headerView,10).rightSpaceToView(headerView,10).topSpaceToView(headerView,10).heightIs(40);
    _tf.sd_cornerRadiusFromHeightRatio = @0.5;
    rightView.frame = CGRectMake(0,0,100,_tf.height);
    rightImageView.sd_layout.topSpaceToView(rightView,10).bottomSpaceToView(rightView,10).leftSpaceToView(rightView,10).widthEqualToHeight();
    rightButton.sd_layout.leftSpaceToView(rightImageView,15).rightSpaceToView(rightView,20).topEqualToView(rightImageView).bottomEqualToView(rightImageView);
    
    headerView.sd_equalWidthSubviews = @[_hospitalButton,_departmentButton];
    _hospitalButton.sd_layout.leftEqualToView(headerView).topSpaceToView(_tf,10).heightIs(50);
    _departmentButton.sd_layout.leftSpaceToView(_hospitalButton,0).rightEqualToView(headerView).topEqualToView(_hospitalButton).heightIs(50);

    titleLabel.sd_layout.leftSpaceToView(headerView,20).topSpaceToView(_hospitalButton,10).heightIs(18);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    line.sd_layout.leftEqualToView(headerView).rightEqualToView(headerView).topSpaceToView(titleLabel,10).heightIs(1);
    
    [headerView setupAutoHeightWithBottomView:line bottomMargin:0];
    [headerView layoutSubviews];
    
    _table.tableHeaderView = headerView;
}

//定位按钮
- (void)setupRightItem{
    //图片
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 25);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"ac_address"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* imageItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    //标题
    UIBarButtonItem * titleItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    self.navigationItem.rightBarButtonItems = @[imageItem,titleItem];
    _titleItem = titleItem;
}


#pragma mark - 代理
/**
 *  tableView的数据源代理
 *
 *  @param tableView tableView description
 *  @param section   section description
 *
 *  @return <#return value description#>
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_doctor";
    SelectFamilyDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SelectFamilyDoctorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DoctorList* doctor = self.dataSource[indexPath.row];
    cell.doctor = doctor;

    cell.sd_indexPath = indexPath;
    cell.sd_tableView = tableView;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.isCollectDoctor){
//        [self.navigationController pushViewController:[ACDoctorDetailViewController new] animated:YES];
    }else{
        FDApplyDoctorViewController* apply = [FDApplyDoctorViewController new];
        apply.doctor = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:apply animated:YES];

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorList* doctor = self.dataSource[indexPath.row];
    
    return [_table cellHeightForIndexPath:indexPath model:doctor keyPath:@"doctor" cellClass:[SelectFamilyDoctorTableViewCell class] contentViewWidth:[self cellContentViewWith]];
//    return 130;
}



-(void)fetchFamilyDoctorData:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        self.dataSource = self.presenter.dataSource;
        [_table reloadData];
        
    }else{
        [ProgressUtil showError:info];
    }
}

-(void)onCompletionDepart:(BOOL)success info:(NSString *)info{
    if(success){
        
        if(self.presenter.departSource.count == 0){
            [ProgressUtil showError:@"对不起，没查询到对应的科室!"];
            return ;
        }
        [ProgressUtil dismiss];
        self.departArray = self.presenter.departSource;
        CGRect rect = [self.view convertRect:_departmentButton.frame toView:self.view];
        self.departMenu=[[JHCustomMenu alloc] initWithDataArr:self.departArray origin:CGPointMake(rect.origin.x, CGRectGetMaxY(rect)) width:kScreenWidth/2 rowHeight:37 rowNumber:10];
        self.departMenu.delegate = self;
        self.departMenu.tableView.tag = 1002;
        [self.view addSubview:self.departMenu];
        WS(ws);
        self.departMenu.dismiss = ^(){
            ws.departMenu = nil;
        };
        
    }else{
        [ProgressUtil showError:info];
    }
}

-(void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 1001){
    //医院
        NSString* hospital = self.hospitalArray[indexPath.row];
        [_hospitalButton setTitle:hospital forState:UIControlStateNormal];
    }else if (tableView.tag == 1002){
    //科室
        NSString* depart = self.departArray[indexPath.row];
        [_departmentButton setTitle:depart forState:UIControlStateNormal];
    }


}

#pragma mark - 点击事件

/**
 *  导航栏右边点击按钮
 *
 *  @param sender <#sender description#>
 */
-(void)rightItemAction:(id)sender{
    
   NSArray* province = [ProvinceEntity MR_findAll];
   NSMutableArray* proArray = [NSMutableArray arrayWithCapacity:province.count];
    for(ProvinceEntity* pro in province){
        [proArray addObject:pro.ssqName];
    }

    NSString* provinceName = self.province;
    if(!self.province.length){
        provinceName = @"北京";
    }
    NSString* cityName = self.city;
    if(!self.city.length){
        cityName = @"东城区";
    }
    
   NSArray* city = [CityEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"provinceName CONTAINS %@",provinceName]];
    NSMutableArray* cityArray = [NSMutableArray arrayWithCapacity:city.count];
    for(CityEntity* c in city){
        [cityArray addObject:c.ssqName];
    }
    
    LCPickerView* pickerView = [[LCPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if(proArray.count !=0 ){
        pickerView.proArray = proArray;
    }
    if(cityArray.count != 0){
        pickerView.cityArray = cityArray;
    }
//    pickerView.currentProvince = self.province;
//    pickerView.currentCity = self.city;
    pickerView.currentProvince = provinceName;
    pickerView.currentCity = cityName;

    __weak typeof(pickerView) weakPicker = pickerView ;
    WS(ws);
    [pickerView showPickerViewCompletetionHandler:^(NSString *province, NSString *city) {
        ws.province = province;
        ws.city = city;
        
        [self resetRightButtonTitle:city];
        
        [weakPicker dismiss];
        
        [ProgressUtil show];
        [ws.presenter loadDoctorData:province City:city];
        
    }];
    
}

- (void)rightAction{
    NSArray* province = [ProvinceEntity MR_findAll];
    NSMutableArray* proArray = [NSMutableArray arrayWithCapacity:province.count];
    for(ProvinceEntity* pro in province){
        [proArray addObject:pro.ssqName];
    }
    
    NSString* provinceName = self.province;
    if(!self.province.length){
        provinceName = @"北京";
    }
    NSString* cityName = self.city;
    if(!self.city.length){
        cityName = @"东城区";
    }
    
    NSArray* city = [CityEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"provinceName CONTAINS %@",provinceName]];
    NSMutableArray* cityArray = [NSMutableArray arrayWithCapacity:city.count];
    for(CityEntity* c in city){
        [cityArray addObject:c.ssqName];
    }
    
    LCPickerView* pickerView = [[LCPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if(proArray.count !=0 ){
        pickerView.proArray = proArray;
    }
    if(cityArray.count != 0){
        pickerView.cityArray = cityArray;
    }
    //    pickerView.currentProvince = self.province;
    //    pickerView.currentCity = self.city;
    pickerView.currentProvince = provinceName;
    pickerView.currentCity = cityName;
    
    __weak typeof(pickerView) weakPicker = pickerView ;
    WS(ws);
    [pickerView showPickerViewCompletetionHandler:^(NSString *province, NSString *city) {
        ws.province = province;
        ws.city = city;
        
        [self resetRightButtonTitle:city];
        
        [weakPicker dismiss];
        
        [ProgressUtil show];
        [ws.presenter loadDoctorData:province City:city];
        
    }];
    

}

/**
 *  选择医院
 */
- (void)hospitalAction{
    
    NSString* cityID = [CityEntity findCityID:self.city];
    
    self.hospitalArray = [HospitalEntity findHospatialName:cityID];
   CGRect rect = [self.view convertRect:_hospitalButton.frame toView:self.view];
     self.hospitalMenu=[[JHCustomMenu alloc] initWithDataArr:self.hospitalArray origin:CGPointMake(0, CGRectGetMaxY(rect)) width:kScreenWidth/2 rowHeight:37 rowNumber:10];
    self.hospitalMenu.delegate = self;
    self.hospitalMenu.tableView.tag = 1001;
    [self.view addSubview:self.hospitalMenu];
    WS(ws);
    self.currentHospatial = nil;
    self.hospitalMenu.dismiss = ^(){
        ws.currentHospatial = ws.hospitalMenu.currentMenu;
        ws.hospitalMenu = nil;
    };
}

/**
 *  选择科室
 */
- (void)departmentAction{
   //判断是否选择了医院
    if(self.currentHospatial.length == 0){
        [ProgressUtil showInfo:@"请先选择医院"];
        return ;
    }
    
   //判断数据库是否有该医院的科室，没有就请求
   NSInteger hospatialID = [HospitalEntity findHospatialIDWithName:self.currentHospatial];
    if([DepartmentEntity departIsExist:hospatialID]){
    //存在从数据库获取
        self.departArray = [DepartmentEntity findDepartNameWithHospatialID:hospatialID];
        CGRect rect = [self.view convertRect:_departmentButton.frame toView:self.view];
        self.departMenu=[[JHCustomMenu alloc] initWithDataArr:self.departArray origin:CGPointMake(rect.origin.x, CGRectGetMaxY(rect)) width:kScreenWidth/2 rowHeight:37 rowNumber:10];
        self.departMenu.delegate = self;
        self.departMenu.tableView.tag = 1002;
        [self.view addSubview:self.departMenu];
        WS(ws);
        self.departMenu.dismiss = ^(){
            ws.departMenu = nil;
        };

    }else{
    //从接口拉取
        [ProgressUtil show];
        [self.presenter loadHospatialDepart:hospatialID];
    }
    
}

#pragma mark - setter
-(UIButton *)rightButton{
    if(!_rightButton){
//        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _rightButton.backgroundColor = [UIColor redColor];
//        [_rightButton setImage:[UIImage imageNamed:@"ac_address"] forState:UIControlStateNormal];
//        _rightButton.size = CGSizeMake(150, 40);
//        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        _rightButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 130, 0, 0)];
    }
    return _rightButton ;
}

#pragma mark - 

- (NSString*)getCurrentCity{
    NSString* city = _appDelegate.city;
    NSString* province = _appDelegate.proVince;
    self.city = city;
    self.province = province;
    
    NSRange range = [city rangeOfString:@"市"];
    if(range.location != NSNotFound){
        NSMutableString* temp = [NSMutableString stringWithString:city];
        [temp deleteCharactersInRange:range];
        return temp ;
    }
    return city ;
}

- (BOOL)cityIsExist{
    _appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString* city = _appDelegate.city;
    if(city.length == 0){
        return NO;
    }
    return YES;
}

/**
 *  重置导航栏右边按钮标题
 *
 *  @param title <#title description#>
 */
- (void)resetRightButtonTitle:(NSString*) title{
//    NSString* result = [title deleteCharacter:@"市"];
    
    

    
//    if(result.length==2){
//        [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
//    }else if(result.length ==3){
//        [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
//    }else if(result.length == 4){
//        [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//    }else if(result.length == 5){
//        [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//    }else{
//       NSString* subString = [result substringToIndex:5];
//        result = nil;
//        result = subString;
//        [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//    }
//    [self.rightButton setTitle:result forState:UIControlStateNormal];
//   CGFloat width = [JMFoundation calLabelWidth:self.rightButton.titleLabel.font andStr:result withHeight:40];
//    NSLog(@"w = %g",width);
//    self.rightButton.size = CGSizeMake(width+40, 40);
    NSString* result = [title deleteCharacter:@"市"];
    [_titleItem setTitle:result];

}

- (CGFloat)cellContentViewWith
{
    CGFloat width = kScreenWidth;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

///**
// *  从数据库加载医院
// *
// *  @return <#return value description#>
// */
//- (NSMutableArray*)loadHospitalFromDatabase{
//    NSArray* cityList = [CityEntity MR_findByAttribute:@"ssqName" withValue:self.city];
//    CityEntity* city = [cityList firstObject];
//    NSArray* hospitalList = [HospitalEntity MR_findByAttribute:@"cityId" withValue:city.ssqId];
//    NSMutableArray* dataArray = [NSMutableArray array];
//    for(HospitalEntity* h in hospitalList){
//        [dataArray addObject:h.hName];
//    }
//    return dataArray;
//}
//
///**
// *  从数据库加载科室
// *
// *  @return <#return value description#>
// */
//- (NSMutableArray*)loadDepartFromDatabase{
//    
//   NSArray* array = [DepartmentEntity MR_findAll];
//    NSMutableArray* dataArray = [NSMutableArray array];
//    for(DepartmentEntity* d in array){
//        [dataArray addObject:d.departName];
//    }
//    
//    return dataArray;
//}




@end
