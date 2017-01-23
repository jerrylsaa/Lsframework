//
//  FDDoctorInfoViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//  医生信息

#import "FDDoctorInfoViewController.h"
#import "TQStarRatingView.h"
#import "ZHImageTitleLabel.h"
#import "UIImage+Category.h"
#import "CaseInfoViewController.h"


@interface FDDoctorInfoViewController (){
    UIScrollView* _scrollView;
    UIImageView* _headImageView;//头像
    TQStarRatingView* _star;//星星
    UIButton* _introduce;//简介
    
    NSString* _nameTitle;//名字
    UILabel* _nameLabel;
    NSString* _postTitle;//职称
    UILabel* _postLabel;
    NSString* _departTitle;//科室
    UILabel* _departLabel;
    
    ZHImageTitleLabel* _goodComment;//好评
    ZHImageTitleLabel* _advisory;//咨询
    UIView* _commentLine;//分割线
    
    ZHImageTitleLabel* _signPatient;//签约患者
    UIButton* _advisorybt;//预约/咨询
    
    UIView* _placeLine;
    UILabel* _placeLabel;//执业地点
    UIView* _fieldLine;
    UILabel* _fieldLabel;//擅长领域
    
    UIView* _packageLine;
    UIView* _packageBgView;
    UILabel* _packageService;//套餐服务
    UILabel* _specialAppoint;//特需门诊
    UILabel* _accurateAdvisory;//精准咨询
    UILabel* _medAssitatant;//就医协助
    UILabel* _monSpa;//护理
    
    
    
}

@property(nonatomic,retain) NSMutableArray* packageLabelArray;

@end

@implementation FDDoctorInfoViewController

-(NSMutableArray *)packageLabelArray{
    if(!_packageLabelArray){
        _packageLabelArray=[NSMutableArray array];
    }
    return _packageLabelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.title = @"家庭医生服务";
    
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [self setupHedaerAndStarAndIntroduceView];
    [self setupNameAndDepartAndPostView];
    [self setupCommentAndAdvisoryView];
    [self setupSignPatientAndAppointView];
    [self setupPlaceAndFieldView];
    [self setupPackageView];
}

#pragma mark - 加载子视图
/**
 *  头像，星星，简介
 */
