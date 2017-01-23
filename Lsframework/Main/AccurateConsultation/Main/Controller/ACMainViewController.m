//
//  ACMainViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACMainViewController.h"
#import "ACMainTableViewCell.h"
#import "JHCustomMenu.h"
#import "ACDoctorDetailViewController.h"
#import "ACMainPresenter.h"
#import "HRHealthStaticPageViewController.h"
#import "FDSelectButton.h"
#import "LCPickerView.h"
#import "HospitalEntity.h"



@interface ACMainViewController ()<UITableViewDataSource,UITableViewDelegate,JHCustomMenuDelegate,
    ACMainPresenterDelegate,UIAlertViewDelegate>
{
    
    UILabel *_hospitalLabel;
//    UIButton *_hospitalButton;
    UILabel *_departmentLabel;
//    UIButton *_departmentButton;
    BOOL _address;
    
}
@property(nonatomic ,strong)UITableView *doctorTableView;

@property(nonatomic,retain)JHCustomMenu *hospitalMenu;
@property(nonatomic,retain)JHCustomMenu *departMenu;

@property(nonatomic,strong)UIButton *hospitalButton;
@property(nonatomic,strong)NSMutableArray *hospitalArray;
@property(nonatomic,retain)JHCustomMenu *departmentMenu;
@property(nonatomic,strong)UIButton *departmentButton;
@property(nonatomic,strong)NSMutableArray *departmentArray;
@property (nonatomic, strong) UIBarButtonItem * titleItem;
@property(nonatomic,strong)ACMainPresenter *presenter;

/***/
@property(nonatomic,retain) FDSelectButton* hospitalbt;
@property(nonatomic,retain) FDSelectButton* departbt;


@property(nonatomic,retain) NSString* provinceName;
@property(nonatomic,retain) NSString* cityName;

@property(nonatomic,copy) NSString* currentHospatial;
@property(nonatomic,copy) NSString* currentDepart;
@property(nonatomic,retain) NSArray* hospitalDataSource;
@property(nonatomic,retain) NSArray* departDataSource;
@property (nonatomic,copy) NSString *decodedUrl;
@end

@implementation ACMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString* provinceName = nil;
    NSString* cityName = nil;
    if([CityEntity cityIsExist]){
        CityEntity* city = [CityEntity getCityFromLocal];
        provinceName = city.provinceName;
        cityName = city.ssqName;
    }else{
        provinceName = @"山东省";
        cityName = @"济南市";
    }
    
    NSString* result = [cityName deleteCharacter:@"市"];
    [_titleItem setTitle:result];
    self.provinceName = provinceName;
    self.cityName = cityName;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载子视图
- (void)setupView{
    _presenter = [ACMainPresenter new];
    _presenter.aCMaindelegate =self;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddress) name:@"dismiss" object:nil];
    if (self.mainType == MainTypeBooking) {
        self.title = @"普通门诊预约";
    }else{
        self.title = @"精准咨询";
    }
    [self setupSelectView];
    [self setUpTableView];
    [self setupRightItem];
//    [self location];
}

