//
//  JMMessageCell.m
//  FamilyPlatForm
//
//  Created by 梁继明 on 16/6/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "JMMessageCell.h"

@implementation JMMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.docDepLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
