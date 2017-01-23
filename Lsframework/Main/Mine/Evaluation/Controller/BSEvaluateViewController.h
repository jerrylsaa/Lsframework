//
//  BSEvaluateViewController.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "TQStarRatingView.h"
#import "MyDoctorEvaluation.h"

@interface BSEvaluateViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextView         *evaluateTextView;// 服务态度输入框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateTextViewHeight;// 服务态度输入框高
@property (weak, nonatomic) IBOutlet UILabel            *textViewPlaceholder;// textView的placeholder
@property (weak, nonatomic) IBOutlet UILabel            *timeLabel;// 申请时间
@property (weak, nonatomic) IBOutlet UILabel            *consultTypeLabel;// 咨询方式
@property (weak, nonatomic) IBOutlet UIImageView        *headImageView;// 头像
@property (weak, nonatomic) IBOutlet UILabel            *doctorLevelLabel;// 医生职称
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;// 医生名字
@property (weak, nonatomic) IBOutlet UILabel            *departmentsLabel;// 所属科室
@property (weak, nonatomic) IBOutlet UILabel            *domainLabel;// 擅长领域
@property (weak, nonatomic) IBOutlet UILabel            *patientAndFollowUp;// 患者和随访人数
@property (weak, nonatomic) IBOutlet TQStarRatingView   *tqStarRatingView;// 好评度
@property (weak, nonatomic) IBOutlet UIButton           *headButton;// 点击头像
@property (weak, nonatomic) IBOutlet UILabel            *diseaseLabel;// 所患疾病
@property (weak, nonatomic) IBOutlet UIButton           *anonymityBtn;// 匿名按钮
@property (weak, nonatomic) IBOutlet UIButton           *publishBtn;// 发表按钮
@property (weak, nonatomic) IBOutlet TQStarRatingView   *majorView;
@property (weak, nonatomic) IBOutlet TQStarRatingView   *mannerView;
@property (weak, nonatomic) IBOutlet TQStarRatingView   *replyView;

@property (nonatomic, strong) NSString *patientNum;// 患者人数
@property (nonatomic, strong) NSString *FollowUpNum;// 随访人数

@property(nonatomic ,assign)NSInteger doctorId;

@property(nonatomic,strong) MyDoctorEvaluation *model;

@end
