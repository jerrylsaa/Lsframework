//
//  BSHospitalArchivesTableViewCell.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSHospitalArchivesTableViewCell.h"

@implementation BSHospitalArchivesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HospitalFileList *)model {
    _model = model;
    
//    self.hospitalName.text = ？;// 列表标题暂时都是自主上传
    self.dateTime.text = [NSDate showMyDate:model.inspectTime withDateFormatter:@"yyyy年MM月dd日"];
    
    if ([self.myType isEqualToString:@"0"]) {
        
        self.project.text = [NSString stringWithFormat:@"项目：%@", model.projectName];
        
        
    }else if ([self.myType isEqualToString:@"1"]) {
        
        self.project.text = [NSString stringWithFormat:@"主诉：%@", model.chiefComplaint];
        
    }
    
}

@end
