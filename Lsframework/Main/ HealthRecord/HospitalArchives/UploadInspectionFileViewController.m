//
//  UploadInspectionFileViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "UploadInspectionFileViewController.h"
#import "FPDatePicker.h"
#import "BSCheckProjectViewController.h"
#import "CorePhotoPickerVCManager.h"
#import "CheckHospitalViewController.h"
#import "UploadInspectionFilePresenter.h"
#import<Photos/Photos.h>

@interface UploadInspectionFileViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, upCheckFileDelegate, UIAlertViewDelegate>
{
    FPDatePicker *_datePicker;
    UIAlertController *_alert;
    NSTimer *_timer;
    NSString *myType;
    NSMutableArray *_selectedPhotoArray;
    
    NSInteger _hospitalID;
    NSInteger _projectID;
    NSString *_timeStr;
}

@property (weak, nonatomic) IBOutlet UILabel            *hospitalNameLabel;// 医院名字
@property (weak, nonatomic) IBOutlet UIButton           *hospiNameBtn;// 医院
@property (weak, nonatomic) IBOutlet UILabel            *dateTimeLabel;// 日期
@property (weak, nonatomic) IBOutlet UIButton           *dateTimeBtn;// 日期
@property (weak, nonatomic) IBOutlet UIButton           *upLoadBtn;// 上传
@property (weak, nonatomic) IBOutlet UILabel            *thirdViewLabel;// 第三行的文字
@property (weak, nonatomic) IBOutlet UITextField        *thirdViewTF;// 第三行的输入框
@property (weak, nonatomic) IBOutlet UIImageView        *rightImageView;// 第三行的箭头
@property (weak, nonatomic) IBOutlet UIButton           *thirdViewBtn;// 第三行按钮
@property (weak, nonatomic) IBOutlet UILabel            *fourthViewLabel;// 第四行文字
@property (weak, nonatomic) IBOutlet UILabel            *fourthViewPlaceholder;// 第四行Placeholder
@property (weak, nonatomic) IBOutlet UITextView         *fourthViewTV;// 第四行输入框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthViewTVHeight;// 第四行输入狂高度

@property (nonatomic, strong) UploadInspectionFilePresenter *presenter;

@end

@implementation UploadInspectionFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupView {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    myType = [user objectForKey:@"bsArchivesType"];
    
    if ([myType isEqualToString:@"0"]) {
        self.title = @"上传检查档案";
        _rightImageView.hidden = NO;
        _thirdViewBtn.hidden = NO;
        
    }else if ([myType isEqualToString:@"1"]) {
        self.title = @"上传病历档案";
        _thirdViewLabel.text = @"主诉：";
        _thirdViewTF.hidden = NO;
        _thirdViewTF.delegate = self;
        _fourthViewLabel.text = @"内容:";
        _fourthViewPlaceholder.text = @"请描述您的病情信息，或治疗经过";
        [_upLoadBtn setTitle:@"点击上传病历图片" forState:UIControlStateNormal];
        
    }
    _fourthViewTV.delegate = self;
    
}