- (void)setupHedaerAndStarAndIntroduceView{
    _headImageView = [UIImageView new];
    _headImageView.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(_scrollView,20).topSpaceToView(_scrollView,15).widthIs(80).heightEqualToWidth();
    _star = [TQStarRatingView new];
    [_scrollView addSubview:_star];
    _star.sd_layout.leftSpaceToView(_scrollView,20).topSpaceToView(_headImageView,10).widthIs(80).heightIs(10);
    [_star updateLayout];
    [_star setScore:0.7 withAnimation:YES];

    _introduce = [UIButton new];
    [_introduce setBackgroundImage:[UIImage imageNamed:@"doctorInfo_introduce"] forState:UIControlStateNormal];
    [_introduce setTitle:@"简介" forState:UIControlStateNormal];
    [_introduce addTarget:self action:@selector(introduceAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_introduce];
    _introduce.sd_layout.topSpaceToView(_star,25).leftEqualToView(_headImageView).heightIs(25).widthIs(65);
}

/**
 *  姓名，职称，科室
 */
- (void)setupNameAndDepartAndPostView{
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.textColor = UIColorFromRGB(0x666666);
    [_scrollView addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_headImageView,20).rightEqualToView(_scrollView).topSpaceToView(_scrollView,15).heightIs(20);
    _nameTitle = self.doctor.userName;
    _nameLabel.text = [NSString stringWithFormat:@"姓名: %@",_nameTitle];
    
    _postLabel = [UILabel new];
    _postLabel.font = _nameLabel.font;
    _postLabel.textColor = UIColorFromRGB(0x999999);
    [_scrollView addSubview:_postLabel];
    _postLabel.sd_layout.leftEqualToView(_nameLabel).rightEqualToView(_nameLabel).topSpaceToView(_nameLabel,10).heightIs(20);
    _postTitle = self.doctor.profession;
    _postLabel.text = [NSString stringWithFormat:@"职称: %@",_postTitle];
    
    _departLabel = [UILabel new];
    _departLabel.font = _postLabel.font;
    _departLabel.textColor = _postLabel.textColor;
    [_scrollView addSubview:_departLabel];
    _departLabel.sd_layout.leftEqualToView(_nameLabel).rightEqualToView(_nameLabel).topSpaceToView(_postLabel,10).heightIs(20);
    _departTitle = self.doctor.departName;
    _departLabel.text = [NSString stringWithFormat:@"科室: %@",_departTitle];
}

/**
 *  好评，咨询
 */
- (void)setupCommentAndAdvisoryView{
    _goodComment = [ZHImageTitleLabel new];
    _goodComment.imageName = @"ac_nice";
    _goodComment.title = @"好评:";
    _goodComment.content = @"60";
    [_scrollView addSubview:_goodComment];
    _goodComment.sd_layout.topSpaceToView(_departLabel,25).heightIs(18).leftEqualToView(_departLabel);
    [_goodComment setupAutoWidthWithRightView:_goodComment.titleLabel rightMargin:0];
    
    _advisory = [ZHImageTitleLabel new];
    _advisory.imageName = @"ac_ask";
    _advisory.title = @"咨询:";
    _advisory.content = @"50";
    _advisory.unit = @"例";
    [_scrollView addSubview:_advisory];
    _advisory.sd_layout.topEqualToView(_goodComment).bottomEqualToView(_goodComment).rightSpaceToView(_scrollView,35);
    [_advisory setupAutoWidthWithRightView:_advisory.titleLabel rightMargin:0];
    
    _commentLine = [UIView new];
    _commentLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_scrollView addSubview:_commentLine];
    _commentLine.sd_layout.leftEqualToView(_goodComment).topSpaceToView(_goodComment,15).rightEqualToView(_scrollView).heightIs(1);
    
}

/**
 *  签约患者，预约/咨询
 */
- (void)setupSignPatientAndAppointView{
    _signPatient = [ZHImageTitleLabel new];
    _signPatient.imageName = @"docotorInfo_patient";
    _signPatient.title = @"签约患者:";
    _signPatient.content = @"10";
    [_scrollView addSubview:_signPatient];
    _signPatient.sd_layout.topSpaceToView(_commentLine,15).heightIs(18).leftEqualToView(_departLabel);
    [_signPatient setupAutoWidthWithRightView:_signPatient.titleLabel rightMargin:0];
    
    _advisorybt = [UIButton new];
    [_advisorybt setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x2CADA2)] forState:UIControlStateNormal];
    [_advisorybt setTitle:@"发送消息" forState:UIControlStateNormal];
    [_advisorybt addTarget:self action:@selector(appointAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_advisorybt];
    _advisorybt.sd_layout.topSpaceToView(_signPatient,15).heightIs(40).leftEqualToView(_signPatient).rightEqualToView(_scrollView);
    _advisorybt.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    
}

/**
 *  执业地点，擅长领域
 */
- (void)setupPlaceAndFieldView{
    _placeLine = [UIView new];
    _placeLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_scrollView addSubview:_placeLine];
    _placeLine.sd_layout.leftEqualToView(_scrollView).topSpaceToView(_advisorybt,15).rightEqualToView(_scrollView).heightIs(1);
    
    _placeLabel = [UILabel new];
    _placeLabel.font = [UIFont systemFontOfSize:18];
    _placeLabel.text = [NSString stringWithFormat:@"执业地点: %@",@"北京儿童医院/小儿内科"];
    [_scrollView addSubview:_placeLabel];
    _placeLabel.sd_layout.topSpaceToView(_placeLine,15).leftEqualToView(_headImageView).rightEqualToView(_scrollView).heightIs(18);
    
    _fieldLine = [UIView new];
    _fieldLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_scrollView addSubview:_fieldLine];
    _fieldLine.sd_layout.leftEqualToView(_scrollView).topSpaceToView(_placeLabel,15).rightEqualToView(_scrollView).heightIs(1);
    
    _fieldLabel = [UILabel new];
    _fieldLabel.font = _placeLabel.font;
    _fieldLabel.text = [NSString stringWithFormat:@"擅长领域: %@",@"腰间盘突出/脊柱病"];
    [_scrollView addSubview:_fieldLabel];
    _fieldLabel.sd_layout.topSpaceToView(_fieldLine,15).leftEqualToView(_placeLabel).rightEqualToView(_scrollView).heightIs(18);
}

