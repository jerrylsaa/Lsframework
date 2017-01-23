//
//  CooperationHospitalListViewCell.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CooperationHospitalListViewCell.h"

@implementation CooperationHospitalListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HospitalList *)model {
    
    _model = model;
    
    self.hospitalName.text = model.hName;
    self.keyID = model.keyID;
    
}

@end
