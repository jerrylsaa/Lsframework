//
//  ParkServiceViewController.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ParkServiceViewController.h"

#import "SucceedSubmitViewController.h"

#import "JHCustomMenu.h"
#import "FPDatePicker.h"
#import "ProgressUtil.h"
#import "FPNetwork.h"
#import "JMFoundation.h"


#define AC_FONT [UIFont systemFontOfSize:(kScreenWidth == 320 ? 14 : 18)]


@interface ParkServiceViewController ()<JHCustomMenuDelegate, UIActionSheetDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_carImageView;//停车图片
    //选择医院
    UILabel *_hospitalLabel;// 您选择的医院
    UIButton *_hospitalButton;
    //到达时间
    UILabel *_arrivalTimeLable;//您选择的到达时间
    UIButton *_arrivalTimeButton;
    
    //联系方式
    UIView *_phoneView;
    UILabel *_phoneLabel;
    UITextField *_phoneText;
    
    //车牌号
    UIView *_carNumView;
    UILabel *_carNumLabel;
    UITextField *_carNumText;
    //温馨提示
    UILabel *_promptLable;
    UILabel *_promptLable1;
    
    //服务
    UIButton *_singleButton;
    UIButton *_packageButton;
    
    
    NSString *hospitalName;//医院名称
 
//    NSString *phoneNum;//联系方式
//    NSString *carNum;//车牌号
    
    
}


@property (nonatomic ,strong)JHCustomMenu *hospitalMenu;

@property(nonatomic,retain) NSMutableArray<NSString* > * hospitalArray;
@property(nonatomic, retain)NSMutableArray<NSString* > * arrivalTimeArray;
@property (nonatomic,strong) NSDate  *goHptDate;//到达时间

@property (nonatomic,strong)NSString *resultTime;

@end

@implementation ParkServiceViewController


-(NSMutableArray *)hospitalArray{
    if(!_hospitalArray){
        _hospitalArray=[NSMutableArray array];
    }
    return _hospitalArray;
}
-(NSMutableArray *)arrivalTimeArray{
    if(!_arrivalTimeArray){
        _arrivalTimeArray=[NSMutableArray array];
    }
    return _arrivalTimeArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)setupView
{
    self.title = @"泊车服务";
    [self setupScrollView];
    [self setupCarImageView];
    [self setupSep];
    [self setupHospitalLabel];
    [self setupArrivalTimeLable];
    [self setupPhoneView];
    [self setupCarNumView];
    [self setupPromptLable];
    [self setupServiceButton];
    
    
    [self loadData];
}

- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 600);
}
#pragma mark 头像
- (void)setupCarImageView{
    _carImageView = [UIImageView new];
    [_scrollView addSubview:_carImageView];
    _carImageView.sd_layout.leftSpaceToView(_scrollView,0).topSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).heightIs(180);
    _carImageView.image = [UIImage imageNamed:@"park_service"];
    
}

#pragma mark 医院名称
- (void)setupHospitalLabel{
    _hospitalLabel = [UILabel new];
    _hospitalLabel.font = AC_FONT;
    [_scrollView addSubview:_hospitalLabel];
    _hospitalLabel.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,50).topSpaceToView(_carImageView,0).heightIs(50);
    UIImageView *buttonImage = [UIImageView new];
    buttonImage.image = [UIImage imageNamed:@"ac_down"];
    [_scrollView addSubview:buttonImage];
    buttonImage.sd_layout.leftSpaceToView(_hospitalLabel,12).rightSpaceToView(_scrollView,13).topSpaceToView(_carImageView,18).heightIs(14);
     _hospitalLabel.text = @"选择您要就诊的医院：";
    
    
    _hospitalButton = [UIButton new];
    [_hospitalButton addTarget:self action:@selector(selectHospitalAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_hospitalButton];
    _hospitalButton.sd_layout.leftSpaceToView(_hospitalLabel,0).topSpaceToView(_carImageView,0).rightSpaceToView(_scrollView,0).heightIs(50);
    
}

