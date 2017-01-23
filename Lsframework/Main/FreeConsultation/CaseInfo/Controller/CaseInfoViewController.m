//
//  CaseInfoViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CaseInfoViewController.h"
#import "CaseInfoCollectionViewCell.h"
#import "FBRadioGroup.h"
#import "FPTextField.h"
#import "DiseaseDescribeViewController.h"
#import "ACSuccessPageViewController.h"
#import "CaseInfoPresenter.h"
#import "CaseInfo.h"
#import "ImageWidget.h"
#import "ArchivesMainViewController.h"
#import "QCDoctorListViewController.h"
#import "OrderSubmitViewController.h"
#import "OutpatientSuccessViewController.h"
#import "FCDiseaseDescriberViewController.h"
#import "JMChatViewController.h"
#import "RCDataBaseManager.h"

typedef NS_ENUM(NSUInteger, CaseInfoTableTag) {
    CaseInfoTableTagHasDiseaseTime,//患病时间
    CaseInfoTableTagDepartment,//科室
};

@interface CaseInfoViewController ()<UITableViewDelegate, UITableViewDataSource,CaseInfoDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FBRadioGroup *rgDisease;//所患疾病
@property (weak, nonatomic) IBOutlet FPTextField *tfDisease;
@property (weak, nonatomic) IBOutlet FBRadioGroup *rgIsGotoHospital;//是否去过医院检查过
@property (weak, nonatomic) IBOutlet FBRadioGroup *rgCheckData;//检查资料
@property (weak, nonatomic) IBOutlet FBRadioGroup *rgIsNeedDepartment;//是否需要咨询科室
@property (weak, nonatomic) IBOutlet UITextField *tfDiseaseInfo;//病情信息
@property (weak, nonatomic) IBOutlet UILabel *lbHasDiseaseTime;//患病时间
@property (weak, nonatomic) IBOutlet UIView *viewDepartment;//是否咨询可以
@property (weak, nonatomic) IBOutlet UIView *viewHasDiseaseTime;//患病时间
@property (weak, nonatomic) IBOutlet UITableView *tableHasDiseaseTime;
@property (weak, nonatomic) IBOutlet UITableView *tableDepartment;
@property (strong, nonatomic) NSArray * arrayHasDiseaseTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHasDiseaseTimeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableDepartmentHeight;
@property (weak, nonatomic) IBOutlet UIView *viewDiseaseInfo;//病情信息
@property (weak, nonatomic) IBOutlet UIView *viewCaseOrPartPhoto;//病历或部位照片
@property (weak, nonatomic) IBOutlet UIView *viewCheckDataExtend;//检查资料扩展
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCheckDataExtendHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDiseaseInfoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCaseOrPartPhotoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDiseaseDesHeight;
@property (weak, nonatomic) IBOutlet UIView *viewDiseaseDes;//病情描述
@property (strong, nonatomic) NSArray * arrayDepartment;
@property (nonatomic) NSUInteger indexHasDiseaseTime;
@property (weak, nonatomic) IBOutlet UIView *viewIsAskedDoctor;//找xxx医生看过病么
@property (weak, nonatomic) IBOutlet UILabel *lbIsAskedDoctor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewIsAskedDoctorHeight;
@property (weak, nonatomic) IBOutlet UITextField *tfCheckData;//检查资料输入框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDepartmentHeight;
@property (weak, nonatomic) IBOutlet FBRadioGroup *rgIsAskedDoctor;
@property (weak, nonatomic) IBOutlet UILabel *lbWarn;
@property (weak, nonatomic) IBOutlet ImageWidget *photoPicker;
@property (nonatomic) NSUInteger indexDepartment;
@property (nonatomic ,strong)CaseInfoPresenter *presenter;
@property (nonatomic ,strong)CaseInfo *caseInfo;

@property (nonatomic ,assign)BOOL isDiseaseName;
@property (nonatomic ,assign)BOOL isCheckData;

@property (nonatomic ,assign)BOOL isShowCommitInfo;//展示提交信息


