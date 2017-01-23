//
//  WholetimeAssisstController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "WholetimeAssisstController.h"
#import "FPDatePicker.h"
#import "ZHCityPicker.h"
#import "LocationManager.h"
#import "FPNetwork.h"
#import "JMFoundation.h"
#import "WholeAssistModel.h"
#import "SucceedSubmitViewController.h"
@interface WholetimeAssisstController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,ZHCityPickerDelegate>{

    BOOL _address;
    int isPickup;
}

@property (nonatomic, strong) WholeAssistModel * model;
@property(nonatomic ,strong)UIButton *rightButton;
@property (nonatomic ,strong)ZHCityPicker *cityPicker;

@property (nonatomic,strong)NSMutableArray *hptArr;
@property (nonatomic,strong)NSString *hptId;
@property (nonatomic,strong)NSMutableString *resultHpt;
@property (nonatomic,strong)NSMutableString *cityHpt;

@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,strong)NSArray *hospitalArr;


@property (nonatomic,strong)NSString *resultTime;

@property (nonatomic) NSUInteger indexSelectHpt;
@property (nonatomic,strong) NSDate  *goHptDate;
@property (nonatomic,strong) NSString *pickupDate;
@property (weak, nonatomic) IBOutlet UIView *goHospitalView;
@property (weak, nonatomic) IBOutlet UILabel *goHospitalLabel;
@property (weak, nonatomic) IBOutlet UITableView *goHospitalTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goHptTableHeight;
@property (weak, nonatomic) IBOutlet UIView *goHptTimeView;
@property (weak, nonatomic) IBOutlet UILabel *goHptTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *didNeedTexiBtn
;
@property (weak, nonatomic) IBOutlet UIButton *noNeedTexiBtn;
@property (weak, nonatomic) IBOutlet UIView *enterAddressView;
@property (weak, nonatomic) IBOutlet UITextView *enterAddressTextView;
@property (weak, nonatomic) IBOutlet UIView *pickUpTimeView;

@property (weak, nonatomic) IBOutlet UILabel *pickupLabel;

@property (weak, nonatomic) IBOutlet UITextField *enterPhoneField;

@property (weak, nonatomic) IBOutlet UIButton *oneTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *multipleBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterHeight;



@end

@implementation WholetimeAssisstController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    [self setupRightItem];
    
    [self setGesture];
    
    [self location];
}

- (void)setUpView {

    self.title =@"全程就医陪护";
    
    _indexSelectHpt=-1;
    [_didNeedTexiBtn addTarget:self action:@selector(selectTexiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_noNeedTexiBtn addTarget:self action:@selector(selectTexiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _noNeedTexiBtn.selected =YES;
    
    _enterAddressView.userInteractionEnabled =NO;
    _pickUpTimeView.userInteractionEnabled =NO;
    
    [_goHospitalTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [_oneTimeBtn addTarget:self action:@selector(requestData:) forControlEvents:UIControlEventTouchUpInside];
    _oneTimeBtn.tag =1000;
    
    [_multipleBtn addTarget:self action:@selector(requestData:) forControlEvents:UIControlEventTouchUpInside];
    _multipleBtn.tag =1001;
    
}

- (void)setGesture {
    UITapGestureRecognizer* tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerView:)];
    [_goHptTimeView addGestureRecognizer:tap1];

    UITapGestureRecognizer* tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerView:)];
    [_pickUpTimeView addGestureRecognizer:tap2];

    UITapGestureRecognizer* tap3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGoHptViewExtend)];
    [_goHospitalView addGestureRecognizer:tap3];

}

- (void)showPickerView:(UIGestureRecognizer *)tap {

    __weak typeof(self) weakSelf = self;
    FPDatePicker * datePicker = [FPDatePicker new];
    datePicker.pickerType =MonthDayHourMinute;
    [datePicker showInView:weakSelf.view];
    [datePicker addDatePickerHandler:^(NSString *date, NSDate * d) {
        
        if (tap.view ==_goHptTimeView) {
            weakSelf.goHptTimeLabel.text = [weakSelf showDate:d];
            weakSelf.goHptDate =[weakSelf showPinDate:d];
            weakSelf.resultTime =[weakSelf showCHNDate:d];
        }else if (tap.view ==_pickUpTimeView){
            weakSelf.pickupLabel.text = [weakSelf showDate:d];
            weakSelf.pickupDate =[weakSelf showWholeDate:d];
        }
        
    }];

}

- (NSString *)showDate:(NSDate *)date {
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [format setTimeZone:timeZone];
    NSString *str=[format stringFromDate:date];
    NSLog(@"myDate = %@",str);
    return str;
    
}
- (NSDate *)showPinDate:(NSDate *)date {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:([date timeIntervalSince1970]+60*60*8)];
    
    return confromTimesp;
    
}

