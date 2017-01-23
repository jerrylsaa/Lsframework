//
//  AddArchivesViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AddArchivesViewController.h"
#import "ScanQRCodeViewController.h"
#import "FPNetwork.h"
#import "GBMineViewController.h"
@interface AddArchivesViewController ()<ScanQRCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfArchivesNumber;
@property (strong, nonatomic) IBOutlet UITextField *tfChildName;

@end

@implementation AddArchivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"已有档案";
    _tfArchivesNumber.keyboardType = UIKeyboardTypePhonePad;
}

#pragma mark - ScanQRCodeViewControllerDelegate

-(void)onScanDone:(NSString *)qrCode{
    [self bindChildArchives:qrCode andChildName:nil];
}

- (IBAction)btnSubmitAction:(id)sender {
    
    if(!_tfChildName || [_tfChildName.text trimming].length == 0){
        [ProgressUtil showInfo:@"请输入孩子姓名"];
        return ;
    }
    
    if(!_tfArchivesNumber || [_tfArchivesNumber.text trimming].length == 0){
        [ProgressUtil showInfo:@"请输入档案号"];
        
        return ;
    }
    
    [self bindChildArchives:_tfArchivesNumber.text andChildName:_tfChildName.text];

    
    
//    if (_tfArchivesNumber.text.length > 0) {
//        [self bindChildArchives:_tfArchivesNumber.text];
//    }else{
//        [ProgressUtil showError:@"请输入档案号"];
//    }
}
- (IBAction)btnScanAction:(id)sender {
    ScanQRCodeViewController * vc = [ScanQRCodeViewController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)bindChildArchives:(NSString*)archivesId andChildName:(NSString*) childName{
    [ProgressUtil show];
    
    NSDictionary* parames = nil;
    if(childName != nil){
        parames = @{@"UserID":@(kCurrentUser.userId), @"code":archivesId, @"ChildName":childName};
    }else{
        parames = @{@"UserID":@(kCurrentUser.userId), @"code":archivesId};
    }
    
    [[FPNetwork POST:@"AddPatriarchAndBabyBind" withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if (response.success) {
            //更新我的首页headrCollection
            [kdefaultCenter postNotificationName:Notification_Update_AllBaby object:nil userInfo:nil];
            
                UIViewController* back = nil;
                for(UIViewController* vc in self.navigationController.childViewControllers){
                    if([vc isKindOfClass:[GBMineViewController class]]){
                        back = vc;
                        break;
                    }
                }
            
                if(back){
                    [self.navigationController popToViewController:back animated:YES];
                }
   

//            NSString* str = [NSString stringWithUTF8String:object_getClassName(self.poptoClass)];
//            if([str isEqualToString:@"GBMineViewController"]){
//                //更新我的首页headrCollection
//             [kdefaultCenter postNotificationName:Notification_Update_AllBaby object:nil userInfo:nil];
//                
//                UIViewController* back = nil;
//                for(UIViewController* vc in self.navigationController.childViewControllers){
//                    if([vc isKindOfClass:self.poptoClass]){
//                        back = vc;
//                        break;
//                    }
//                }
//                [self.navigationController popToViewController:back animated:YES];
//                
//            }
        }
        [ProgressUtil showInfo:response.message];
    }];
}




@end
