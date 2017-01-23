//
//  BSHealthRecordViewController.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSHealthRecordViewController.h"
#import "FollowUpMainViewController.h"
#import "BSHospitalArchivesViewController.h"
#import "PersonFileViewController.h"

#import "ScanQRCodeViewController.h"

#import "FPNetwork.h"
#import "JMFoundation.h"
#import "DefaultChildEntity.h"
#import "ApiMacro.h"

#import "ScreenAppraiseController.h"
#import "HRHealthAssessmentViewController.h"
#import "HRHealthStaticPageViewController.h"


@interface BSHealthRecordViewController ()<UIWebViewDelegate, UIActionSheetDelegate,ScanQRCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *graphView;

//@property (weak, nonatomic) IBOutlet UIWebView *graphWebView;// 生长发育曲线图
@property (weak, nonatomic) IBOutlet UIButton  *personalFileBtn;// 个人档案按钮
@property (weak, nonatomic) IBOutlet UIButton  *healthAssessmentBtn;// 健康测评按钮

//@property (weak, nonatomic) IBOutlet UIButton  *followUpRecordsBtn;// 随访记录按钮

@property (weak, nonatomic) IBOutlet UIButton *healthLogBtn;  //健康日志按钮
@property (weak, nonatomic) IBOutlet UIButton  *screeningForEvaluatingBtn;// 筛查评测按钮
@property (weak, nonatomic) IBOutlet UIButton  *hospitalArchivesBtn;// 医院检查档案
@property (weak, nonatomic) IBOutlet UIButton  *medicalRecordsBtn;// 医病历档案
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BSHealthRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupView {
    
    self.title = @"健康档案";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"授权" style:UIBarButtonItemStylePlain target:self action:@selector(qrCodeAction)];
    UITapGestureRecognizer* webTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushWebView)];
    [_graphView addGestureRecognizer:webTap];
   /* NSString *headUrl =[NSString stringWithFormat:@"%@%@",BASE_DOMAIN,API_HTML_BABY_GROWTH_CURVE];
    NSString *userUrl=[NSString stringWithFormat:@"babyID=%@",[DefaultChildEntity defaultChild].babyID];
    NSString *sexUrl=[NSString stringWithFormat:@"sex=%@",[DefaultChildEntity defaultChild].childSex];
    
    NSString *resultUrl =[[headUrl stringByAppendingString:userUrl] stringByAppendingString:sexUrl];
//    userID=363&sex=2
    NSURL *url =[NSURL URLWithString:resultUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_graphWebView loadRequest:request];
    _graphWebView.scrollView.bounces = NO;
    
    [_graphWebView setOpaque:NO];
    
    _graphWebView.scalesPageToFit = YES;
    _graphWebView.delegate = self;*/
}

- (void)pushWebView {
    NSString *headUrl = [NSString stringWithFormat:@"%@%@",BASE_DOMAIN,API_HTML_BABY_GROWTH_CURVE];
    NSString *userUrl=[NSString stringWithFormat:@"babyID=%@",[DefaultChildEntity defaultChild].babyID];
    NSString *sexUrl=[NSString stringWithFormat:@"sex=%@",[DefaultChildEntity defaultChild].childSex];
    
    NSString *resultUrl =[[headUrl stringByAppendingString:userUrl] stringByAppendingString:sexUrl];
    NSLog(@"%@",resultUrl);
    //    userID=363&sex=2
//    NSURL *url =[NSURL URLWithString:resultUrl];
    HRHealthStaticPageViewController *webView =[HRHealthStaticPageViewController new];
    webView.staticPageURL =resultUrl;
    webView.pageType =@"GraphWebView";
    [self.navigationController pushViewController:webView animated:YES];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"错误");
    
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

- (IBAction)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if ([btn isEqual:_personalFileBtn]) {
        NSLog(@"您点击了个人档案");
        [self.navigationController pushViewController:[PersonFileViewController new] animated:YES];
//        [self.navigationController pushViewController:[HRPersonalArchiverViewController new] animated:YES];
    }else if ([btn isEqual:_healthAssessmentBtn]) {
        NSLog(@"您点击了健康测评");
        [self.navigationController pushViewController:[HRHealthAssessmentViewController new] animated:YES];
        
    }else if ([btn isEqual:_healthLogBtn]) {
        NSLog(@"您点击了健康日志");
        [self.navigationController pushViewController:[[FollowUpMainViewController alloc] init] animated:YES];
    }else if ([btn isEqual:_screeningForEvaluatingBtn]) {
        NSLog(@"您点击了筛查测评");
        [self.navigationController pushViewController:[[ScreenAppraiseController alloc] init] animated:YES];
    }else if ([btn isEqual:_hospitalArchivesBtn] || [btn isEqual:_medicalRecordsBtn]) {
        NSLog(@"您点击了医院检查档案");
        
        // 用来区分跳转的页面
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([btn isEqual:_hospitalArchivesBtn]) {
            [user setObject:@"0" forKey:@"bsArchivesType"];
        }else if ([btn isEqual:_medicalRecordsBtn]) {
            [user setObject:@"1" forKey:@"bsArchivesType"];
        }
        
        BSHospitalArchivesViewController *vc = [[BSHospitalArchivesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