@property(nonatomic) BOOL isShowLocalData;//展示本地保存的图片和语音

- (IBAction)commitAction;

@end

@implementation CaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self regiseterNotification];
}

-(void)setupView{
    if (self.caseInfoType ==  CaseInfoTypeVIP) {
        self.title = @"特需门诊预约";
    }else if (self.caseInfoType == CaseInfoTypeNormal){
        self.title = @"普通门诊预约";
    }
    else
    {
        self.title = @"病历信息";
    }
    
    self.presenter = [CaseInfoPresenter new];
    _caseInfo = [CaseInfo new];
    _presenter.delegate = self;
    _presenter.caseInfoType = _caseInfoType;
    [_collectionView registerNib:[UINib nibWithNibName:@"CaseInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [_rgDisease setTitles:@[@"不清楚",@""]];
    [_rgIsGotoHospital setTitles:@[@"是",@"否"]];
    [_rgCheckData setTitles:@[@"是",@"否"]];
    [_rgIsAskedDoctor setTitles:@[@"是",@"否"]];
    [_rgIsNeedDepartment setTitles:@[@"不需要",@"请选择"]];
    
    _arrayDepartment = @[@"骨科", @"普通外科", @"肝胆外科", @"泌尿外科", @"神经外科",@"胸外科", @"心血管外科", @"儿科", @"妇科"];
    _arrayHasDiseaseTime = @[@"刚刚", @"一周内", @"一个月内", @"半年内", @"大于半年"];
    _lbIsAskedDoctor.text = [NSString stringWithFormat:@"找%@医生看过病吗",self.doctor.UserName];
    _tableDepartment.tag = CaseInfoTableTagDepartment;
    _tableHasDiseaseTime.tag = CaseInfoTableTagHasDiseaseTime;
    [_tableDepartment registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableHasDiseaseTime registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _indexDepartment = -1;
    _indexHasDiseaseTime = -1;
    
    [self setupDepartmentAction];
    [self setupCheckDataAction];
    [_viewHasDiseaseTime addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewHasDiseaseTimeAction:)]];
    
    if (_caseInfoType == CaseInfoTypeFree) {
        [self setupFreeType];
    }else if (_caseInfoType == CaseInfoTypeQuick){
        [self setupQuickType];
    }else if (_caseInfoType == CaseInfoTypeAccuration){
        [self setupAccurateType];
    }else if (self.caseInfoType == CaseInfoTypeVIP){
        [self setupFreeType];
    }else if (_caseInfoType == CaseInfoTypeNormal){
        [self setupNormalType];
    }
    
    UIImage * tfDiseaseBg = [UIImage imageNamed:@"FCTextFieldBg"];
    tfDiseaseBg = [tfDiseaseBg stretchableImageWithLeftCapWidth:tfDiseaseBg.size.width / 2 topCapHeight:tfDiseaseBg.size.height / 2];
    [_tfDisease setBackground:tfDiseaseBg];
    
    [self setupGesture];
    [self setupBlock];
}

-(void)setupFreeType{
    _viewDiseaseInfo.hidden = YES;
    _viewDiseaseInfoHeight.constant = 0;
    _viewCaseOrPartPhoto.hidden = YES;
    _viewCaseOrPartPhotoHeight.constant = 0;
    _viewIsAskedDoctor.hidden = YES;
    _viewIsAskedDoctorHeight.constant = YES;

    _lbWarn.text = nil;
}

-(void)setupNormalType{
    _viewDiseaseInfo.hidden = YES;
    _viewDiseaseInfoHeight.constant = 0;
    _viewCaseOrPartPhoto.hidden = YES;
    _viewCaseOrPartPhotoHeight.constant = 0;
    _viewIsAskedDoctor.hidden = YES;
    _viewIsAskedDoctorHeight.constant = YES;
    _viewDepartment.hidden = YES;
    _viewDepartmentHeight.constant = 0;
    
    _lbWarn.text = nil;
}

-(void)setupAccurateType{
    _viewDiseaseInfo.hidden = YES;
    _viewDiseaseInfoHeight.constant = 0;
    _viewCaseOrPartPhoto.hidden = YES;
    _viewDepartment.hidden = YES;
    _viewDepartmentHeight.constant = 0;
    _viewCaseOrPartPhotoHeight.constant = 0;
    _lbWarn.text = @"*温馨提示\n1、您购买的服务可向医生提问10条（语言、图片、文字），请在每条信息中尽量描述清楚病情。\n2、您购买的在线咨询服务，请在购买后14日内完成咨询。14日后问题将自动关闭。";
}

-(void)setupQuickType{
    _viewDiseaseDes.hidden = YES;
    _viewDiseaseDesHeight.constant = 0.;
    _viewIsAskedDoctor.hidden = YES;
    _viewIsAskedDoctorHeight.constant = YES;
    _viewCaseOrPartPhoto.hidden = NO;
    _viewCaseOrPartPhotoHeight.constant = 120;
    _lbWarn.text = nil;
}

#pragma mark - 注册通知
- (void)regiseterNotification{
    [kdefaultCenter addObserver:self selector:@selector(showCommitSucessInfo:) name:Notification_ShowCommitInfo object:nil];
}

#pragma mark - 通知回调方法
- (void)showCommitSucessInfo:(NSNotification*) notice{
    NSDictionary* userInfo = notice.userInfo;
    NSNumber* isShow = [userInfo objectForKey:@"showInfo"];
    self.isShowCommitInfo = [isShow boolValue];;
}

/**
 *  添加手势
 */
- (void)setupGesture{
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_viewDiseaseDes addGestureRecognizer:tap];
}

