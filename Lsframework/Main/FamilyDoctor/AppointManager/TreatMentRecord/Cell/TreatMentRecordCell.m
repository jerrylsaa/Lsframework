//
//  TreatMentRecordCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "TreatMentRecordCell.h"

@interface TreatMentRecordCell (){
    UILabel* _nameLabel;
    UILabel* _professionalLabel;
    UILabel* _departLabel;
    UILabel* _timeLabel;
    UILabel* _wayLabel;//方式
    
    UILabel* _treatSuccessLabel;//就诊成功
}

@end


@implementation TreatMentRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}



- (void)setupSubviews{
    UIView* containerView = [UIView new];
    [self.contentView addSubview:containerView];
    UIFont* nameFont = kScreenWidth == 320? [UIFont systemFontOfSize:14]: [UIFont systemFontOfSize:18];

    //姓名
    _nameLabel = [UILabel new];
    _nameLabel.textColor = UIColorFromRGB(0x333333);
    _nameLabel.font = nameFont;
    [containerView addSubview:_nameLabel];
    //职称
    _professionalLabel = [UILabel new];
    _professionalLabel.textColor = _nameLabel.textColor;
    _professionalLabel.font = _nameLabel.font;
    [containerView addSubview:_professionalLabel];
    //科室
    _departLabel = [UILabel new];
    _departLabel.textColor = _nameLabel.textColor;
    _departLabel.font = _nameLabel.font;
    [containerView addSubview:_departLabel];
    
    UIFont* timeFont = kScreenWidth == 320? [UIFont systemFontOfSize:12]: [UIFont systemFontOfSize:15];

    //时间
    _timeLabel = [UILabel new];
    _timeLabel.textColor = UIColorFromRGB(0x666666);
    _timeLabel.font = timeFont;
    [containerView addSubview:_timeLabel];
    //方式
    _wayLabel = [UILabel new];
    _wayLabel.textColor = _timeLabel.textColor;
    _wayLabel.font = _timeLabel.font;
    [containerView addSubview:_wayLabel];
    //就诊成功
    _treatSuccessLabel = [UILabel new];
    _treatSuccessLabel.textColor = UIColorFromRGB(0x85d5f1);
    _treatSuccessLabel.font = _timeLabel.font;
    _treatSuccessLabel.textAlignment = NSTextAlignmentRight;
    [containerView addSubview:_treatSuccessLabel];
    
    //添加约束
    _nameLabel.sd_layout.topSpaceToView(containerView,10).leftSpaceToView(containerView,10).autoHeightRatio(0);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _professionalLabel.sd_layout.topEqualToView(_nameLabel).autoHeightRatio(0).leftSpaceToView(_nameLabel,25);
    [_professionalLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _departLabel.sd_layout.topEqualToView(_nameLabel).autoHeightRatio(0).leftSpaceToView(_professionalLabel,25);
    [_departLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _timeLabel.sd_layout.topSpaceToView(_nameLabel,10).leftEqualToView(_nameLabel).autoHeightRatio(0);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _wayLabel.sd_layout.topSpaceToView(_timeLabel,10).leftEqualToView(_nameLabel).autoHeightRatio(0);
    [_wayLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _treatSuccessLabel.sd_layout.centerYEqualToView(_timeLabel).autoHeightRatio(0).rightSpaceToView(containerView,20);
    [_treatSuccessLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    containerView.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    [containerView setupAutoHeightWithBottomView:_wayLabel bottomMargin:10];
    
    [self setupAutoHeightWithBottomView:containerView bottomMargin:0];
    
}

-(void)setRecord:(FDAppointManagerEntity *)record{
    _record = record;
    
    //姓名
    _nameLabel.text = record.userName;
    [_nameLabel updateLayout];
    
    //职称
    _professionalLabel.text = record.profession;
    
    //科室
    _departLabel.text = record.depart;
    
    //时间
    _timeLabel.text = [NSString stringWithFormat:@"时间:%@",record.bespeakTime];
    
    //方式
    if(record.bespeakMode){
    //医生找我－－暂时自己规定－－有待确定
        _wayLabel.text = [NSString stringWithFormat:@"方式：医生找我 %@",record.bespeakAddress];
    }else{
    //我找医生
        _wayLabel.text = [NSString stringWithFormat:@"方式：去找医生 %@",record.bespeakAddress];
    }
    
    //是否成功
    if(record.isAlreadySeeingTheDoctor){
    //报道成功
        _treatSuccessLabel.text = @"报到成功";
        _treatSuccessLabel.textColor = UIColorFromRGB(0x666666);
    }else{
        _treatSuccessLabel.text = @"未就诊";
        _treatSuccessLabel.textColor = UIColorFromRGB(0x85d5f1);
    }

    
}


@end
