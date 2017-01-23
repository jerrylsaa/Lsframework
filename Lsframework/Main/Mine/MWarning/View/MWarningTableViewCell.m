//
//  MWarningTableViewCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/7/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWarningTableViewCell.h"

@interface MWarningTableViewCell(){
    UIView *_containerView;
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UILabel *_contentLabel;
    UIButton *_detailBtn;
}

@end
@implementation MWarningTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _containerView = [UIView new];
    _containerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_containerView];
    
    _titleLabel =[UILabel new];
    _dateLabel.textAlignment =NSTextAlignmentLeft;
    _titleLabel.font =[UIFont systemFontOfSize:16];
    _titleLabel.textColor =UIColorFromRGB(0x61d8d3);
    [_containerView addSubview:_titleLabel];
    
    _dateLabel =[UILabel new];
    _dateLabel.font =[UIFont systemFontOfSize:12];
    _dateLabel.textAlignment =NSTextAlignmentRight;
    _dateLabel.textColor =UIColorFromRGB(0x999999);
    [_containerView addSubview:_dateLabel];
    
    _contentLabel =[UILabel new];
    _contentLabel.font =[UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines =0;
    _contentLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_contentLabel];
    
    _detailBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:12.0],NSFontAttributeName,
                                   [UIColor colorWithRed:0.898 green:0.2235 blue:0.2078 alpha:1.0],NSForegroundColorAttributeName,nil];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"查看全部" attributes:attributeDict];
    [_detailBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
//    [_detailBtn addTarget:self action:@selector(detailButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_detailBtn];
    
    _containerView.sd_layout.topSpaceToView(self.contentView,5).leftSpaceToView(self.contentView,5).rightSpaceToView(self.contentView,5);
    
    _titleLabel.sd_layout.leftSpaceToView(_containerView,15).topSpaceToView(_containerView,15).widthIs(160).autoHeightRatio(0).maxHeightIs(16.0);
    _dateLabel.sd_layout.rightSpaceToView(_containerView,15).centerYEqualToView(_titleLabel).leftSpaceToView(_titleLabel,10).autoHeightRatio(0).minWidthIs(70).maxHeightIs(12.0);
    _contentLabel.sd_layout.topSpaceToView(_titleLabel,15).leftSpaceToView(_containerView,15).rightSpaceToView(_containerView,15).autoHeightRatio(0).maxHeightIs(14.0 * 10.0).minHeightIs(14.0);
    _detailBtn.sd_layout.topSpaceToView(_contentLabel,15).rightSpaceToView(_containerView,15).autoHeightRatio(0).widthIs(48.0);
    [_containerView setupAutoHeightWithBottomView:_detailBtn bottomMargin:10];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:10];
}

- (void)setMyWarning:(MWarningEntity *)myWarning{
    _myWarning =myWarning;
    _titleLabel.text =myWarning.Title;
    _dateLabel.text =myWarning.CreateTime;
    _contentLabel.text =myWarning.Subject;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