- (void)setupBlock{

    WS(ws);
    [_rgDisease setRadioGroupClick:^(NSUInteger index) {
        if (index == 0) {
            ws.tfDisease.text = nil;
            [ws.tfDisease resignFirstResponder];
            ws.isDiseaseName = NO;
        }else if (index == 1){
            [ws.tfDisease becomeFirstResponder];
            ws.isDiseaseName = YES;
        }
        ws.presenter.hasChoseDisease = YES;
        ws.caseInfo.isKnowDiseaseName = index != 0;
    }];
    
    ws.caseInfo.isInspect = -1;
    [ws.rgIsGotoHospital setRadioGroupClick:^(NSUInteger index) {
        if (index == 0) {
            ws.caseInfo.isInspect = 1;
        }else if (index == 1){
            ws.caseInfo.isInspect = 0;
        }
    }];
    
    [ws.rgCheckData setRadioGroupClick:^(NSUInteger index) {
        if (index == 0) {
            ws.presenter.imageArray = ws.photoPicker.urls;
        }else{
            ws.presenter.imageArray = @[];
        }
    }];
    
    ws.caseInfo.askDepart = -2;
    [ws.rgIsNeedDepartment setRadioGroupClick:^(NSUInteger index) {
        if(index == 1){
            ws.caseInfo.askDepart = (int)ws.indexDepartment;
        }else{
            ws.caseInfo.askDepart = -1;
        }
    }];
    
    [_rgIsAskedDoctor setRadioGroupClick:^(NSUInteger index) {
        if (index == 1) {
            ws.caseInfo.isAskDoctor = YES;
        }else{
            ws.caseInfo.isAskDoctor = NO;
        }
    }];

}

#pragma mark - 监听手势
- (void)handleTapGesture:(UITapGestureRecognizer*) tap{
//    DiseaseDescribeViewController* diseaseDescribe=[DiseaseDescribeViewController new];
//    diseaseDescribe.caseInfo=self.caseInfo;
//    diseaseDescribe.showCommitSucessInfo = self.isShowCommitInfo;
//    [self.navigationController pushViewController:diseaseDescribe animated:YES];
    
    FCDiseaseDescriberViewController* diseaseDescribe=[FCDiseaseDescriberViewController new];
    diseaseDescribe.caseInfo=self.caseInfo;
    diseaseDescribe.showCommitSucessInfo = self.isShowCommitInfo;
    [self.navigationController pushViewController:diseaseDescribe animated:YES];
    
}