#pragma mark 到达时间
-(void)setupArrivalTimeLable
{
    
    _arrivalTimeLable = [UILabel new];
    _arrivalTimeLable.font = AC_FONT;
    [_scrollView addSubview:_arrivalTimeLable];
    _arrivalTimeLable.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,50).topSpaceToView(_hospitalButton,0).heightIs(50);
    UIImageView *buttonImage = [UIImageView new];
    buttonImage.image = [UIImage imageNamed:@"ac_down"];
    [_scrollView addSubview:buttonImage];
    buttonImage.sd_layout.leftSpaceToView(_arrivalTimeLable,12).rightSpaceToView(_scrollView,13).topSpaceToView(_hospitalLabel,18).heightIs(14);
    _arrivalTimeLable.text = @"您预计到达医院的时间：";

    
    _arrivalTimeButton = [UIButton new];
    [_arrivalTimeButton addTarget:self action:@selector(selectArrivalTimeAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_arrivalTimeButton];
    _arrivalTimeButton.sd_layout.leftSpaceToView(_arrivalTimeLable,0).topSpaceToView(_hospitalButton,0).rightSpaceToView(_scrollView,0).heightIs(50);
    
}
#pragma mark 联系方式
- (void)setupPhoneView{
    _phoneView = [UIView new];
    _phoneView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.2];
    [_scrollView addSubview:_phoneView];
    _phoneView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_arrivalTimeButton,0).heightIs(50);
    
    _phoneLabel = [UILabel new];
    _phoneLabel.font = AC_FONT;
    _phoneLabel.text = @"您的联系方式：";
    [_phoneView addSubview:_phoneLabel];
    _phoneLabel.sd_layout.leftSpaceToView(_phoneView,20).topSpaceToView(_phoneView,0).widthIs(150).heightIs(50);
    
    _phoneText = [UITextField new];
    _phoneText.placeholder = @" 请输入您的手机号";
    [_phoneText setValue:AC_FONT forKeyPath:@"_placeholderLabel.font"];
    [_phoneView addSubview:_phoneText];
    _phoneText.sd_layout.leftSpaceToView(_phoneLabel,0).rightSpaceToView(_phoneView,20).topSpaceToView(_phoneView,0).heightIs(50);
}
#pragma mark 车牌号
- (void)setupCarNumView{
    _carNumView = [UIView new];
    _carNumView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.2];
    [_scrollView addSubview:_carNumView];
    _carNumView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_phoneView,0).heightIs(50);
    
    _carNumLabel = [UILabel new];
    _carNumLabel.font = AC_FONT;
    _carNumLabel.text = @"您的车牌号：";
    [_carNumView addSubview:_carNumLabel];
    _carNumLabel.sd_layout.leftSpaceToView(_carNumView,20).topSpaceToView(_carNumView,0).widthIs(150).heightIs(50);
    
    _carNumText = [UITextField new];
    _carNumText.placeholder = @" 请输入您的车牌号";
    [_carNumText setValue:AC_FONT forKeyPath:@"_placeholderLabel.font"];
    [_carNumView addSubview:_carNumText];
    _carNumText.sd_layout.leftSpaceToView(_carNumLabel,0).rightSpaceToView(_carNumView,20).topSpaceToView(_carNumView,0).heightIs(50);
}
#pragma mark 温馨提示
- (void)setupPromptLable{
    
    _promptLable = [UILabel new];
    [_scrollView addSubview:_promptLable];
    _promptLable.sd_layout.leftSpaceToView(_scrollView, 10).rightSpaceToView(_scrollView, 20).topSpaceToView(_carNumView, 20).heightIs(20);
    _promptLable.font = [UIFont systemFontOfSize:12.0f];
    _promptLable.textColor = [UIColor redColor];
//    _promptLable.text = @"*温馨提示：单次购买全程就医陪护业务100元/次";
    _promptLable1 = [UILabel new];
    [_scrollView addSubview:_promptLable1];
    _promptLable1.sd_layout.leftSpaceToView(_scrollView, 70).rightSpaceToView(_scrollView, 20).topSpaceToView(_promptLable, 0).heightIs(20);
    _promptLable1.font = [UIFont systemFontOfSize:12.0f];
    _promptLable1.textColor = [UIColor redColor];
//    _promptLable1.text = @"  购买全程就医陪护套餐服务880元/10次";
    
}
#pragma mark 服务按钮
-(void)setupServiceButton
{
    _singleButton = [UIButton new];
    [_singleButton addTarget:self action:@selector(selectSingleAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_singleButton];
    _singleButton.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_promptLable1,10).rightSpaceToView(_scrollView,10).heightIs(50);
    [_singleButton setBackgroundImage:[UIImage imageNamed:@"ac_commit"] forState:UIControlStateNormal];
    [_singleButton setTitle:@"单次服务" forState:UIControlStateNormal];
    [_singleButton setTintColor:[UIColor whiteColor]];
    
    
    _packageButton = [UIButton new];
    [_packageButton addTarget:self action:@selector(selectPackageAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_packageButton];
    _packageButton.sd_layout.leftSpaceToView(_scrollView,10).topSpaceToView(_singleButton,20).rightSpaceToView(_scrollView,10).heightIs(50);
    [_packageButton setBackgroundImage:[UIImage imageNamed:@"konwmore"] forState:UIControlStateNormal];
    [_packageButton setTitle:@"套餐服务" forState:UIControlStateNormal];

    [_packageButton setTitleColor:UIColorFromRGB(0xf3c156) forState:UIControlStateNormal];
    [_packageButton addTarget:self action:@selector(selectPackageAction) forControlEvents:UIControlEventTouchUpInside];


}

#pragma mark 分割线
- (void)setupSep{
    for (int i = 0; i < 6; i++) {
        UIView *sepView = [UIView new];
        sepView.backgroundColor = UIColorFromRGB(0xdbdbdb);
        [_scrollView addSubview:sepView];
        CGFloat orginY = 180;
//        if (i == 0) {
//            orginY = 180;
       
//        }else{
//            orginY = 230;
//        }
        sepView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_scrollView,orginY + 50*i).heightIs(1);
    }
}
- (void)loadData
{
   
}
#pragma mark 就诊医院
-(void)selectHospitalAction
{
    __weak typeof(self) weakSelf=self;
    //科室数组
        _hospitalArray = @[@"济南儿童医院",@"省立医院",@"这是测试",@"北京肿瘤医院"];
    if(!self.hospitalMenu){
        NSMutableArray* array = self.hospitalArray;
        self.hospitalMenu=[[JHCustomMenu alloc] initWithDataArr:array origin:CGPointMake(kScreenWidth/2, 225 - _scrollView.contentOffset.y) width:kScreenWidth/2 rowHeight:50 rowNumber:4];
        self.hospitalMenu.delegate=self;
        [self.view addSubview:self.hospitalMenu];
        
        self.hospitalMenu.dismiss=^(){
            weakSelf.hospitalMenu=nil;
        };
    }else{
        
        [self.hospitalMenu dismissWithCompletion:^(JHCustomMenu *object) {
            weakSelf.hospitalMenu=nil;
        }];
    }

}
#pragma mark JHCustomMenuDelegate
-(void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    hospitalName = nil ;
    hospitalName = self.hospitalArray[indexPath.row];
    _hospitalLabel.text = [NSString stringWithFormat:@"选择您要就诊的医院：%@",self.hospitalArray[indexPath.row]];
}

