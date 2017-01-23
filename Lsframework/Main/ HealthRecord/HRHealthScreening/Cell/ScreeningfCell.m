//
//  ScreeningfCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//


#import "ScreeningfCell.h"
#import "JMFoundation.h"


@interface ScreeningfCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ScreeningfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews{
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_contentLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
   
}

- (void)setModel:(SCellModel *)model{
    _model = model;
    _titleLabel.text = _model.title;
    _contentLabel.text = _model.text;
    
    CGFloat width = [JMFoundation calLabelWidth:[UIFont systemFontOfSize:16] andStr:_model.title withHeight:20];
    if (width <= 80) {
        width = 80;
    }
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).heightIs(20).widthIs(width);
    
    _contentLabel.sd_layout.leftSpaceToView(_titleLabel,10).topEqualToView(_titleLabel).rightSpaceToView(self.contentView,20).autoHeightRatio(0).minHeightIs(20);
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:10];
}

@end