#pragma mark Action

-(void)viewHasDiseaseTimeAction:(id)sender{
    [self changeViewHieghtAndStatusWith:_tableHasDiseaseTimeHeight withHeight:_arrayHasDiseaseTime.count * 44. forView:_tableHasDiseaseTime];
}

-(void)setupDepartmentAction{
    WS(ws);
    [_rgIsNeedDepartment setRadioGroupClick:^(NSUInteger index) {
        if (index == 1) {


            ws.caseInfo.askDepart = -1;

            [ws toggleDepartmentViewExtend];
            ws.caseInfo.askDepart = -1;

        }else{
            ws.indexDepartment = -1;
            if (!ws.tableDepartment.hidden) {
                [ws toggleDepartmentViewExtend];
            }
        }
        ws.caseInfo.askDepart = (int)ws.indexDepartment;
    }];
}

-(void)setupCheckDataAction{
    WS(ws);
    [_rgCheckData setRadioGroupClick:^(NSUInteger index) {
        if (index == 0) {
            [ws toggleCheckDataViewExtend];
            ws.presenter.imageArray = ws.photoPicker.urls;

        }else{
            if (!ws.viewCheckDataExtend.hidden) {
                [ws toggleCheckDataViewExtend];
            }
            ws.presenter.imageArray = @[];
        }
    }];
}

-(void)toggleCheckDataViewExtend{
    [self changeViewHieghtAndStatusWith:_viewCheckDataExtendHeight withHeight:130. forView:_viewCheckDataExtend];
}