#pragma mark 就诊时间
-(void)selectArrivalTimeAction
{
  
    __weak typeof(self) weakSelf = self;
    FPDatePicker * datePicker = [FPDatePicker new];
    datePicker.pickerType =MonthDayHourMinute;
    [datePicker showInView:self.view];
    [datePicker addDatePickerHandler:^(NSString *date, NSDate * d) {
        
        _arrivalTimeLable.text = [NSString stringWithFormat:@"您预计到达医院的时间：%@", [weakSelf showDate:d]];
        weakSelf.goHptDate = [weakSelf showPinDate:d];
        weakSelf.resultTime = [weakSelf showCHNDate:d];
        
    }];
    
}
#pragma mark--转换时间

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


#pragma mark 单次服务
-(void)selectSingleAction
{
    
//    if([[UIDevice currentDevice].systemVersion doubleValue]<8.0){
//        
//        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认购买单次全程就医陪护业务100元/次",@"立即购买",nil];
//        [sheet showInView:self.view];
//        
//
//        return ;
//    }
//    //适配ios8以上
//    UIAlertController* alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    __weak typeof(alert) weakAlert = alert ;
//    UIAlertAction* title=[UIAlertAction actionWithTitle:@"确认购买单次全程就医陪护业务100元/次" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        //        [weakAlert dismissViewControllerAnimated:YES completion:nil];
//    }];
    WS(ws);
//    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"立即购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_phoneText.text == nil || _phoneText.text.length == 0) {
            [ProgressUtil showInfo:@"电话号码不能为空"];
            return;
        }else if (_carNumText.text == nil || _carNumText.text.length == 0){
            [ProgressUtil showInfo:@"车牌号不能为空"];
            return;
        }else if (_carNumText.text.length !=7){
            [ProgressUtil showInfo:@"请输入正确的七位车牌号"];
            return;

        }
    
        
        
        NSDictionary *params = @{@"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId], @"HospitalID":@"8",@"GetToDate":@"", @"GetToTime":_goHptDate, @"LinkTel":_phoneText.text, @"PlateNumber":_carNumText.text};
        
        [[FPNetwork POST:@"AddParkingService" withParams:params] addCompleteHandler:^(FPResponse *response) {
            if (response.isSuccess) {
                
              
                [ProgressUtil showInfo:response.message];
                SucceedSubmitViewController* success = [SucceedSubmitViewController new];
                success.titleArray = @[@"您已经预约成功,",@"稍后会有服务人员与您联系,",@"请保持您的手机畅通"];
                success.subtitleArray = @[[NSString stringWithFormat:@"时间:%@",_resultTime],[NSString stringWithFormat:@"地点:%@",hospitalName]];
//                success.tips = @"* 温馨提示: 预约信息可在首页事件提醒中查看";

                
                [ws.navigationController pushViewController:success animated:YES];

            }else
            {
                [ProgressUtil showInfo:response.message];
            }
        }];
        
        
//        [ws.navigationController pushViewController:[ParkOrderCommitViewController new] animated:YES];
//    }];
//    
//    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [weakAlert dismissViewControllerAnimated:YES completion:nil];
//        
//    }];
//    [alert addAction:title];
//    [alert addAction:confirm];
//    [alert addAction:cancel];
//    [self presentViewController:alert animated:YES completion:nil];

    
    
}
#pragma mark 套餐服务
-(void)selectPackageAction
{
//    if([[UIDevice currentDevice].systemVersion doubleValue]<8.0){
//        
//        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认购买全程就医陪护套餐服务880元/10次",@"立即购买",nil];
//        [sheet showInView:self.view];
//        
//        return ;
//    }
//    //适配ios8以上
//    UIAlertController* alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    __weak typeof(alert) weakAlert = alert ;
//    UIAlertAction* title=[UIAlertAction actionWithTitle:@"确认购买全程就医陪护套餐服务880元/10次" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        //        [weakAlert dismissViewControllerAnimated:YES completion:nil];
//    }];
    WS(ws);
//    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"立即购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_phoneText.text == nil || _phoneText.text.length == 0) {
            [ProgressUtil showInfo:@"电话号码不能为空"];
            return;
        }else if (_carNumText.text == nil || _carNumText.text.length == 0){
            
            [ProgressUtil showInfo:@"车牌号不能为空"];
            return;
        }else if (_carNumText.text.length !=7){
            [ProgressUtil showInfo:@"请输入正确的七位车牌号"];
            return;
            
        }
    
    NSDictionary *params = @{@"UserID":[NSString stringWithFormat:@"%ld",kCurrentUser.userId], @"HospitalID":@"8",@"GetToDate":@"", @"GetToTime":_goHptDate, @"LinkTel":_phoneText.text, @"PlateNumber":_carNumText.text};
    
    [[FPNetwork POST:@"AddParkingService" withParams:params] addCompleteHandler:^(FPResponse *response) {
        if (response.isSuccess) {
            
            
            [ProgressUtil showInfo:response.message];
            SucceedSubmitViewController* success = [SucceedSubmitViewController new];
            success.titleArray = @[@"您已经预约成功,",@"稍后会有服务人员与您联系,",@"请保持您的手机畅通"];
            success.subtitleArray = @[[NSString stringWithFormat:@"时间:%@",_resultTime],[NSString stringWithFormat:@"地点:%@",hospitalName]];
//            success.tips = @"* 温馨提示: 预约信息可在首页事件提醒中查看";
            
            
            [ws.navigationController pushViewController:success animated:YES];
            
        }else
        {
            [ProgressUtil showInfo:response.message];
        }
    }];

    
    
//    }];
//
//    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [weakAlert dismissViewControllerAnimated:YES completion:nil];
//        
//    }];
//    [alert addAction:title];
//    [alert addAction:confirm];
//    [alert addAction:cancel];
//    [self presentViewController:alert animated:YES completion:nil];
//
    
    
    
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
