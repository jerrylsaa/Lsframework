//
//  MUserNameViewController.m
//  FamilyPlatForm
//
//  Created by jerry on 16/9/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MUserNameViewController.h"
#import "MUserNamePresenter.h"
#import "GBMineViewController.h"

@interface MUserNameViewController ()<UITextFieldDelegate,MUserNamePresenterDelegate>{

UIView  *_UserView;


}
@property(nonatomic,strong)UITextField  *UserTextField;
@property(nonatomic,retain) MUserNamePresenter* presenter;
@end

@implementation MUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"昵称";
    
    [self  initRightBarWithTitle:@"保存"];

    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    
}
-(void)setupView{
    _presenter = [MUserNamePresenter  new];
    _presenter.delegate = self;

    _UserView = [UIView  new];
    _UserView.backgroundColor = [UIColor  whiteColor];
    [self.view  addSubview:_UserView];

    _UserTextField = [UITextField  new];
    _UserTextField.backgroundColor = [UIColor  clearColor];
  _UserTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _UserTextField.textAlignment = NSTextAlignmentLeft;
    _UserTextField.text = _currentUserName;
    _UserTextField.delegate =self;
    _UserTextField.clearsOnBeginEditing = YES;
    _UserTextField.textColor = [UIColor  blackColor];
    _UserTextField.font = [UIFont  systemFontOfSize:18];
    _UserTextField.keyboardType = UIKeyboardTypeDefault;
    [_UserView  addSubview:_UserTextField];
    
    
    
_UserView.sd_layout.topSpaceToView(self.view,20).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(50);

_UserTextField.sd_layout.centerYEqualToView(_UserView).leftSpaceToView(_UserView,20).widthIs(kScreenWidth-20).heightIs(20);


}


#pragma mark --- 点击事件----
-(void)rightItemAction:(id)sender{
    
    if (_UserTextField.text == nil || _UserTextField.text.length == 0) {
        [ProgressUtil showError:@"设置昵称为空"];
        return;
    }

    [_presenter  SetNickName:_UserTextField.text];
}

- (void)onCompletion:(BOOL) success info:(NSString*) info{
    if (success) {
        [ProgressUtil  showInfo: @"昵称设置成功"];
        
        //更新我的首页headrCollection
        [kdefaultCenter postNotificationName:Notification_Update_AllBaby object:nil userInfo:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];

        });
        
    }else{
    
        [ProgressUtil  showError:info];
        
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