- (NSString *)showCHNDate:(NSDate *)date {
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY年MM月dd日 HH时mm分"];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [format setTimeZone:timeZone];
    NSString *str=[format stringFromDate:date];

    
    return str;
    
}

- (NSString *)showWholeDate:(NSDate *)date {
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [format setTimeZone:timeZone];
    NSString *str=[format stringFromDate:date];
    NSLog(@"myDate = %@",str);
    return str;
    
}

- (void)requestData:(UIButton *)btn {
    
    if ([_goHospitalLabel.text isEqual:@""]||_goHospitalLabel.text.length==0||_hptId==nil) {
        [ProgressUtil showError:@"请选择您要就诊的医院"];
        return;
    }
    if ([_goHptTimeLabel.text isEqual:@""]||_goHptTimeLabel.text.length==0) {
        [ProgressUtil showError:@"请选择您预计到达医院的时间"];
        return;
    }
    if ([_enterPhoneField.text isEqual:@""]||_enterPhoneField.text.length==0) {
        [ProgressUtil showError:@"请填写您的联系方式"];
        return;
    }else if (![_enterPhoneField.text isPhoneNumber]){
        [ProgressUtil showError:@"请填写正确的手机号码"];
        return;
    }
    
    NSString *addressStr= [NSString string];
    NSString *pickupStr= [NSString string];

    if (_noNeedTexiBtn.selected==YES) {
        addressStr=@"";
        pickupStr =@"";
    }else{
        addressStr =_enterAddressTextView.text;
        pickupStr =_pickupDate;
    }
    NSDictionary * params = @{@"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId],@"HospitalID":_hptId,@"GetToDate":@"",@"GetToTime":_goHptDate,@"IsShuttle":@(isPickup),@"Address":addressStr,@"LinkTel":_enterPhoneField.text,@"ShuttleTime":pickupStr,@"ServiceType":@(btn.tag-1000)};
    
    [[FPNetwork POST:@"AddSeeingADoctor" withParams:params] addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            
            [ProgressUtil showInfo:response.message];
            SucceedSubmitViewController* success = [SucceedSubmitViewController new];
            success.titleArray = @[@"您已经预约成功,",@"稍后会有服务人员与您联系,",@"请保持您的手机畅通"];
            success.subtitleArray = @[[NSString stringWithFormat:@"时间:%@",_resultTime],[NSString stringWithFormat:@"地点:%@",_resultHpt]];
//            success.tips = @"* 温馨提示: 预约信息可在首页事件提醒中查看";
            [self.navigationController pushViewController:success animated:YES];
        }else{
            [ProgressUtil showError:response.message];
            
        }
    }];

}


