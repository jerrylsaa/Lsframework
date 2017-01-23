//
//  AppointManagerCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AppointManagerCell.h"

@interface AppointManagerCell (){
    UILabel* _nameLabel;
    UILabel* _professionalLabel;
    UILabel* _departLabel;
    UILabel* _timeLabel;
}

@end

@implementation AppointManagerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    //添加约束
    _nameLabel.sd_layout.topSpaceToView(containerView,10).leftSpaceToView(containerView,10).autoHeightRatio(0);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _professionalLabel.sd_layout.topEqualToView(_nameLabel).autoHeightRatio(0).leftSpaceToView(_nameLabel,25);
    [_professionalLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _departLabel.sd_layout.topEqualToView(_nameLabel).autoHeightRatio(0).leftSpaceToView(_professionalLabel,25);
    [_departLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _timeLabel.sd_layout.topSpaceToView(_nameLabel,5).leftEqualToView(_nameLabel).autoHeightRatio(0);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];

    containerView.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    [containerView setupAutoHeightWithBottomView:_timeLabel bottomMargin:10];
    
}

-(void)setModel:(FDAppointManagerEntity *)model{
    _model = model;
    
    //    self.nameLabel.text = model.doctorName;
    //    self.timeLabel.text = [NSString stringWithFormat:@"预约时间：%@", model.bespeakTime];
    
    _nameLabel.text = model.doctorName;
    [_nameLabel updateLayout];
    
    _professionalLabel.text = model.academicTitle;
    
    _departLabel.text = model.departName;
    
    _timeLabel.text = [NSString stringWithFormat:@"预约时间：%@", model.bespeakTime];
}



@end
