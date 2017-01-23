//
//  SFHealthRecordViewController.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/6/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SFHealthRecordViewController.h"
#import "FollowUpMainViewController.h"
#import "BSHospitalArchivesViewController.h"
#import "PersonFileViewController.h"
#import "FPNetwork.h"
#import "JMFoundation.h"
#import "DefaultChildEntity.h"
#import "ScreenAppraiseController.h"
#import "HRHealthAssessmentViewController.h"
#import "HRHealthStaticPageViewController.h"
#import "ScanQRCodeViewController.h"

@interface SFHealthRecordViewController ()<ScanQRCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *personalRecordBtn; //健康日志
@property (weak, nonatomic) IBOutlet UIButton *healthCepingBtn;//筛查测评  ---->  //健康档案
@property (weak, nonatomic) IBOutlet UIButton *healthDailyRecordBtn;//病例档案
@property (weak, nonatomic) IBOutlet UIButton *screenAppraiseBtn;//检查档案
@property (weak, nonatomic) IBOutlet UIButton *bingliRecordBtn;//个人档案
@property (weak, nonatomic) IBOutlet UIButton *hospitalCheckRecordBtn;   //健康测评
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstToSecondConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondToThirdConstraint;

@end

@implementation SFHealthRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"健康档案";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"授权" style:UIBarButtonItemStylePlain target:self action:@selector(qrCodeAction)];
    _screenAppraiseBtn.hidden = YES;   //隐藏健康档案
    
}

- (void)viewWillLayoutSubviews {
    self.firstToSecondConstraint.constant =([UIScreen mainScreen].bounds.size.width-104)/4.0;
    self.secondToThirdConstraint.constant =([UIScreen mainScreen].bounds.size.width-104)/4.0;
    [self.view updateConstraints];
    
}

- (IBAction)btnAction:(UIButton *)sender {
    if ([sender isEqual:_personalRecordBtn]) {
        NSLog(@"您点击了健康日志");
        [self.navigationController pushViewController:[FollowUpMainViewController new] animated:YES];
        
    }
    /*   隐藏筛查测评
    else if ([sender isEqual:_healthCepingBtn]) {
        NSLog(@"您点击了筛查测评");
        [self.navigationController pushViewController:[ScreenAppraiseController new] animated:YES];//筛查测评跳转
     
        

//        [ProgressUtil showInfo:@"此功能下版本开放"];
    }
 else if ([sender isEqual:_healthDailyRecordBtn] || [sender isEqual:_screenAppraiseBtn]) {
        NSLog(@"您点击了检查档案");
        // 用来区分跳转的页面
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([sender isEqual:_screenAppraiseBtn]) {
            [user setObject:@"0" forKey:@"bsArchivesType"];  //病历档案
            
        }else if ([sender isEqual:_healthDailyRecordBtn]) {
            [user setObject:@"1" forKey:@"bsArchivesType"];  //检查档案
            
        }
  */
    //将检查档案移到筛查测评位置
    else if ([sender isEqual:_healthDailyRecordBtn] || [sender isEqual:_healthCepingBtn]) {
        NSLog(@"您点击了检查档案");
        // 用来区分跳转的页面
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([sender isEqual:_healthCepingBtn]) {
            [user setObject:@"0" forKey:@"bsArchivesType"];  //检查档案
            
        }else if ([sender isEqual:_healthDailyRecordBtn]) {
            [user setObject:@"1" forKey:@"bsArchivesType"];  //病例档案
            
        }

        BSHospitalArchivesViewController *vc = [[BSHospitalArchivesViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([sender isEqual:_bingliRecordBtn]) {
        NSLog(@"您点击了个人档案");
        [self.navigationController pushViewController:[[PersonFileViewController alloc] init] animated:YES];
        
    }else if ([sender isEqual:_hospitalCheckRecordBtn]) {
        NSLog(@"您点击了健康测评");
        [self.navigationController pushViewController:[[HRHealthAssessmentViewController alloc] init] animated:YES];
    }

}

- (void)qrCodeAction {
    
    NSLog(@"您点击了授权");
    [self showSheet];
}

-(void)onScanDone:(NSString*)qrCode{
    
    NSString *babyId =[[DefaultChildEntity defaultChild].babyID stringValue];
    
    NSDictionary * params = @{@"BabyID":babyId,@"DoctorID":qrCode};
    
    [[FPNetwork POST:@"SetBabyHospitalBind" withParams:params]  addCompleteHandler:^(FPResponse* response) {
        if(response.isSuccess){
            
            [ProgressUtil showInfo:response.message];
            
        }
        else{
            
            [ProgressUtil showError:response.message];
        }
        
    }];
    
}

- (void)showSheet {
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示：您确定将此页面的信息授权给当前医院及医生查看，该信息仅作医务使用。" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            
            ScanQRCodeViewController *qrCode = [[ScanQRCodeViewController alloc] init];
            qrCode.delegate =self;
            [self.navigationController pushViewController:qrCode animated:YES];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:determineAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"提示：您确定将此页面的信息授权给当前医院及医生查看，该信息仅作医务使用。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        [sheet showInView:self.view];
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"确定");
        
        ScanQRCodeViewController *qrCode = [[ScanQRCodeViewController alloc] init];
        [self.navigationController pushViewController:qrCode animated:YES];
        
    }else if (buttonIndex == 1) {
        NSLog(@"取消");
        
    }
}

#pragma mark---umeng页面统计
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"健康档案"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"健康档案"];
    
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