-(void)toggleDepartmentViewExtend{
    [self changeViewHieghtAndStatusWith:_tableDepartmentHeight withHeight:_arrayDepartment.count * 44. forView:_tableDepartment];
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


#pragma UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == CaseInfoTableTagHasDiseaseTime) {
        return _arrayHasDiseaseTime.count;
    }else if (tableView.tag == CaseInfoTableTagDepartment){
        return _arrayDepartment.count;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = RGB(240, 240, 240);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if (tableView.tag == CaseInfoTableTagHasDiseaseTime) {
        cell.textLabel.text = _arrayHasDiseaseTime[indexPath.row];
        if (_indexHasDiseaseTime == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if (tableView.tag == CaseInfoTableTagDepartment){
        cell.textLabel.text = _arrayDepartment[indexPath.row];
        if (_indexDepartment == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

#pragma UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView beginUpdates];
    if (tableView.tag == CaseInfoTableTagHasDiseaseTime) {
        [_tableHasDiseaseTime reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_indexHasDiseaseTime inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        _indexHasDiseaseTime = indexPath.row;
        [_tableHasDiseaseTime reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        _lbHasDiseaseTime.text = _arrayHasDiseaseTime[indexPath.row];
    }else if (tableView.tag == CaseInfoTableTagDepartment){
        [_tableDepartment reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_indexDepartment inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        _indexDepartment = indexPath.row;
        [_tableDepartment reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tableView endUpdates];
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _presenter.childInfos.count + 1;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    CaseInfoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.item == [self collectionView:collectionView numberOfItemsInSection:0] - 1) {
        cell.imageBg.image = [UIImage imageNamed:@"FCAddNewBaby"];
        cell.lbTitle.textColor = UIColorFromRGB(0x85d5f1);
        cell.lbTitle.text = @"添加宝宝";
        cell.imageSelected.hidden = YES;
    }else{
        ChildEntity * child = _presenter.childInfos[indexPath.item];
        
        [cell.imageBg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,child.child_Img]] placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
        cell.lbTitle.textColor = UIColorFromRGB(0x666666);
        cell.lbTitle.text = child.childName;
        cell.imageSelected.hidden = ![child isEqual:_presenter.currentSelectedChildInfo];
            
        
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 120);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 60);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == [self collectionView:collectionView numberOfItemsInSection:0] - 1) {
        ArchivesMainViewController * vc = [ArchivesMainViewController new];
        vc.poptoClass = [CaseInfoViewController class];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        _presenter.currentSelectedChildInfo = _presenter.childInfos[indexPath.item];
        [collectionView reloadData];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark Life

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_presenter getChildInfo];
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

- (IBAction)commitAction {
    if(![self.doctor.DoctorID integerValue]){
        _caseInfo.doctorId = @"";
    }else{
        _caseInfo.doctorId = [NSString stringWithFormat:@"%@",self.doctor.DoctorID];
    }
    if (self.isDiseaseName == YES) {
        _caseInfo.diseaseName = _tfDisease.text;
    }
    _caseInfo.bellDate = _lbHasDiseaseTime.text;
    if (self.isCheckData == YES) {
        if (_photoPicker.urls.count > 0) {
            _presenter.imageArray = [_photoPicker.urls copy];
        }else{
            _presenter.imageArray = @[];
        }
    }
    
    //病情描述页面添加
    //
//    _caseInfo.descriptionDisease = @"病情描述";
//    _caseInfo.descriptionDiseaseAudio = @"病情描述录音";
////    _caseInfo.descriptionDiseaseImage = @"病情描述图片";
//    _caseInfo.drugAndInspect = @"药品使用和其他治疗";
//    _caseInfo.drugAndInspectAudio = @"录音";
    //
    _caseInfo.inspectionData = _tfCheckData.text;
    
//    [ProgressUtil show];
    [_presenter commitCaseInfo:_caseInfo];
}

#pragma mark CaseInfoPresenterDelegate

- (void)commitCaseInfoSuccess:(BOOL ) success info:(NSString *) info{
    
    
    
    
    
    JMChatViewController * conversationVC = [[JMChatViewController alloc]init];

    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId =self.doctorId;

    //  conversationVC.targetName =model.conversationTitle;


    [self.navigationController pushViewController:conversationVC animated:YES];
    
        
    return;
    
    
 
    
    [ProgressUtil dismiss];

 
    if (success == YES) {
        
        if (_caseInfoType == CaseInfoTypeQuick){
            [ProgressUtil dismiss];
            [self.navigationController pushViewController:[QCDoctorListViewController new] animated:YES];
        }else if (_caseInfoType == CaseInfoTypeAccuration){
            OrderSubmitViewController * vc = [OrderSubmitViewController new];
            vc.orderNum = _presenter.orderNum;
            vc.orderNum = _presenter.resultId;
            [ProgressUtil showInfo:@"提交成功"];
#warning 临时隐藏
//            [self.navigationController pushViewController:vc animated:YES];
        }else if(_caseInfoType == CaseInfoTypeFree){
            
           
            JMChatViewController * conversationVC = [[JMChatViewController alloc]init];

            conversationVC.conversationType =ConversationType_PRIVATE;
            conversationVC.targetId =self.doctorId;            //  conversationVC.targetName =model.conversationTitle;
            
         

            [self.navigationController pushViewController:conversationVC animated:YES];
        
            [ProgressUtil dismiss];
#pragma mark 这里去聊天
        
            
            
            
        }else if(self.caseInfoType ==  CaseInfoTypeVIP || self.caseInfoType ==  CaseInfoTypeNormal){
            [ProgressUtil dismiss];
            OutpatientSuccessViewController* success = [OutpatientSuccessViewController new];
            success.successTitle = @"您已经预约成功!";
            success.titleArray = @[@"时间: 2016年3月10日09:30",@"科室: 小儿内科",@"地点: 济南市儿童医院"];
            success.tips = @"* 温馨提示: 预约信息可在首页事件提醒中查看";
            [self.navigationController pushViewController:success animated:YES];
            
            
        }
    }else{
        [ProgressUtil showInfo:info];
    }
}

-(void)onnGetChildInfosComplete{
    [_collectionView reloadData];
}

- (void)onUploadCompletion:(BOOL)success info:(NSString *)info{
    if(success){
        [_presenter commitConsultaion];
    }else{
        [ProgressUtil showError:info];
    }
}


-(void)dealloc{
    
    [kdefaultCenter removeObserver:self name:Notification_ShowCommitInfo object:nil];
}

@end
