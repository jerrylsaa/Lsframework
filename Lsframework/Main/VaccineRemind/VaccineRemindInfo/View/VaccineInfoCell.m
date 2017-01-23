//
//  VaccineInfoCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/10/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccineInfoCell.h"

@interface VaccineInfoCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation VaccineInfoCell

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
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    _titleLabel = [UILabel new];
    _titleLabel.layer.borderWidth = 1.f;
    _titleLabel.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    _titleLabel.textColor = UIColorFromRGB(0x61d8d3);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [UILabel new];
    _detailLabel.textColor = UIColorFromRGB(0x666666);
    _detailLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_detailLabel];
    
}

- (void)setModel:(VaccineDetail *)model{
    _model = model;
    _titleLabel.text = model.titleText;
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,20).widthIs(70).heightIs(20);
    _titleLabel.sd_cornerRadius = @10;
    _detailLabel.text = model.detailText;
    _detailLabel.sd_layout.leftEqualToView(_titleLabel).topSpaceToView(_titleLabel,12).rightSpaceToView(self.contentView,20).autoHeightRatio(0);
    [self setupAutoHeightWithBottomView:_detailLabel bottomMargin:0];
}

@end
