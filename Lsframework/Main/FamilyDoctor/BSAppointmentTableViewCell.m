//
//  BSAppointmentTableViewCell.m
//  doctors
//
//  Created by Shuai on 16/3/27.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "BSAppointmentTableViewCell.h"

@implementation BSAppointmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(FDAppointManagerEntity *)model{
    _model = model;
    
    self.nameLabel.text = model.doctorName;
    self.timeLabel.text = [NSString stringWithFormat:@"预约时间：%@", model.bespeakTime];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
