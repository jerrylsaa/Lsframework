//
//  ACDoctorDetailViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACDoctorDetailViewController.h"
#import "TQStarRatingView.h"
#import "ZHDocDetailView.h"
#import "ACPhoneConsultationViewController.h"
#import "CaseInfoViewController.h"
#import "JTImageButton.h"
#import "BookingDateViewController.h"
#import "ConsultationDoctorViewController.h"
#import "ACDoctorDetailPresenter.h"
#import <UIImageView+WebCache.h>
#import "JMFoundation.h"
#import "JMChatViewController.h"



#define AC_FONT [UIFont systemFontOfSize:(kScreenWidth == 320 ? 14 : 18)]

@interface ACDoctorDetailViewController ()<UIActionSheetDelegate>
{
    UIScrollView *_scrollView;
    
    UIImageView *_headImageView;
    TQStarRatingView *_scoleView;
    UILabel *_nameLabel;
    UILabel *_postLabel;
    UILabel *_department;
    
    
    ZHDocDetailView *_niceView;
    ZHDocDetailView *_askView;
    JTImageButton *_onlineView;
    JTImageButton *_phoneView;
    
    UILabel *_addressLabel;
    UILabel *_fieldLabel;
    
    UIButton *_addDoctorButton;
    
    UIButton *_sampleInfoButton;
    UIButton *_appointmentButton;
    
    ACDoctorDetailPresenter *_presenter;
    UIButton *_processesButton;
}

@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *postLabel;
@property (nonatomic ,strong)UILabel *department;
@property (nonatomic ,strong)ZHDocDetailView *niceView;
@property (nonatomic ,strong)ZHDocDetailView *askView;
@property (nonatomic ,strong)UILabel *addressLabel;
@property (nonatomic ,strong)UILabel *fieldLabel;
@property (nonatomic ,strong)TQStarRatingView *scoleView;;
//<<<<<<< HEAD
@property (nonatomic ,strong)UIImageView *headImageView;
//=======
@property(nonatomic,retain) DoctorList *doctor;
//>>>>>>> 55be5bd3f7d7ed4abfee5bf4ca64f6a3a0ebc51a
@property (nonatomic ,strong)UIButton *addDoctorButton;

@end

@implementation ACDoctorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.docDetailType == DoctorDetailTypeAccuration) {
    [self initBackBarWithImage:nil];
    [self initLeftBarWithTitle:@"取消咨询"];
    }
    
//    [self initRightBarWithTitle:@"关注"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"医生详情";
    _presenter = [ACDoctorDetailPresenter new];
    [self setupScrollView];
    [self setupHeaderImageView];
    [self setupStarView];
    [self setupNameView];
    [self setupPostView];
    [self setDepartmentView];
//    [self setNiceView];
//    [self setupAskview];
    [self setupOnlineAskView];
    [self setupPhoneView];
    [self setupAddressView];
    [self setupFieldView];
    [self setupAddButton];
//    [self setupProcesses];
    [self separatorline];
    if (self.docDetailType == DoctorDetailTypeBooking) {
        [self setupInfoAndAppointmentView];
    }
    [self loadData];
    
}
#pragma mark scrollView
- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 500);
}
#pragma mark 头像
- (void)setupHeaderImageView{
    
    _headImageView = [UIImageView new];
//    _headImageView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(_scrollView,20).topSpaceToView(_scrollView,15).widthIs(80).heightIs(80);
}
#pragma mark 评分
- (void)setupStarView{
    _scoleView = [TQStarRatingView new];
    _scoleView.userInteractionEnabled = NO;
    [_scrollView addSubview:_scoleView];
    _scoleView.sd_layout.leftSpaceToView(_scrollView,20).topSpaceToView(_headImageView,10).widthIs(80).heightIs(10);
}

#pragma mark 姓名
- (void)setupNameView{
    _nameLabel = [UILabel new];
    _nameLabel.font = AC_FONT;
    _nameLabel.textColor = UIColorFromRGB(0x666666);
    [_scrollView addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_headImageView,20).rightSpaceToView(_scrollView,25).topSpaceToView(_scrollView,15).heightIs(20);
}

