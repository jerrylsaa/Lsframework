//
//  MyQuestionCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyQuestionCell.h"

@interface MyQuestionCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *headBackView;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *postLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *listenLabel;


@end

@implementation MyQuestionCell

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
    [self setupTitleLabel];
    [self setupHeadImageView];
    [self setupNameLabel];
    [self setupPostLabel];
    [self setupTimeLabel];
    [self setupListenLabel];
    [self setupSepView];
}

- (void)setupTitleLabel{
    _titleLabel = [UILabel new];
    _titleLabel.textColor = UIColorFromRGB(0x5D5D5D);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
}
- (void)setupHeadImageView{
    
    _headBackView = [UIImageView new];
    _headBackView.image = [UIImage imageNamed:@"HEADoctorIcon"];
    _headBackView.layer.masksToBounds = YES;
    _headBackView.layer.cornerRadius = 22;
    [self.contentView addSubview:_headBackView];
    
    
    _headImageView = [UIImageView new];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    _headImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_headImageView];
}
- (void)setupNameLabel{
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = UIColorFromRGB(0x5D5D5D);
    [self.contentView addSubview:_nameLabel];
}
- (void)setupPostLabel{
    _postLabel = [UILabel new];
    _postLabel.font = [UIFont systemFontOfSize:12];
    _postLabel.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:_postLabel];
}
- (void)setupTimeLabel{
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:_timeLabel];
}

- (void)setupListenLabel{
    _listenLabel = [UILabel new];
    _listenLabel.font = [UIFont systemFontOfSize:12];
    _listenLabel.textColor = UIColorFromRGB(0x999999);
    _listenLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_listenLabel];
}
- (void)setupSepView{
    UIView *sepView = [UIView new];
    sepView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [self.contentView addSubview:sepView];
    sepView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0).heightIs(2);
}


- (void)setMyReply:(MyReply *)myReply{
    _myReply = myReply;
    //赋值
    _titleLabel.text = _myReply.ConsultationContent;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_myReply.ImageUrl] placeholderImage:[UIImage imageNamed:@"doctor_default"]];
    _nameLabel.text = _myReply.DoctorName;
    _postLabel.text = _myReply.Introduce;
//    NSString* myQuestionTime = [NSDate getDateCompare:_myReply.CreateTime];
//    _timeLabel.text = myQuestionTime;
    _timeLabel.text = _myReply.CreateTime;
    _listenLabel.text = [NSString stringWithFormat:@"听过  %@",_myReply.HearCount];
    //布局
    _titleLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,10).autoHeightRatio(0);
    
    _headBackView.sd_layout.leftSpaceToView(self.contentView,8).topSpaceToView(_titleLabel,13).heightIs(44).widthIs(44);
    _headImageView.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(_titleLabel,15).heightIs(40).widthIs(40);
    
    _nameLabel.sd_layout.leftSpaceToView(_headImageView,20).topEqualToView(_headImageView).rightSpaceToView(self.contentView,10).heightIs(20);
    _postLabel.sd_layout.leftEqualToView(_nameLabel).topSpaceToView(_nameLabel,10).rightSpaceToView(self.contentView,10).minHeightIs(18).maxHeightIs(35).autoHeightRatio(0);
    _timeLabel.sd_layout.leftEqualToView(_headImageView).topSpaceToView(_postLabel,10).heightIs(15).widthIs(80);
    _listenLabel.sd_layout.rightSpaceToView(self.contentView,10).topEqualToView(_timeLabel).widthIs(120).heightIs(15);

    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:10];
}


@end