- (void)setupSelectView{
    _hospitalbt = [FDSelectButton new];
    _hospitalbt.title = @"医院:";
    [self.view addSubview:_hospitalbt];
    [_hospitalbt addTarget:self action:@selector(hospitalAction) forControlEvents:UIControlEventTouchUpInside];

    _departbt = [FDSelectButton new];
    _departbt.title = @"科室:";
    [self.view addSubview:_departbt];
    [_departbt addTarget:self action:@selector(departmentAction) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    UIView *sep_1 = [UIView new];
    sep_1.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [self.view addSubview:sep_1];
    
    self.view.sd_equalWidthSubviews = @[_hospitalbt,_departbt];
    _hospitalbt.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(50);
    _departbt.sd_layout.leftSpaceToView(_hospitalbt,0).rightSpaceToView(self.view,0).topEqualToView(_hospitalbt).heightRatioToView(_hospitalbt,1);
    
    sep_1.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(_hospitalbt,0).heightIs(1);
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

- (void)setUpTableView{
    _doctorTableView = [UITableView new];
    _doctorTableView.dataSource = self;
    _doctorTableView.delegate = self;
    [_doctorTableView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_doctorTableView];
    _doctorTableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,51).bottomSpaceToView(self.view,0);
    
    WS(ws);
    //下拉刷新
    _doctorTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if(ws.currentHospatial.length == 0 || ws.currentDepart.length == 0){
            [ProgressUtil showInfo:@"请选择医院/科室"];
            [_doctorTableView.mj_header endRefreshing];
            return ;
        }
        
        ws.presenter.provinceId = [NSNumber numberWithInteger:[[ProvinceEntity findProvinceID:ws.provinceName] integerValue]];
        ws.presenter.cityId = [CityEntity findCityID:ws.cityName];
        ws.presenter.hospitalId = [NSNumber numberWithInteger:[HospitalEntity findHospatialIDWithName:ws.currentHospatial]];
        ws.presenter.departId = [NSNumber numberWithInteger:[DepartmentEntity findDepartID:ws.currentDepart]];
       
        [ws.presenter loadDoctorDta];
    }];
    //上拉加载
    _doctorTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if(ws.currentHospatial.length == 0 || ws.currentDepart.length == 0){
            [ProgressUtil showInfo:@"请选择医院/科室"];
            [_doctorTableView.mj_footer endRefreshing];
            return ;
        }

        
        [ws.presenter loadMoreDoctroDtaa];
    }];

}
//定位Action
- (void)location{
//    WS(ws);
//    [ProgressUtil showInfo:@"正在定位，请稍后"];
//    [self.presenter locationWithBlock:^(NSString *province, NSString *city, BOOL success) {
//        [ws.titleItem setTitle:city];
//        [ws.doctorTableView reloadData];
//        [ws.doctorTableView.mj_header endRefreshing];
//    }];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _presenter.doctorDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell_doctor";
    ACMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ACMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.doctor = _presenter.doctorDataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
    view.backgroundColor = UIColorFromRGB(0Xefefef);
    UILabel *doctorLabel = [UILabel new];
    doctorLabel.text = @"医生";
    doctorLabel.textColor = UIColorFromRGB(0x85d5f1);
    doctorLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:doctorLabel];
    doctorLabel.sd_layout.leftSpaceToView(view,20).rightSpaceToView(view,20).topSpaceToView(view,10).bottomSpaceToView(view,10);
    
    UIView *sep_2 = [UIView new];
    sep_2.backgroundColor = UIColorFromRGB(0x68c0de);
    [view addSubview:sep_2];
    sep_2.sd_layout.leftSpaceToView(view,0).rightSpaceToView(view,0).bottomSpaceToView(view,0).heightIs(1);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ACMainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ACDoctorDetailViewController *vc = [ACDoctorDetailViewController new];
    
    if (self.mainType == MainTypeBooking) {
        vc.docDetailType = DoctorDetailTypeBooking;
    }
    
    //将医院科室保存到本地
    [self.currentHospatial saveText:@"hospital"];
    [self.currentDepart saveText:@"depart"];
    
    
    vc.doctorId = ((DoctorList *)_presenter.doctorDataSource[indexPath.row]).DoctorID;
    vc.headImage = cell.headImageView.image;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Action

