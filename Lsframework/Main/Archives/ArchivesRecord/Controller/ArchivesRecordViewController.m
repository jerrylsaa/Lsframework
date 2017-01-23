//
//  ArchivesRecordViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ArchivesRecordViewController.h"
#import "FPTextField.h"
#import "FPDatePicker.h"
#import "FPDropView.h"
#import "FPButton.h"
#import "NeonateViewController.h"
#import "NationEntity.h"
#import "NationalityEntity.h"
#import "MenuEntity.h"

@interface ArchivesRecordViewController ()<UITextFieldDelegate, ArchivesRecordPresenterDelegate>
@property (weak, nonatomic) IBOutlet FPTextField *tfWeight;
@property (weak, nonatomic) IBOutlet FPTextField *tfHeight;
@property (weak, nonatomic) IBOutlet FPTextField *tfDate;
@property (weak, nonatomic) IBOutlet FPTextField *tfHospital;
@property (weak, nonatomic) IBOutlet FPTextField *tfName;
@property (weak, nonatomic) IBOutlet FPTextField *tfSex;
@property (weak, nonatomic) IBOutlet FPTextField *tfNationality;
@property (weak, nonatomic) IBOutlet FPTextField *tfNation;
@property (weak, nonatomic) IBOutlet FPTextField *tfGuardianIdentity;
@property (weak, nonatomic) IBOutlet FPTextField *tfGuardian;
@property (weak, nonatomic) IBOutlet FPTextField *tfHomeAddress;
@property (weak, nonatomic) IBOutlet FPTextField *tfPhone;
@property (weak, nonatomic) IBOutlet FPButton *btnNext;
@property (weak, nonatomic) IBOutlet FPTextField *tfBabyId;
@property (weak, nonatomic) IBOutlet FPTextField *tfParentId;

- (IBAction)next;

@property (nonatomic, strong) ChildForm * childForm;
@property (nonatomic, strong) ArchivesRecordPresenter * presenter;
@end

@implementation ArchivesRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"档案录入";
    if (_type == ArchivesRecordTypeFromCaseInfo) {
        self.title = @"添加宝宝";
        [_btnNext setTitle:@"提交" forState:UIControlStateNormal];
    }
    _presenter = [ArchivesRecordPresenter new];
    _presenter.delegate = self;
    _tfDate.delegate = self;
    _tfGuardianIdentity.delegate = self;
    _tfSex.delegate = self;
    _tfNation.delegate = self;
    _tfNationality.delegate = self;
    _childForm = [ChildForm new];
    
    _tfPhone.text = kCurrentUser.phone;
    
    //默认值
    //国籍
    _tfNationality.text = [self defaultNameBy:18];
    self.childForm.childNation = [MenuEntity findMenuEntityID:_tfNationality.text];
    //民族
    _tfNation.text = [self defaultNameBy:19];
    NSLog(@"=====%@",_tfNation.text);
    self.childForm.nation = [MenuEntity findMenuEntityID:_tfNation.text];

}

- (NSString *)defaultNameBy:(NSInteger )menuId{
    NSArray *array = [MenuEntity MR_findByAttribute:@"parentId" withValue:@(menuId)];
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *obj1, MenuEntity *obj2) {
        return [obj1.menuId compare:obj2.menuId];
    }];
    NSMutableArray *titleArray = [NSMutableArray array];
    for (MenuEntity *entity in sortArray) {
        [titleArray addObject:entity.dictionaryName];
    }
    return titleArray[0];
}

#pragma mark ArchivesRecordPresenterDelegate

-(void)onCommitChildArchivesComplete:(BOOL)success info:(NSString *)info{
    if (success) {
        [ProgressUtil dismiss];
        kCurrentUser.needToUpdateChildInfo = YES;
        if (self.btnHidden == NO) {
            if (_type == ArchivesRecordTypeFromCaseInfo) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Add_Baby_Complete object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NeonateViewController* neonate = [NeonateViewController new];
                neonate.poptoClass = _poptoClass;
                neonate.childForm = _childForm;
                [self.navigationController pushViewController:neonate animated:YES];
            }
        }
       NSString* str= [NSString stringWithUTF8String:object_getClassName(self.poptoClass)];
        if([str isEqualToString:@"MBabyManagerViewController"] || [str isEqualToString:@"GBMineViewController"]){
        //更新宝贝列表
            [kdefaultCenter postNotificationName:Notification_UpdateBabyList object:nil userInfo:nil];
            
         //更新我的首页headrCollection
            [kdefaultCenter postNotificationName:Notification_Update_AllBaby object:nil userInfo:nil];
            
        }else if ([str isEqualToString:@"FDApplyDoctorViewController"]){
            //更新添加医生模块，添加宝宝通知
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Add_Baby_Complete object:nil];
        }
    }else{
        [ProgressUtil showError:info];
    }
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    WS(ws);

    __weak UITextField * weakTf = textField;