#pragma mark 职称
- (void)setupPostView{
    _postLabel = [UILabel new];
    _postLabel.font = AC_FONT;
    _postLabel.textColor = UIColorFromRGB(0x999999);
    [_scrollView addSubview:_postLabel];
    _postLabel.sd_layout.leftEqualToView(_nameLabel).rightEqualToView(_nameLabel).topSpaceToView(_nameLabel,10).heightIs(20);
}

#pragma mark 科室
- (void)setDepartmentView{
    _department = [UILabel new];
    _department.font = AC_FONT;
    _department.textColor = _postLabel.textColor;
    [_scrollView addSubview:_department];
    _department.sd_layout.leftEqualToView(_nameLabel).rightEqualToView(_nameLabel).topSpaceToView(_postLabel,10).heightIs(20);
}

#pragma mark 好评
- (void)setNiceView{
    _niceView = [ZHDocDetailView new];
    [_scrollView addSubview:_niceView];
    _niceView.sd_layout.leftSpaceToView(_scrollView,115).topSpaceToView(_department,27).widthIs((kScreenWidth - 115)/2).heightIs(20);
    [_niceView initSubViews];
    _niceView.iconView.image = [UIImage imageNamed:@"ac_nice"];
    _niceView.textLabel.textColor = UIColorFromRGB(0x999999);
    _niceView.textLabel.font = AC_FONT;
}

#pragma mark 咨询
- (void)setupAskview{
    _askView = [ZHDocDetailView new];
    [_scrollView addSubview:_askView];
    _askView.sd_layout.leftSpaceToView(_niceView,0).topSpaceToView(_department,27).widthIs((kScreenWidth - 115)/2).heightIs(20);
    [_askView initSubViews];
    _askView.iconView.image = [UIImage imageNamed:@"ac_ask"];
    _askView.textLabel.textColor = UIColorFromRGB(0x999999);
    _askView.textLabel.font = AC_FONT;
}

#pragma mark 在线咨询
- (void)setupOnlineAskView{
    
    _onlineView = [JTImageButton new];
    [_onlineView createTitle:@""
                    withIcon:[UIImage imageNamed:@"ac_onlineask"]
                        font:AC_FONT
                  iconHeight:40
                 iconOffsetY:-5];
    _onlineView.borderWidth = 0;
    _onlineView.cornerRadius = 20;
    _onlineView.titleColor = [UIColor whiteColor];
    [_onlineView addTarget:self action:@selector(onlineAction) forControlEvents:UIControlEventTouchUpInside];
    [_onlineView setBackgroundImage:[self stretchableImageWithImageName:@"ac_onlineback"] forState:UIControlStateNormal];
    [_scrollView addSubview:_onlineView];
//    _onlineView.sd_layout.leftSpaceToView(_scrollView,115).rightSpaceToView(_scrollView,0).topSpaceToView(_niceView,20).heightIs(40);
    
    _onlineView.sd_layout.leftSpaceToView(_scrollView,115).rightSpaceToView(_scrollView,0).topSpaceToView(_department,27).heightIs(40);
}

#pragma mark 电话咨询
- (void)setupPhoneView{
    
    _phoneView = [JTImageButton new];
    [_phoneView createTitle:@""
                   withIcon:[UIImage imageNamed:@"ac_phone"]
                       font:AC_FONT
                 iconHeight:40
                iconOffsetY:-5];
    _phoneView.tag = 111;
    _phoneView.borderWidth = 0;
    _phoneView.cornerRadius = 20;
    _phoneView.titleColor = [UIColor whiteColor];
    [_phoneView addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    [_phoneView setBackgroundImage:[self stretchableImageWithImageName:@"ac_phoneback"] forState:UIControlStateNormal];
    [_scrollView addSubview:_phoneView];
    _phoneView.sd_layout.leftSpaceToView(_scrollView,115).rightSpaceToView(_scrollView,0).topSpaceToView(_onlineView,20).heightIs(40);
    _phoneView.hidden =YES;
}

#pragma mark 执业地点
- (void)setupAddressView{
    _addressLabel = [UILabel new];
    _addressLabel.textColor = UIColorFromRGB(0x999999);
    _addressLabel.numberOfLines = 0;
    _addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_scrollView addSubview:_addressLabel];
    _addressLabel.sd_layout.leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).topSpaceToView(_phoneView,10).heightIs(60);
    _addressLabel.font = AC_FONT;
}