//选择城市
- (void)rightAction{
    NSArray* province = [ProvinceEntity MR_findAll];
    NSMutableArray* proArray = [NSMutableArray arrayWithCapacity:province.count];
    for(ProvinceEntity* pro in province){
        [proArray addObject:pro.ssqName];
    }
    
    //如果当前城市没有，默认是北京，东城区
    NSString* provinceName = self.provinceName;
    if(!self.provinceName.length){
        provinceName = @"北京";
    }
    NSString* cityName = self.cityName;
    if(!self.cityName.length){
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
    pickerView.currentProvince = provinceName;
    pickerView.currentCity = cityName;
    
    __weak typeof(pickerView) weakPicker = pickerView ;
    WS(ws);
    [pickerView showPickerViewCompletetionHandler:^(NSString *province, NSString *city) {
        
        if(![city isEqualToString:ws.cityName]){
            [_hospitalbt setTitle:@"医院:" forState:UIControlStateNormal];
            [_departbt setTitle:@"科室:" forState:UIControlStateNormal];
        }
        
        ws.provinceName = province;
        ws.cityName = city;
        
        NSString* result = [city deleteCharacter:@"市"];
        [_titleItem setTitle:result];

        //将城市保存到本地
        [CityEntity saveCityToLocal:city];

        
        [weakPicker dismiss];
    }];
    //    if (_address == NO) {
    //        [_presenter showPickerInView:self.view];
    //        _address = YES;
    //    }else{
    //        [_presenter dismissPicker];
    //        _address = NO;
    //    }
}


- (void)hospitalAction{

    //判断是否选择了城市
    if(_titleItem.title.length == 0){
        [ProgressUtil showInfo:@"请先选择城市"];
        return ;
    }
    
    
    if([HospitalEntity hospistalIsExist:self.cityName]){
    //存在从数据库加载
        self.hospitalDataSource = [HospitalEntity findHospatialName:[CityEntity findCityID:self.cityName]];
        if(self.hospitalDataSource.count == 0){
            [ProgressUtil showInfo:@"没有搜索到当前城市医院"];
            return ;
        }
        
        [self.view addSubview:self.hospitalMenu];
        
        
        WS(ws);
        self.hospitalMenu.dismiss = ^(){
            if(ws.hospitalMenu.currentMenu.length != 0 ){
                ws.currentHospatial = nil;
                ws.currentHospatial = ws.hospitalMenu.currentMenu;
            }
            ws.hospitalMenu = nil;
        };

    }else{
    //从接口拉取
        [_presenter loadHospitalWith:self.cityName];
    }
}

- (void)departmentAction{
    
    //判断是否选择了医院
    if(self.currentHospatial.length == 0){
        [ProgressUtil showInfo:@"请先选择医院"];
        return ;
    }
    
    //判断数据库是否有该医院的科室，没有就请求
    if([DepartmentEntity departIsExist:[HospitalEntity findHospatialIDWithName:self.currentHospatial]]){
        //存在从数据库获取
        self.departDataSource = [DepartmentEntity findDepartNameWithHospatialID:[HospitalEntity findHospatialIDWithName:self.currentHospatial]];
        
        if(self.departDataSource.count == 0){
            [ProgressUtil showInfo:@"没有搜索到当前医院科室"];
            
            [_presenter.doctorDataSource removeAllObjects];
            [_doctorTableView reloadData];
            
            return ;
        }

        
        [self.view addSubview:self.departMenu];
        WS(ws);
        self.departMenu.dismiss = ^(){
            if(ws.departMenu.currentMenu.length != 0){
                [ws.doctorTableView.mj_header beginRefreshing];
                ws.currentDepart = nil;
                ws.currentDepart = ws.departMenu.currentMenu;
            }
            ws.departMenu = nil;
        };

    }else{
        //从接口拉取
        [self.presenter loadHospatialDepart:[HospitalEntity findHospatialIDWithName:self.currentHospatial]];
    }
}



#pragma mark - 代理

-(void)onCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        
        if(_presenter.hospitalDataSource.count == 0){
            [ProgressUtil showInfo:@"没有搜索到当前城市医院"];
            return ;
        }
        
        NSArray* resultArray = [_presenter.hospitalDataSource sortedArrayUsingComparator:^NSComparisonResult(NSDictionary*  _Nonnull obj1, NSDictionary*  _Nonnull obj2) {
            NSComparisonResult result = [obj1[@"HName"] compare:obj2[@"HName"]];
            return result == NSOrderedDescending;
        }];
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:resultArray.count];
        for(NSDictionary* dic in resultArray){
            [array addObject:dic[@"HName"]];
        }
        
        self.hospitalDataSource = array;
        [self.view addSubview:self.hospitalMenu];
        WS(ws);
        self.currentHospatial = nil;
        self.hospitalMenu.dismiss = ^(){
            ws.currentHospatial = ws.hospitalMenu.currentMenu;
            ws.hospitalMenu = nil;
        };

    }else{
        [ProgressUtil showError:message];
    }
}

- (void)departOnCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        if(_presenter.departDataSource.count == 0){
            [ProgressUtil showInfo:@"没有搜索到当前医院科室"];
            
            [_presenter.doctorDataSource removeAllObjects];
            [_doctorTableView reloadData];

            
            return ;
        }
        
        NSArray* resultArray = [_presenter.departDataSource sortedArrayUsingComparator:^NSComparisonResult(NSDictionary*  _Nonnull obj1, NSDictionary*  _Nonnull obj2) {
            NSComparisonResult result = [obj1[@"DepartName"] compare:obj2[@"DepartName"]];
            return result == NSOrderedDescending;
        }];
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:resultArray.count];
        for(NSDictionary* dic in resultArray){
            [array addObject:dic[@"DepartName"]];
        }
        
        self.departDataSource = array;
        [self.view addSubview:self.departMenu];
        WS(ws);
        self.departMenu.dismiss = ^(){
            if(ws.departMenu.currentMenu.length != 0){
                [ws.doctorTableView.mj_header beginRefreshing];
                ws.currentDepart = nil;
                ws.currentDepart = ws.departMenu.currentMenu;
            }
            ws.departMenu = nil;
        };
    }else{
        [ProgressUtil showError:message];
    }
}

- (void)doctorOnCompletion:(BOOL)success info:(NSString *)message{
    [_doctorTableView.mj_footer resetNoMoreData];
    [_doctorTableView.mj_header endRefreshing];
    if(success){
        [_doctorTableView reloadData];
    }else{
        [ProgressUtil showError:message];
    }
}

