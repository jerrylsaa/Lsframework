//
//  ArchivesMainViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ArchivesMainViewController.h"
#import "ArchivesRecordViewController.h"
#import "AddArchivesViewController.h"
#import "ScanQRCodeViewController.h"
#import "MDoctorAppointViewController.h"
#import "HRHealthStaticPageViewController.h"
#import "ArchivesMainPresenter.h"
#import "GBArchivesRecordViewController.h"

@interface ArchivesMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *hasArchivesView;
@property (weak, nonatomic) IBOutlet UIView *hasNoArchivesView;
@property (nonatomic,copy) NSString *decodedUrl;
@property (nonatomic, strong) ArchivesMainPresenter *presenter;
@end

@implementation ArchivesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"档案录入";
    _presenter = [ArchivesMainPresenter new];
    [_hasArchivesView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hasArchivesViewAction:)]];
    
    [_hasNoArchivesView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hasNoArchivesViewAction:)]];
    if ([self.pageType isEqualToString:@"MyAppoitment"]) {
        self.title =@"我的预约";
        self.labelNOOne.text =@"儿童医院";
        self.hasArchivesView.hidden =YES;
        self.labelNOOne.font =[UIFont systemFontOfSize:22];
        self.labelNOTwo.text =nil;
        self.labelOneXPosition.constant =40;
        self.labelNOThree.text =@"其他医院";
        self.labelNOThree.font =[UIFont systemFontOfSize:22];
        self.labelNOFour.text =nil;
        self.labelTwoXPosition.constant =40;
    }else {
        
//        _hasNoArchivesView.sd_layout.leftSpaceToView(self.view,30).rightSpaceToView(self.view,30).topSpaceToView(self.view,40).heightIs(100);
//        
//        self.hasArchivesView.hidden =YES;
    }
}

-(void)hasArchivesViewAction:(id)sender{
    if ([self.pageType isEqualToString:@"MyAppoitment"]) {
        WS(ws);
        [[FPNetwork POST:@"GetConfigByUserID" withParams:nil] addCompleteHandler:^(FPResponse *response) {
            if(response.success){
                
                NSDictionary *dataDic =response.data;
                NSNumber *tasd =[dataDic valueForKey:@"openetyyorder"];
                if ([tasd integerValue]==1) {
                    
                    NSString *encodedUrl =[dataDic valueForKey:@"etyymyorderurl"];
                    ws.decodedUrl =[ws URLDecodedString:encodedUrl];
                    HRHealthStaticPageViewController* staticPage = [HRHealthStaticPageViewController new];
                    staticPage.pageType =@"MyAppoitment";
                    staticPage.staticPageURL = self.decodedUrl;
                    [self.navigationController pushViewController:staticPage animated:YES];

                }
                else {
                    
                    return;
                }
            }
            else {
                [ProgressUtil showError:response.message];
            }
            
        }];

        }else {
    AddArchivesViewController * vc = [AddArchivesViewController new];
    vc.poptoClass = self.poptoClass;//兼容从宝宝管理页面跳转
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

-(void)hasNoArchivesViewAction:(id)sender{
    if ([self.pageType isEqualToString:@"MyAppoitment"]) {
        MDoctorAppointViewController *vc =[MDoctorAppointViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        GBArchivesRecordViewController * vc = [GBArchivesRecordViewController new];
        vc.poptoClass = self.poptoClass;
        vc.type = GBArchivesRecordTypeFromRegister;
//
//        ArchivesRecordViewController * vc = [ArchivesRecordViewController new];
//        vc.poptoClass = self.poptoClass;
//        vc.type = ArchivesRecordTypeFromRegister;
//
        WS(ws);
        
        [_presenter loadMenuData:^(BOOL success) {
            if (success == YES) {
                [ProgressUtil dismiss];
                [ws.navigationController pushViewController:vc animated:YES];
            }else{
                [ProgressUtil showError:@"加载失败"];
            }
        }];
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
