//
//  ReadingRecordCollectionVCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/7/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ReadingRecordCollectionVCell.h"
@interface ReadingRecordCollectionVCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation ReadingRecordCollectionVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setHealth:(HealthAssessmetnEntity *)health{
    _health = health;
    
    _titleLabel.text = health.examDate;
}
@end