- (void)doctorMoreDataOnCompletion:(BOOL)success info:(NSString *)message{
    if(success){
        if(self.presenter.noMoreData){
            
            [_doctorTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        [_doctorTableView.mj_footer endRefreshing];
        [_doctorTableView reloadData];
    }else{
        [_doctorTableView.mj_footer endRefreshing];
        [ProgressUtil showError:message];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(buttonIndex==1){
            HRHealthStaticPageViewController* staticPage = [HRHealthStaticPageViewController new];
            staticPage.pageType =@"ChildrenHospitalAppointment";
            staticPage.staticPageURL = self.decodedUrl;
        NSLog(@"%@",self.decodedUrl);
            [self.navigationController pushViewController:staticPage animated:YES];
        }
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

//}

-(void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag == 1001){
        //医院
        NSString* hospital = self.hospitalDataSource[indexPath.row];
        [_hospitalbt setTitle:hospital forState:UIControlStateNormal];
        
        //判断是不是选择儿童医院，如果是这跳到h5页面
        NSInteger hospitalID = [HospitalEntity findHospatialIDWithName:hospital];
        if(hospitalID == 1){
            [self loadChildrenH5Ctrl];
        }
        
        //
        if(![self.currentHospatial isEqualToString:hospital] && self.currentHospatial.length != 0){
            [_departbt setTitle:@"科室:" forState:UIControlStateNormal];
        }
        
        
    }else if (tableView.tag == 1002){
        //科室
        NSString* depart = self.departDataSource[indexPath.row];
        [_departbt setTitle:depart forState:UIControlStateNormal];
    }
    
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

#pragma mark ChildrenH5
- (void)loadChildrenH5Ctrl {
    [self.doctorTableView.mj_header endRefreshing];
    NSLog(@"跳转儿童医院2");
    WS(ws);
    [[FPNetwork POST:@"GetConfigByUserID" withParams:nil] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            
            NSDictionary *dataDic =response.data;
            NSNumber *tasd =[dataDic valueForKey:@"openetyyorder"];
            if ([tasd integerValue]==1) {
                
                NSString *encodedUrl =[dataDic valueForKey:@"etyyorderurl"];
                ws.decodedUrl =[ws URLDecodedString:encodedUrl];
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"温馨提示" message:@"儿童医院请到挂号系统注册预约" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];

            }
            else {
                
            }
        }
        else {
            [ProgressUtil showError:response.message];
        }
        
    }];
    /*HRHealthStaticPageViewController* staticPage = [HRHealthStaticPageViewController new];
     staticPage.pageType =@"ChildrenHospitalAppointment";
     staticPage.staticPageURL = @"http://114.215.109.184/hospital/yuyue_wu.html";
     
     if([[UIDevice currentDevice].systemVersion doubleValue]<8.0){
     
     UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"您确定要跳转至儿童医院预约界面吗?",@"确定",nil];
     [sheet showInView:self.view];*/
    
    
    //    }
    //适配ios8以上
    /*UIAlertController* alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     __weak typeof(alert) weakAlert = alert ;
     UIAlertAction* title=[UIAlertAction actionWithTitle:@"您确定要跳转至儿童医院预约界面吗?" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
     //        [weakAlert dismissViewControllerAnimated:YES completion:nil];
     }];
     
     WS(ws);
     UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     [ws.navigationController pushViewController:staticPage animated:YES];
     }];
     
     UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
     
     }];
     [alert addAction:title];
     [alert addAction:confirm];
     [alert addAction:cancel];
     [self presentViewController:alert animated:YES completion:nil];
     */
    
}



- (void)changeAddress{
    _address = NO;
}

#pragma mark - 懒加载
-(NSMutableArray *)hospitalArray{
    if(!_hospitalArray){
        _hospitalArray=[NSMutableArray array];
    }
    return _hospitalArray;
}

-(NSMutableArray *)departmentArray{
    if(!_departmentArray){
        _departmentArray=[NSMutableArray array];
    }
    return _departmentArray;
}

- (JHCustomMenu *)hospitalMenu{
    if(!_hospitalMenu){
        CGRect rect = [self.view convertRect:_hospitalbt.frame toView:self.view];
        _hospitalMenu=[[JHCustomMenu alloc] initWithDataArr:self.hospitalDataSource origin:CGPointMake(0, CGRectGetMaxY(rect)) width:kScreenWidth/2 rowHeight:37 rowNumber:10];
        _hospitalMenu.delegate = self;
        _hospitalMenu.tableView.tag = 1001;
    }
    return _hospitalMenu;
}

-(JHCustomMenu *)departMenu{
    if(!_departMenu){
        CGRect rect = [self.view convertRect:_departbt.frame toView:self.view];
        _departMenu=[[JHCustomMenu alloc] initWithDataArr:self.departDataSource origin:CGPointMake(rect.origin.x, CGRectGetMaxY(rect)) width:kScreenWidth/2 rowHeight:37 rowNumber:10];
        _departMenu.delegate = self;
        _departMenu.tableView.tag = 1002;
    }
    return _departMenu;
}



#pragma mark -
- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismiss" object:nil];
}
@end
