//
//  BSCheckProjectCell.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSCheckProjectCell.h"

@implementation BSCheckProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CheckProject *)model {
    
    _model = model;
    
    self.projectID = model.projectID;
    self.nameLabel.text = model.projectName;
}

@end
