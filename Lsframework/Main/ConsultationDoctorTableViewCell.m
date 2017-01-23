//
//  ConsultationDoctorTableViewCell.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ConsultationDoctorTableViewCell.h"

@implementation ConsultationDoctorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCell:(FamilyDoctorEntity *)entity{
    _lbName.text = entity.userName;
    _lbDepartment.text = entity.departName;
    
}

@end