//    性别 国籍 民族 监护人身份为选择
    if ([textField isEqual:_tfDate]) {
        //出生日期
        FPDatePicker * datePicker = [FPDatePicker new];
        [datePicker showInView:self.view];
        [datePicker setMaxDate:[NSDate new]];
        [datePicker addDatePickerHandler:^(NSString *date, NSDate * d) {
            weakTf.text = date;
        }];
    }else if ([textField isEqual:_tfSex]){
        //性别
        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = @[@"男", @"女"];
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            if (selection == 0) {
                ws.childForm.childSex = 1;
            }else{
                ws.childForm.childSex = 2;
            }
            return YES;
        }];
        [dropView showInController:self parentView:textField];

    }else if ([textField isEqual:_tfNationality]){
        //国籍
        NSArray *countryArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@18];
        NSArray *sortArray = [countryArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *obj1, MenuEntity *obj2) {
            return [obj1.menuId compare:obj2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortArray) {
            [titleArray addObject:entity.dictionaryName];
        }

        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            ws.childForm.childNation = [((MenuEntity *)sortArray[selection]).menuId integerValue];
            return YES;
        }];
        [dropView showInController:self parentView:textField];
    }else if ([textField isEqual:_tfNation]){
        //民族
        NSArray *nationArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@19];
        NSArray *sortArray = [nationArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *obj1, MenuEntity *obj2) {
            return [obj1.menuId compare:obj2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortArray) {
            [titleArray addObject:entity.dictionaryName];
        }

        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakDv.titles[selection];
            ws.childForm.nation = [((MenuEntity *)sortArray[selection]).menuId integerValue];
            return YES;
        }];
        [dropView showInController:self parentView:textField];
    }else if ([textField isEqual:_tfGuardianIdentity]){
        //监护人身份
        NSArray *relationArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@389];
        NSArray *sortArray = [relationArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *obj1, MenuEntity *obj2) {
            return [obj1.menuId compare:obj2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortArray) {
            [titleArray addObject:entity.dictionaryName];
        }
        FPDropView * dropView = [FPDropView new];
        dropView.textAlignment = NSTextAlignmentCenter;
        dropView.textColor = [UIColor darkGrayColor];
        dropView.font = [UIFont systemFontOfSize:18.];
        dropView.titles = titleArray;
        __weak FPDropView * weakDv = dropView;
        [dropView setSelectedHandler:^BOOL(NSUInteger selection) {
             weakTf.text = titleArray[selection];
            ws.childForm.guargionRelation = [((MenuEntity *)sortArray[selection]).menuId integerValue];
            return YES;
        }];
        [dropView showInController:self parentView:textField];
    }

    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 点击事件
- (IBAction)next {
    _childForm.birthWeight = _tfWeight.text;
    _childForm.birthHeight = _tfHeight.text;
    _childForm.birthDate = _tfDate.text;
    _childForm.birthHospital = _tfHospital.text;
    _childForm.childName = _tfName.text;
    _childForm.guargianID = _tfGuardianIdentity.text;
    _childForm.guargionName = _tfGuardian.text;
    _childForm.childAddress = _tfHomeAddress.text;
    _childForm.childTEL = _tfPhone.text;
    _childForm.identityCode =_tfBabyId.text;
    _childForm.guargianID =_tfParentId.text;
    [ProgressUtil show];
    
    if(_childForm.childID != 0){
    //更新基本信息
        [_presenter updateChildArchives:_childForm];
    }else{
    //添加新的档案
        [_presenter commitChildArchives:_childForm];
    }
    
    
//    _childForm.childID = 382;
//    NeonateViewController* neonate = [NeonateViewController new];
//    neonate.childForm=_childForm;
//    [self.navigationController pushViewController:neonate animated:YES];

}

- (void)vc_1_Save:(Complete)block{
    _childForm.birthWeight = _tfWeight.text;
    _childForm.birthHeight = _tfHeight.text;
    _childForm.birthDate = _tfDate.text;
    _childForm.birthHospital = _tfHospital.text;
    _childForm.childName = _tfName.text;
    _childForm.guargianID = _tfGuardianIdentity.text;
    _childForm.guargionName = _tfGuardian.text;
    _childForm.childAddress = _tfHomeAddress.text;
    _childForm.childTEL = _tfPhone.text;
    _childForm.identityCode =_tfBabyId.text;
    _childForm.guargianID =_tfParentId.text;
    [_presenter commitChildArchives:_childForm complete:^(BOOL success ,NSString *message) {
        block(success ,message);
    }];
}

#pragma mark - 公有方法
- (void)hiddenButton{
    _btnNext.hidden = YES;
}

- (void)loadData:(ChildForm *)child{
    
    self.childForm = child;
    self.childForm.birthDate = [self format:[child.birthDate longLongValue]];
    
    _tfWeight.text = child.birthWeight;
    _tfHeight.text = child.birthHeight;
    _tfDate.text = child.birthDate;
    _tfHospital.text = child.birthHospital;
    _tfName.text = child.childName;
    _tfGuardian.text = child.guargionName;
    _tfHomeAddress.text = _childForm.childAddress;
    _tfPhone.text = child.childTEL;
    _tfBabyId.text =child.identityCode;
    _tfParentId.text =child.guargianID;
    
    if (child.childSex == 1) {
        _tfSex.text = @"男";
    }else{
        _tfSex.text = @"女";
    }
    _tfNationality.text = [self findDicNameBy:child.childNation];
    _tfNation.text = [self findDicNameBy:child.nation];
    _tfGuardianIdentity.text = [self findDicNameBy:child.guargionRelation];
}



#pragma mark -
- (NSString *)findDicNameBy:(NSInteger)menuId{
    NSArray *array = [MenuEntity MR_findByAttribute:@"menuId" withValue:@(menuId)];
    if (array.count > 0) {
        MenuEntity *entity = array[0];
        return entity.dictionaryName;
    }
    return @"";
}


- (NSString *)format:(long)timeInv{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInv];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
}

@end
