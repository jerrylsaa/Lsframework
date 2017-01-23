//
//  EventRemindTableViewCell.h
//  FamilyPlatForm
//
//  Created by Tom on 16/6/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface EventRemindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbApplyTime;
@property (weak, nonatomic) IBOutlet UILabel *lbPatient;
@property (weak, nonatomic) IBOutlet UILabel *lbFlag;
@property (weak, nonatomic) IBOutlet UIImageView *ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lbDoctorName;
@property (weak, nonatomic) IBOutlet UILabel *lbHospital;
@property (weak, nonatomic) IBOutlet UILabel *lbDepartment;
@property (weak, nonatomic) IBOutlet UILabel *lbDomain;
@property (weak, nonatomic) IBOutlet TQStarRatingView *starView;

@end
