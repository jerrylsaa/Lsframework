//
//  PatientCaseCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PatientCaseCell.h"
#import "JMFoundation.h"

@interface PatientCaseCell ()

@property (nonatomic, strong) UILabel *departBgLabel;
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

@implementation PatientCaseCell

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
    
    _departBgLabel = [UILabel new];
    _departBgLabel.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
    _departBgLabel.layer.borderWidth = 1.f;
    [self.contentView addSubview:_departBgLabel];

    
    //科室
    _departLabel = [UILabel new];
    _departLabel.font = [UIFont systemFontOfSize:12];
    _departLabel.textColor = UIColorFromRGB(0x61d8d3);
//    _departLabel.textAlignment = NSTextAlignmentCenter;
//    _departLabel.layer.borderColor = UIColorFromRGB(0x61d8d3).CGColor;
//    _departLabel.layer.borderWidth = 1.f;
    [_departBgLabel addSubview:_departLabel];

    //时间
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    //标题
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    //详情
    _detailLabel = [UILabel new];
    _detailLabel.textColor = UIColorFromRGB(0x666666);
    _detailLabel.font = [UIFont systemFontOfSize:16];
    _detailLabel.numberOfLines = 0;
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_detailLabel];
    
    //评论
    _commentLabel = [UILabel new];
    _commentLabel.font = [UIFont systemFontOfSize:11];
    _commentLabel.textColor = UIColorFromRGB(0x999999);
    _commentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_commentLabel];
    
    //评论ICON
    _commentImageView = [UIImageView new];
    _commentImageView.image = [UIImage imageNamed:@"circle_pl_icon"];
    [self.contentView addSubview:_commentImageView];
    
    //看过
    _readLabel = [UILabel new];
    _readLabel.textAlignment = NSTextAlignmentRight;
    _readLabel.font = _commentLabel.font;
    _readLabel.textColor = _commentLabel.textColor;
    [self.contentView addSubview:_readLabel];
    
    
    //“看过”
//    _readTitleLabel = [UILabel new];
//    _readTitleLabel.font = _readLabel.font;
//    _readTitleLabel.textColor = _readLabel.textColor;
//    _readLabel.textAlignment = NSTextAlignmentRight;
//    _readTitleLabel.text = @"看过";
//    [self.contentView addSubview:_readTitleLabel];
//    _readTitleLabel.sd_layout.rightSpaceToView(_readLabel,5).centerYEqualToView(_readLabel).heightRatioToView(_readLabel,1).widthIs(30);
    
    //分割线
    _sepView = [UIView new];
    _sepView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:_sepView];
    
    //添加约束
    _departBgLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).heightIs(18);
    _departBgLabel.sd_cornerRadius = @9;


    _departLabel.sd_layout.leftSpaceToView(_departBgLabel,3).topSpaceToView(_departBgLabel,1.5).heightIs(15);
//    _departLabel.sd_cornerRadius = @9;
    [_departLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    [_departBgLabel setupAutoWidthWithRightView:_departLabel rightMargin:3];
    
    
    _timeLabel.sd_layout.centerYEqualToView(_departBgLabel).widthIs(100).rightSpaceToView(self.contentView,15).heightIs(18);

    _titleLabel.sd_layout.leftEqualToView(_departBgLabel).topSpaceToView(_departBgLabel,8).rightSpaceToView(self.contentView,15).autoHeightRatio(0);

    _detailLabel.sd_layout.leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,12).topSpaceToView(_titleLabel,15).autoHeightRatio(0).maxHeightIs(65);

    _commentLabel.sd_layout.rightSpaceToView(self.contentView,15).topSpaceToView(_detailLabel,15).heightIs(18);
    [_commentLabel setSingleLineAutoResizeWithMaxWidth:100];

    _commentImageView.sd_layout.rightSpaceToView(_commentLabel,10).topSpaceToView(_detailLabel,18).widthIs(15).heightIs(15);

    _readLabel.sd_layout.rightSpaceToView(_commentImageView,15).heightRatioToView(_commentLabel,1).centerYEqualToView(_commentLabel).leftSpaceToView(self.contentView,15);
    
    _sepView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView(_commentImageView,15).heightIs(2);

    [self setupAutoHeightWithBottomView:_sepView bottomMargin:0];

}

-(void)setPatientCaseEntity:(PatientCaseEntity *)patientCaseEntity{
    _patientCaseEntity = patientCaseEntity;
    
    //科室
    _departLabel.text = patientCaseEntity.departName;
    [_departLabel updateLayout];
    [_departBgLabel updateLayout];
    
    //时间
//    _timeLabel.text = [patientCaseEntity.createTime format2String:@"yyyy-MM-dd"];
    _timeLabel.text = patientCaseEntity.createTime;
    
    //标题
    NSMutableString* caseTitle = [NSMutableString stringWithString:patientCaseEntity.diseaseName];

    if([caseTitle containsString:@"\n"] || [caseTitle containsString:@"\\n"]){
      patientCaseEntity.diseaseName =  [caseTitle stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//    patientCaseEntity.diseaseName =  [caseTitle stringByReplacingOccurrencesOfString:@"\n" withString:@"\n"];

    }
    
    _titleLabel.text = patientCaseEntity.diseaseName;
    
    //详情
    _detailLabel.text = patientCaseEntity.admissionSituation;
    
    //评论
    _commentLabel.text = [NSString stringWithFormat:@"%@",patientCaseEntity.commentCount];
    
    //看过
    
    _readLabel.text = [NSString stringWithFormat:@"看过   %@",patientCaseEntity.click];
    
    _readLabel.hidden = !patientCaseEntity.click;
    


}





@end