//定位按钮
- (void)setupRightItem{
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setImage:[UIImage imageNamed:@"ac_address"] forState:UIControlStateNormal];
    _rightButton.size = CGSizeMake(82, 49);
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _rightButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(10, -40, 10, 40)];
    [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 21)];
    [_rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?20:0)){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -28;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
    }else {
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

//定位Action
- (void)location{
    [ProgressUtil showInfo:@"正在定位，请稍后"];
    [self locationWithBlock:^(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success) {
        
    }];
}


//拉取定位省市数据
- (void)locationWithBlock:(LocationManagerBlcok)block{
    WS(ws);
    [[LocationManager shareInstance] getProvinceAndCityWithBlock:^(NSString * province, NSString * city,NSString * longitude, NSString * latitude, BOOL success) {
        if (success == YES) {
            
            [ws.rightButton setTitle:city forState:UIControlStateNormal];
            ws.cityId =[[CityEntity findCityID:city] integerValue];
            ws.model.cityId =ws.cityId;
            ws.cityHpt =[city mutableCopy];

            NSDictionary * params = @{@"City":@(self.cityId)};
            
            [[FPNetwork POST:@"PhoneQueryHospital" withParams:params] addCompleteHandler:^(FPResponse* response) {
                if(response.isSuccess){
                    
                    [ProgressUtil showInfo:response.message];
                    ws.model.data =response.data;
                    ws.hptArr =response.data;
                    [ws.goHospitalTableView reloadData];
                }else{
                    [ProgressUtil showError:response.message];
                    
                }
            }];

        }
    }];
}
#pragma mark ZHCityPickerDelegate
- (void)selected:(CityEntity *)city{
    [_rightButton setTitle:city.ssqName forState:UIControlStateNormal];

    self.cityHpt =[city.ssqName mutableCopy];
    self.model.cityId =[city.ssqId integerValue];
    _cityId =[city.ssqId integerValue];
    
    if (self.model.cityId){
        WS(weakSelf);
        NSDictionary * params = @{@"City":@(self.model.cityId)};
        
        [[FPNetwork POST:@"PhoneQueryHospital" withParams:params] addCompleteHandler:^(FPResponse* response) {
            if(response.isSuccess){
                
                [ProgressUtil showInfo:response.message];
                weakSelf.model.data =response.data;
                weakSelf.hptArr =response.data;
                [weakSelf.goHospitalTableView reloadData];
            }else{
                [ProgressUtil showError:response.message];
                
            }
        }];
    }else {
        [ProgressUtil showError:@"请先定位医院所在的省市"];
        
    }
    


}

//选择城市
- (void)rightAction{
    if (_address == NO) {
        [self.cityPicker showInView:self.view];
        _address = YES;
    }else{
        [self.cityPicker dismiss];
        _address = NO;
    }
}


- (void)selectTexiBtnAction:(UIButton *)btn {
    
    if (btn ==_noNeedTexiBtn) {
        isPickup =0;
        _noNeedTexiBtn.selected =YES;
        _didNeedTexiBtn.selected =NO;
        _enterAddressView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.0];
        _pickUpTimeView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.0];
        _enterAddressView.userInteractionEnabled =NO;
        _pickUpTimeView.userInteractionEnabled =NO;

        
    }else {
        isPickup =1;
        _noNeedTexiBtn.selected =NO;
        _didNeedTexiBtn.selected =YES;
        _enterAddressView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _pickUpTimeView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _enterAddressView.userInteractionEnabled =YES;
        _pickUpTimeView.userInteractionEnabled =YES;

    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqual:@"请输入您详细地址以方便服务人员按时到达"]) {
        textView.text =nil;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    
    CGFloat width = CGRectGetWidth(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    if (newSize.height<95) {
        newSize.height=95;
    }
    _enterHeight.constant = newSize.height;
    
}

- (ZHCityPicker *)cityPicker{
    if (!_cityPicker) {
        _cityPicker = [ZHCityPicker new];
        _cityPicker.delegate = self;
    }
    return _cityPicker;
}


- (WholeAssistModel *)model{
    if (!_model) {
        _model = [WholeAssistModel new];
        
    }
    return _model;
}

- (NSMutableString *)cityHpt {
    if (!_cityHpt) {
        _cityHpt =[NSMutableString string];
    }
    return _cityHpt;
}

- (NSMutableString *)resultHpt {
    if (!_resultHpt) {
        _resultHpt =[NSMutableString string];
    }
    return _resultHpt;
}

- (NSString *)resultTime {
    if (!_resultTime) {
        _resultTime =[NSString string];
    }
    return _resultTime;
}

- (NSMutableArray *)hptArr {
    if (!_hptArr) {
        _hptArr =[NSMutableArray array];
    }
    return _hptArr;
}

-(void)toggleGoHptViewExtend{
    if (self.model.cityId){
        [self changeViewHieghtAndStatusWith:_goHptTableHeight withHeight:_hptArr.count * 44. forView:_goHospitalTableView];
    }else{
        [ProgressUtil showError:@"请先定位医院所在的省市"];
    }
}

-(void)changeViewHieghtAndStatusWith:(NSLayoutConstraint*)constration withHeight:(CGFloat)height forView:(UIView*)view{
    BOOL isShow = view.hidden;
    if (isShow) {
        view.hidden = NO;
    }
    __weak UIView * wkView = view;
    __weak NSLayoutConstraint * wkConstration = constration;
    [UIView animateWithDuration:0.3 animations:^{
        if (isShow) {
            wkConstration.constant = height;
        }else{
            wkConstration.constant = 0.;
        }
        [wkView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!isShow) {
            wkView.hidden = YES;
        }
    }];
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hptArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.backgroundColor = RGB(240, 240, 240);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.textLabel.text = [_hptArr[indexPath.row] objectForKey:@"HName"];
        if (_indexSelectHpt == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    
    return cell;
}


#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    [tableView beginUpdates];
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.goHospitalTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.indexSelectHpt inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        weakSelf.indexSelectHpt = indexPath.row;
        [weakSelf.goHospitalTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        weakSelf.goHospitalLabel.text = [weakSelf.hptArr[indexPath.row] objectForKey:@"HName"];
        weakSelf.resultHpt=[[weakSelf.cityHpt stringByAppendingString:weakSelf.goHospitalLabel.text] mutableCopy];
        weakSelf.hptId =[weakSelf.hptArr[indexPath.row] objectForKey:@"keyid"];
      [weakSelf toggleGoHptViewExtend];
    }];
    [tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
