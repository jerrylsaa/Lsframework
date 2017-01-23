//
//  ConsultationDoctorTableViewCell.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyDoctorEntity.h"
#import "TQStarRatingView.h"

@interface ConsultationDoctorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TQStarRatingView *starRating;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodat;
@property (weak, nonatomic) IBOutlet UIImageView *imageDoctorAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lbDepartment;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

-(void)configCell:(FamilyDoctorEntity*)entity;

@end