#pragma mark 擅长领域
- (void)setupFieldView{
    _fieldLabel = [UILabel new];
    _fieldLabel.textColor = _addressLabel.textColor;
    _fieldLabel.numberOfLines = 0;
    _fieldLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_scrollView addSubview:_fieldLabel];
    _fieldLabel.sd_layout.leftEqualToView(_addressLabel).rightEqualToView(_addressLabel).topSpaceToView(_addressLabel,0).heightIs(60);
    _fieldLabel.font = AC_FONT;
}
#pragma  mark 添加私人医生
- (void)setupAddButton{
    _addDoctorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addDoctorButton.hidden =YES;
//    _addDoctorButton.clipsToBounds = YES;
    [_addDoctorButton setTitle:@"添加私人医生" forState:UIControlStateNormal];
    [_addDoctorButton setBackgroundImage:[self stretchableImageWithImageName:@"ac_commit"] forState:UIControlStateNormal];
    [_addDoctorButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_addDoctorButton];
    _addDoctorButton.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_fieldLabel,60).heightIs(40);/*60*/
    _addDoctorButton.layer.cornerRadius = _addDoctorButton.height/2;
}
#pragma mark 医生简介和预约就诊按钮
- (void)setupInfoAndAppointmentView{
    
    _sampleInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sampleInfoButton setTitle:@"简介" forState:UIControlStateNormal];
    _sampleInfoButton.clipsToBounds = YES;
    [_sampleInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sampleInfoButton setBackgroundImage:[self stretchableImageWithImageName:@"book_doc_info"] forState:UIControlStateNormal];
    _sampleInfoButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_sampleInfoButton addTarget:self action:@selector(sampleAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sampleInfoButton];
//    _sampleInfoButton.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scoleView,25).widthIs(70).heightIs(25);
    _sampleInfoButton.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_department,34.5).widthIs(70).heightIs(25);
    _sampleInfoButton.layer.cornerRadius = _sampleInfoButton.height/2;
   
    _appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_appointmentButton setBackgroundImage:[UIImage imageNamed:@"book_app"] forState:UIControlStateNormal];
    _appointmentButton.clipsToBounds = YES;
    [_appointmentButton addTarget:self action:@selector(appointmentAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_appointmentButton];
    _appointmentButton.sd_layout.leftSpaceToView(_scrollView,20).topSpaceToView(_sampleInfoButton,13).widthIs(80).heightIs(80);
    _appointmentButton.layer.cornerRadius = _appointmentButton.height/3;
}

//rigihtItem
- (void)setupProcesses{
    
    _processesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [_processesButton setTitle:@"关注" forState:UIControlStateNormal];
//    _processesButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_processesButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    [_processesButton addTarget:self action:@selector(processesAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_processesButton];
    [self.navigationItem setRightBarButtonItem:backItem];
}

#pragma mark 添加分割线
- (void)separatorline{
    UIView *sep_1 = [UIView new];
    sep_1.backgroundColor = UIColorFromRGB(0xdbdbdb);
//    [_scrollView addSubview:sep_1];
//    sep_1.sd_layout.leftSpaceToView(_scrollView,115).topSpaceToView(_niceView,10).rightSpaceToView(_scrollView,0).heightIs(1);
//    
    UIView *sep_2 = [UIView new];
    sep_2.backgroundColor = sep_1.backgroundColor;
    [_scrollView addSubview:sep_2];
    sep_2.sd_layout.leftSpaceToView(_scrollView,115).topSpaceToView(_onlineView,10).rightSpaceToView(_scrollView,0).heightIs(1);
    
    UIView *sep_3 = [UIView new];
    sep_3.backgroundColor = sep_1.backgroundColor;
    [_scrollView addSubview:sep_3];
//    sep_3.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_phoneView,10).heightIs(1);
    sep_3.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_phoneView,40).heightIs(1);
    
    UIView *sep_4 = [UIView new];
    sep_4.backgroundColor = sep_1.backgroundColor;
    [_scrollView addSubview:sep_4];
    sep_4.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_addressLabel,0).heightIs(1);
    
    UIView *sep_5 = [UIView new];
    sep_5.backgroundColor = sep_1.backgroundColor;
    [_scrollView addSubview:sep_5];
    sep_5.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_fieldLabel,0).heightIs(1);
}