/**
 *  套餐服务
 */
- (void)setupPackageView{
    _packageLine = [UIView new];
    _packageLine.backgroundColor = UIColorFromRGB(0xdbdbdb);
    [_scrollView addSubview:_packageLine];
    _packageLine.sd_layout.leftEqualToView(_scrollView).topSpaceToView(_fieldLabel,15).rightEqualToView(_scrollView).heightIs(1);
    
    _packageBgView = [UIView new];
    _packageBgView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_scrollView addSubview:_packageBgView];
    
    _packageService = [UILabel new];
    _packageService.font = [UIFont systemFontOfSize:18];
    _packageService.text = [NSString stringWithFormat:@"您家庭医生套餐服务: %@",@"6600套餐"];
    _specialAppoint = [UILabel new];
    _specialAppoint.font = [UIFont systemFontOfSize:14];
    _specialAppoint.textColor = UIColorFromRGB(0x8B8B8B);
    _specialAppoint.text = [NSString stringWithFormat:@"您还有%@次特需门诊预约",@"3"];
    _accurateAdvisory = [UILabel new];
    _accurateAdvisory.font = _specialAppoint.font;
    _accurateAdvisory.textColor = _specialAppoint.textColor;
    _accurateAdvisory.text = [NSString stringWithFormat:@"您还有%@次精准咨询权限",@"6"];
    _medAssitatant = [UILabel new];
    _medAssitatant.font = _specialAppoint.font;
    _medAssitatant.textColor = _specialAppoint.textColor;
    _medAssitatant.text = [NSString stringWithFormat:@"您还有%@次全程就医协助",@"2"];
    _monSpa = [UILabel new];
    _monSpa.font = _specialAppoint.font;
    _monSpa.textColor = _specialAppoint.textColor;
    _monSpa.text = [NSString stringWithFormat:@"妈妈护理: %@",@"SPA, 瑜伽, 健身"];
    
    [_packageBgView sd_addSubviews:@[_packageService,_specialAppoint,_accurateAdvisory,_medAssitatant,_monSpa]];
    
    _packageBgView.sd_layout.topSpaceToView(_packageLine,0).leftEqualToView(_scrollView).rightEqualToView(_scrollView);
    _packageService.sd_layout.leftSpaceToView(_packageBgView,20).rightEqualToView(_packageBgView).topSpaceToView(_packageBgView,15).heightIs(18);
    _specialAppoint.sd_layout.leftEqualToView(_packageService).rightEqualToView(_packageService).topSpaceToView(_packageService,15).heightIs(10);
    _accurateAdvisory.sd_layout.leftEqualToView(_packageService).rightEqualToView(_packageService).topSpaceToView(_specialAppoint,15).heightIs(10);
    _medAssitatant.sd_layout.leftEqualToView(_packageService).rightEqualToView(_packageService).topSpaceToView(_accurateAdvisory,15).heightIs(10);
    _monSpa.sd_layout.leftEqualToView(_packageService).rightEqualToView(_packageService).topSpaceToView(_medAssitatant,15).heightIs(10);

    [_packageBgView setupAutoHeightWithBottomView:_monSpa bottomMargin:15];
    [_scrollView setupAutoContentSizeWithBottomView:_packageBgView bottomMargin:10];
}

#pragma mark - 点击事件
/**
 *  简介
 */
- (void)introduceAction{

}

/**
 *  预约/咨询
 */
- (void)appointAction{
    CaseInfoViewController * vc = [CaseInfoViewController new];
    vc.doctorId = self.doctor.doctorID;
    vc.caseInfoType = CaseInfoTypeFree;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