- (IBAction)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if ([btn isEqual:_dateTimeBtn]) {
        NSLog(@"您点击了日期");
        
        __weak typeof(self) weakSelf = self;
        FPDatePicker * datePicker = [FPDatePicker new];
        [datePicker setMaxDate:[NSDate date]];
        [datePicker showInView:self.view];
        [datePicker addDatePickerHandler:^(NSString *date, NSDate * d) {
            
            NSLog(@"%@",date);
            
            weakSelf.dateTimeLabel.text = [NSString stringWithFormat:@"您所检查的日期    %@", date];
            _timeStr = date;
            NSDate *myDate = [self showDate:date];
            NSLog(@"%@", myDate);
            
        }];
    }else if ([btn isEqual:_thirdViewBtn]) {
        NSLog(@"您点击了项目");
        BSCheckProjectViewController *vc = [[BSCheckProjectViewController alloc] init];
        vc.sendName = ^(NSString *name, NSInteger num){
            
            _thirdViewLabel.text = [NSString stringWithFormat:@"您所检查的项目    %@", name];
            NSLog(@"项目名称id：%ld", num);
            _projectID = num;
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn == _hospiNameBtn) {
        CheckHospitalViewController *vc = [[CheckHospitalViewController alloc] init];
        vc.sendName = ^(NSString *name, NSInteger num){
            
            _hospitalNameLabel.text = [NSString stringWithFormat:@"您所检查的医院    %@", name];
            NSLog(@"项目名称id：%ld", num);
            _hospitalID = num;
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([btn isEqual:_upLoadBtn]) {
        NSLog(@"您点击了上传");
        [_fourthViewTV resignFirstResponder];
        
        _selectedPhotoArray = [NSMutableArray array];
        
        if ([myType isEqualToString:@"0"]) {
            if (_hospitalNameLabel.text.length > 7 && _dateTimeLabel.text.length > 7 && _thirdViewLabel.text.length > 7) {
                
                [self showSheet];
                
            }else {
                
                _alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整信息" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:_alert animated:YES completion:nil];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
                
            }
            
        }else if ([myType isEqualToString:@"1"]) {
            if (_hospitalNameLabel.text.length > 7 && _dateTimeLabel.text.length > 7 && _thirdViewTF.text.length > 0) {
                
                [self showSheet];
                
            }else {
                
                _alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整信息" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:_alert animated:YES completion:nil];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
                
            }
            
        }
        
    }
    
}

- (void)uploadData {
    
    self.presenter = [[UploadInspectionFilePresenter alloc] init];
    self.presenter.delegate = self;
    [ProgressUtil show];
    
    if ([myType isEqualToString:@"0"]) {
        
        NSLog(@"😇😇😇😇%ld\n%@\n%ld\n%@", _hospitalID, _timeStr, _projectID, _fourthViewTV.text);
        
        [self.presenter requestWithHospitalID:_hospitalID withTimeStr:_timeStr withProjectID:_projectID withOther:_fourthViewTV.text withPhotoArary:_selectedPhotoArray];
    }else if ([myType isEqualToString:@"1"]) {
        
        NSLog(@"😇😇😇😇%ld\n%@\n%@\n%@", _hospitalID, _timeStr, _thirdViewTF.text, _fourthViewTV.text);
        
        [self.presenter requestWithHospitalID:_hospitalID withTimeStr:_timeStr withComplained:_thirdViewTF.text withOther:_fourthViewTV.text withPhotoArary:_selectedPhotoArray];
    }
    
}

- (void)showSheet {
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *uploadPhotos = [UIAlertAction actionWithTitle:@"上传照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"上传照片");
            [self pickPhoto];
        }];
        
        UIAlertAction *uploadPhotosByCamera = [UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照上传");
            [self takePhoto];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:uploadPhotos];
        [alert addAction:uploadPhotosByCamera];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传照片", @"拍照上传", nil];
        [sheet showInView:self.view];
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"上传照片1");
        [self pickPhoto];
    }else if (buttonIndex == 1) {
        NSLog(@"拍照上传1");
        [self takePhoto];
    }else if (buttonIndex == 2) {
        NSLog(@"取消");
    }
}

- (NSDate *)showDate:(NSString *)dateStr {
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:dateStr];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *myDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSLog(@"myDate = %@",myDate);
    return myDate;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([_thirdViewTF isEqual:textField]) {
        if (range.location >= 15) {
            return NO;
        }
    }
    return YES;
    
}

-(void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        _fourthViewPlaceholder.hidden = NO;
    }else {
        _fourthViewPlaceholder.hidden = YES;
    }
    CGFloat width = CGRectGetWidth(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    _fourthViewTVHeight.constant = newSize.height;
    
}

- (void)timerFired {
    [_alert dismissViewControllerAnimated:YES completion:nil];
    [_timer invalidate];
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_selectedPhotoArray addObject:image];
    [self uploadData];
    
}

-(void)pickPhoto{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusDenied || status ==PHAuthorizationStatusRestricted){
        
        NSLog(@"不允许访问");
        //无权限
        // 获取当前App的基本信息字典
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的手机相册",app_Name];
        
        UIAlertView* alertView= [[UIAlertView alloc] initWithTitle:nil message:tips delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        alertView.tag =1003;
        [alertView show];
    }

    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager new];
    
    //设置类型
    manager.pickerVCManagerType = CorePhotoPickerVCMangerTypeMultiPhoto;
    
    //最多可选3张
    manager.maxSelectedPhotoNumber = 9;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.imagePickerController;

    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        [ProgressUtil show];
        runOnBackground(^{
            [medias enumerateObjectsUsingBlock:^(CorePhoto *photo, NSUInteger idx, BOOL *stop) {
//                NSString * path = [photo.editedImage saveToLocal];
//                [ws.urls addObject:path];
                
            }];
            runOnMainThread(^{
//                [ws resetImageView];
                
                [ProgressUtil dismiss];
                
                NSLog(@"%ld", medias.count);
                
                for (CorePhoto *photo in medias) {
                    
                    NSLog(@"%@", photo);
                    
                    [_selectedPhotoArray addObject:photo.editedImage];
                    
                }
                NSLog(@"%ld", _selectedPhotoArray.count);
                
                [self uploadData];
                
            });
        });
        
    };
    if (self) {
        [self presentViewController:pickerVC animated:YES completion:nil];
    }else{
        [self presentViewController:pickerVC animated:YES completion:nil];
    }
    
}



- (void)sendMessage:(NSString *)message {
    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil,nil];
    alertV.tag = 1004;
    [alertV show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1003) {
        if(buttonIndex==0){
            //取消设置
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    }

//    if(buttonIndex == 0){
//        NSLog(@"继续上传");
//    }
    else  if(alertView.tag == 1004){
    if(buttonIndex == 0){
        NSLog(@"完成");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    }
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
