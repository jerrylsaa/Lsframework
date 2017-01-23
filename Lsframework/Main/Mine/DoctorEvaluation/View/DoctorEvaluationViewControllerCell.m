//
//  DoctorEvaluationViewControllerCell.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DoctorEvaluationViewControllerCell.h"
#import "UIImageView+WebCache.h"

@implementation DoctorEvaluationViewControllerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
        
    if ([_typeStr isEqualToString:@"0"]) {
        
        _topLineView.backgroundColor = [UIColor colorWithRed:0.4078 green:0.7529 blue:0.8706 alpha:1.0];
        _bottomLineView.backgroundColor = _topLineView.backgroundColor;
        _evaluateTypeLabel.backgroundColor = _topLineView.backgroundColor;
        _evaluateTypeLabel.text = @"未评价";
        _immediateEvaluationBtn.hidden = NO;
        
    }
    
//    _patientAndFollowUp.text = [NSString stringWithFormat:@"患者：%@例    随访：%@例",_patientNum, _FollowUpNum];
 
}

- (void)setModel:(MyDoctorEvaluation *)model {
    
    _model = model;
    
    NSLog(@"%@", model.isEvaluate);
    
    if ([model.isEvaluate isEqualToString:@"未评价"]) {
        
        _topLineView.backgroundColor = [UIColor colorWithRed:0.4078 green:0.7529 blue:0.8706 alpha:1.0];
        _bottomLineView.backgroundColor = _topLineView.backgroundColor;
        _evaluateTypeLabel.backgroundColor = _topLineView.backgroundColor;
        _evaluateTypeLabel.text = @"未评价";
        _immediateEvaluationBtn.hidden = NO;
        
    }
    
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:model.applyTime];
    
//    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
//    NSInteger frominterval = [fromzone secondsFromGMTForDate: myDate];
//    NSDate *myDate = [myDate  dateByAddingTimeInterval: frominterval];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd/hh:mm"];
    NSString *dateString = [dateFormat stringFromDate:myDate];
    NSLog(@"date: %@", dateString);
    self.timeLabel.text = dateString;
    
    self.consultTypeLabel.text = model.askMode;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg]];
    
    self.doctorLevelLabel.text = model.duties;
    
    self.nameLabel.text = model.doctorName;
    
    self.departmentsLabel.text = model.departName;
    
    self.domainLabel.text = model.field;
    self.diseaseLabel.text = [NSString stringWithFormat:@"所患疾病：%@", model.descriptionDisease];
    
    self.patientAndFollowUp.text = [NSString stringWithFormat:@"患者：%ld例    随访：%ld例",model.patientNum, model.followUp];
    self.tqStarRatingView.userInteractionEnabled = NO;
    
    [self.tqStarRatingView setScore:(float)model.starNum withAnimation:YES];
//    self.diseaseLabel.text = 所患疾病
    
    
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