#pragma mark 加载数据
- (void)loadData{
    WS(ws);
    [_presenter loadDataWithDoctorId:self.doctorId completeWith:^(BOOL success, DoctorList *doctor) {
//<<<<<<< HEAD
//        [ws.headImageView sd_setImageWithURL:nil placeholderImage:ws.headImage];
        ws.headImageView.image = ws.headImage;
//=======
        ws.doctor = doctor;
        ws.doctor.DoctorID = ws.doctorId;
//>>>>>>> 55be5bd3f7d7ed4abfee5bf4ca64f6a3a0ebc51a
        ws.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",doctor.UserName];
        ws.postLabel.text = [NSString stringWithFormat:@"职称：%@",doctor.DoctorTitle];
        ws.department.text = [NSString stringWithFormat:@"科室：%@",doctor.DepartName];
//        [_onlineView setTitle:[NSString stringWithFormat:@"在线咨询：%@/次",doctor.] forState:UIControlStateNormal];
        NSString *onlineTitle = (doctor.TextPrice != 0.f ? [NSString stringWithFormat:@"在线咨询：%.f/%@%@",doctor.TextPrice,doctor.TextTime,doctor.TextUnit]:@"在线咨询");
        [_onlineView reloadTitle:onlineTitle];
        NSString *phoneTitle = (doctor.AudioPrice != 0.f ? [NSString stringWithFormat:@"电话咨询：%.f/%@%@",doctor.AudioPrice,doctor.AudioTime,doctor.AudioUnit]:@"电话咨询");
        [_phoneView reloadTitle:phoneTitle];
        ws.addressLabel.text = [NSString stringWithFormat:@"执业地点：%@",doctor.HName];
        ws.fieldLabel.text = [NSString stringWithFormat:@"擅长领域：%@",doctor.Field];
        ws.niceView.textLabel.text = [NSString stringWithFormat:@"%@",@"50"];//doctor.PraiseNum
        [ws.scoleView setScore:doctor.StarNum/10.f withAnimation:YES];
        ws.askView.textLabel.text = [NSString stringWithFormat:@"%@",@"120"];
        
        NSString *text = [NSString stringWithFormat:@"擅长领域：%@",doctor.Field];
        CGFloat height = [JMFoundation calLabelHeight:AC_FONT andStr:text withWidth:ws.fieldLabel.width];
        if (height <= 60) {
            height = 60;
        }
        
        NSString *addressText = [NSString stringWithFormat:@"执业地点：%@",doctor.HName];
        CGFloat addressHeight = [JMFoundation calLabelHeight:AC_FONT andStr:addressText withWidth:ws.fieldLabel.width];
        if (addressHeight <= 60) {
            addressHeight = 60;
        }
//        ws.addressLabel.sd_layout.leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).topSpaceToView(_phoneView,10).heightIs(60);
        ws.addressLabel.sd_layout.leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).topSpaceToView(_phoneView,40).heightIs(60);
        ws.fieldLabel.sd_layout.leftEqualToView(_addressLabel).rightEqualToView(_addressLabel).topSpaceToView(_addressLabel,0).heightIs(height);
        ws.addDoctorButton.sd_layout.leftSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,15).topSpaceToView(_fieldLabel,60).heightIs(40);
        [ws.addressLabel updateLayout];
        [ws.fieldLabel updateLayout];
        [ws.addDoctorButton updateLayout];
    }];
}


