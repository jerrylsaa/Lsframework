//
//  JMDataCollectionViewCell.m
//  doctors
//
//  Created by 梁继明 on 16/4/2.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import "JMDataCollectionViewCell.h"

@implementation JMDataCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDateModel:(JMDataModel *)dateModel{

    _dateModel = dateModel;
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@",dateModel.dateStr];


}

@end
