//
//  PCHeightCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PCHeightCell.h"
#import "JMFoundation.h"

@interface PCHeightCell ()

@property (nonatomic, strong) UILabel *departLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UILabel *readTitleLabel;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIView *sepView;
@end

@implementation PCHeightCell

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
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    //科室
    _departLabel = [UILabel new];
    _departLabel.font = [UIFont systemFontOfSize:12];
    _departLabel.textColor = UIColorFromRGB(0x61d8d3);
    _departLabel.textAlignment = NSTextAlignmentCenter;
    _departLabel.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    _departLabel.layer.borderWidth = 1.f;
    [self.contentView addSubview:_departLabel];
    _departLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).heightIs(18);
    _departLabel.sd_cornerRadius = @9;
    
    _departLabel.text = @"科室";
    CGFloat wideth = [JMFoundation calLabelWidth:_departLabel.font andStr:_departLabel.text withHeight:18];
    _departLabel.sd_layout.widthIs(wideth + 10);
    
    //时间
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    _timeLabel.sd_layout.centerYEqualToView(_departLabel).widthIs(100).rightSpaceToView(self.contentView,15).heightIs(18);
    
    _timeLabel.text = @"2016-09-25";
    
    
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.sd_layout.leftEqualToView(_departLabel).topSpaceToView(_departLabel,8).rightSpaceToView(self.contentView,15).autoHeightRatio(0);
    
    _titleLabel.text = @"佝偻病";
    
    //详情
    _detailLabel = [UILabel new];
    _detailLabel.textColor = UIColorFromRGB(0x666666);
    _detailLabel.font = [UIFont systemFontOfSize:16];
    _detailLabel.numberOfLines = 0;
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_detailLabel];
    _detailLabel.sd_layout.leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,12).topSpaceToView(_titleLabel,15).autoHeightRatio(0);
    
    _detailLabel.text = @"患免疫缺陷症、接受免疫抑制剂治疗者。3、妊娠期妇女口服后一般无副反应，个别人有发热、恶心、呕吐、腹泻和皮疹。一般不需特殊处理，必要时可对症治疗一般不需特殊处理，必要时可对症治疗一般不需特殊处理，必要时可对症治疗一般不需特殊处理，必要时可对症治疗一般不需特殊处理，必要时可对症治疗。";
    
    //评论
    _commentLabel = [UILabel new];
    _commentLabel.font = [UIFont systemFontOfSize:11];
    _commentLabel.textColor = UIColorFromRGB(0x999999);
    _commentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_commentLabel];
    _commentLabel.sd_layout.rightSpaceToView(self.contentView,15).topSpaceToView(_detailLabel,15).heightIs(18);
    [_commentLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _commentLabel.text = @"100";
    
    //评论ICON
    _commentImageView = [UIImageView new];
    _commentImageView.image = [UIImage imageNamed:@"circle_pl_icon"];
    [self.contentView addSubview:_commentImageView];
    _commentImageView.sd_layout.rightSpaceToView(_commentLabel,10).topSpaceToView(_detailLabel,18).widthIs(15).heightIs(15);
    
    //看过
    _readLabel = [UILabel new];
    _readLabel.textAlignment = NSTextAlignmentCenter;
    _readLabel.font = _commentLabel.font;
    _readLabel.textColor = _commentLabel.textColor;
    [self.contentView addSubview:_readLabel];
    _readLabel.sd_layout.rightSpaceToView(_commentImageView,15).heightRatioToView(_commentLabel,1).centerYEqualToView(_commentLabel);
    
    _readLabel.text = @"100";
    CGFloat readWidth = [JMFoundation calLabelWidth:_readLabel.font andStr:_readLabel.text withHeight:18];
    if (readWidth < 20) {
        readWidth = 20;
    }
    _readLabel.sd_layout.widthIs(readWidth);
    
    //“看过”
    _readTitleLabel = [UILabel new];
    _readTitleLabel.font = _readLabel.font;
    _readTitleLabel.textColor = _readLabel.textColor;
    _readLabel.textAlignment = NSTextAlignmentRight;
    _readTitleLabel.text = @"看过";
    [self.contentView addSubview:_readTitleLabel];
    _readTitleLabel.sd_layout.rightSpaceToView(_readLabel,5).centerYEqualToView(_readLabel).heightRatioToView(_readLabel,1).widthIs(30);
    
    //分割线
    _sepView = [UIView new];
    _sepView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:_sepView];
    _sepView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView(_commentImageView,15).heightIs(2);
}

@end