//Action
- (void)commitAction{
    
    [((RDVTabBarController*)self.navigationController.parentViewController) setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSLog(@"commit");
}
//-(void)rightItemAction:(id)sender{
//    __weak UIButton *weakButton = _processesButton;
//    
//    if ([_processesButton.titleLabel.text isEqualToString:@"关注"]) {
//        [_presenter addAttention:self.doctorId complete:^(BOOL success, DoctorList *doctor) {
//            if (success == YES) {
//                [weakButton setTitle:@"取消关注" forState:UIControlStateNormal];
//            }
//        }];
//    }else{
//        [_presenter deleteAttention:self.doctorId complete:^(BOOL success, DoctorList *doctor) {
//            if (success == YES) {
//                [weakButton setTitle:@"关注" forState:UIControlStateNormal];
//            }
//        }];
//    }
//
//}

- (void)processesAction{

    __weak UIButton *weakButton = _processesButton;
    
    if ([_processesButton.titleLabel.text isEqualToString:@"关注"]) {
        [_presenter addAttention:self.doctorId complete:^(BOOL success, DoctorList *doctor) {
            if (success == YES) {
                [weakButton setTitle:@"取消关注" forState:UIControlStateNormal];
                [weakButton setTitleEdgeInsets:UIEdgeInsetsMake(0,20, 0, 0)];

            }
        }];
    }else{
        [_presenter deleteAttention:self.doctorId complete:^(BOOL success, DoctorList *doctor) {
            if (success == YES) {
                [weakButton setTitle:@"关注" forState:UIControlStateNormal];
                [weakButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];

            }
        }];
    }
}
- (void)onlineAction{
    
    JMChatViewController * vc  =[[JMChatViewController alloc] init];
    
    vc.conversationType = ConversationType_CUSTOMERSERVICE;
  
    vc.targetId = PUBLIC_SERVICE_KEY;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    CaseInfoViewController * vc = [CaseInfoViewController new];
    vc.caseInfoType = CaseInfoTypeAccuration;
//    vc.doctorId = [NSString stringWithFormat:@"%@", _doctorId];
    vc.doctor = self.doctor;
    [self.navigationController pushViewController:vc animated:YES];
    */
    
    
    
    
}
- (void)phoneAction{
    ACPhoneConsultationViewController *vc = [ACPhoneConsultationViewController new];
    vc.doctor = self.doctor;
    [self.navigationController pushViewController:vc animated:YES];
}
//简介
- (void)sampleAction{
    NSLog(@"简介");
}
//预约门诊
- (void)appointmentAction{
    BookingDateViewController* bookDate = [BookingDateViewController new];
    bookDate.doctor = self.doctor;
    NSLog(@"--%@",bookDate.doctor.DoctorID);
       [self.navigationController pushViewController:bookDate animated:YES];
    
    NSLog(@"%@",self.doctorId);
    
    
}

- (UIImage *)stretchableImageWithImageName:(NSString *)imageName{
    //裁减拉伸图片
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect myImageRect = CGRectMake(image.size.width/2 - 1, image.size.height/2 -1 , 3, 3);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size = CGSizeMake(myImageRect.size.width, myImageRect.size.height);
    UIGraphicsBeginImageContext (size);
    CGContextRef context = UIGraphicsGetCurrentContext ();
    CGContextDrawImage (context, myImageRect, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage :subImageRef];
    UIGraphicsEndImageContext ();
    image = [newImage stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    return image;
}

#pragma mark - 点击事件
-(void)backItemAction:(id)sender{
    if (self.docDetailType == DoctorDetailTypeBooking) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if([[UIDevice currentDevice].systemVersion doubleValue]<8.0){
        
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"您确定要取消咨询吗?",@"确定",nil];
        [sheet showInView:self.view];
        
        return ;
    }
    //适配ios8以上
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(alert) weakAlert = alert ;
    UIAlertAction* title=[UIAlertAction actionWithTitle:@"您确定要取消咨询吗?" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    WS(ws);
    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alert addAction:title];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
