//
//  QCDoctorListTableViewCell.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostImageView.h"
#import "DescribeView.h"
#import "TQStarRatingView.h"
#import "DoctorList.h"


@interface QCDoctorListTableViewCell : UITableViewCell

@property(nonatomic,retain) UIImageView* icon;
@property(nonatomic,retain) UILabel* postLabel;//职称
@property(nonatomic,retain) TQStarRatingView* start;//星级

@property(nonatomic,retain) UILabel* nameLabel;//名字
@property(nonatomic,retain) UILabel* departLabel;//科室
@property(nonatomic,retain) UILabel* onlineLabel;//在线咨询
@property(nonatomic,retain) UILabel* phoneLabel;//电话咨询
@property(nonatomic,retain) UILabel* fieldLabel;//领域
@property(nonatomic,retain) UILabel* patientLabel;//病人
@property(nonatomic,retain) UILabel* followLabel;//随访
@property(nonatomic,retain) UILabel* postionLabel;//位置


@property(nonatomic,retain) DoctorList* doctor;


//- (void)configureCell:(DoctorList*) doctor;


@end
