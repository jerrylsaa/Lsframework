//
//  MyBindDoctorCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyBindDoctorCell.h"
@interface MyBindDoctorCell (){
    UIView *_containerView;
    
    UIImageView *_doctorIcon;
    UILabel *_nameLabel;
    UILabel *_titleLabel;
    UILabel *_depaLabel;
    UILabel *_hospitalLabel;
    
    UIButton *_cancelBindBtn;
    
    UILabel *_introLabel;
    UILabel *_leftCountLabel;
    UILabel *_rightCountLabel;

    
}

@end
@implementation MyBindDoctorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.contentView.backgroundColor =[UIColor whiteColor];
    
    UIView *bgView =[UIView new];
    bgView.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:bgView];

    
    _containerView = [UIView new];
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.cornerRadius = 10;
    _containerView.backgroundColor =[UIColor whiteColor];
    [bgView addSubview:_containerView];
    
    _doctorIcon =[UIImageView new];
    _doctorIcon.layer.masksToBounds = YES;
    _doctorIcon.layer.cornerRadius = 25;
    [_containerView addSubview:_doctorIcon];
    
    _nameLabel =[UILabel new];
    _nameLabel.textColor =UIColorFromRGB(0x333333);
    _nameLabel.font =[UIFont boldSystemFontOfSize:15.0f];
    [_containerView addSubview:_nameLabel];

    _titleLabel =[UILabel new];
    _titleLabel.textColor =UIColorFromRGB(0x999999);
    _titleLabel.font =[UIFont systemFontOfSize:10.0f];
    [_containerView addSubview:_titleLabel];
    
    _depaLabel =[UILabel new];
    _depaLabel.textAlignment =NSTextAlignmentCenter;
    _depaLabel.textColor =UIColorFromRGB(0x999999);
    _depaLabel.font =[UIFont systemFontOfSize:10.0f];
    [_containerView addSubview:_depaLabel];
    
    _hospitalLabel =[UILabel new];
    _hospitalLabel.textColor =UIColorFromRGB(0x999999);
    _hospitalLabel.font =[UIFont systemFontOfSize:10.0f];
    [_containerView addSubview:_hospitalLabel];
    
    _cancelBindBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBindBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    _cancelBindBtn.titleLabel.font =[UIFont systemFontOfSize:14.0f];
    [_cancelBindBtn setTitle:@"取消绑定" forState:UIControlStateNormal];
    [_cancelBindBtn setTitleColor:UIColorFromRGB(0x61d8d3) forState:UIControlStateNormal];
    [_containerView addSubview:_cancelBindBtn];
    
    _introLabel =[UILabel new];
    _introLabel.textColor =UIColorFromRGB(0x999999);
    _introLabel.font =[UIFont systemFontOfSize:12.0f];
    _introLabel.numberOfLines =0;
    [_containerView addSubview:_introLabel];
    
    _leftCountLabel =[UILabel new];
    _leftCountLabel.textColor =UIColorFromRGB(0x999999);
    _leftCountLabel.font =[UIFont systemFontOfSize:12.0f];
    [_containerView addSubview:_leftCountLabel];
    
    _rightCountLabel =[UILabel new];
    _rightCountLabel.textAlignment =NSTextAlignmentRight;
    _rightCountLabel.textColor =UIColorFromRGB(0x999999);
    _rightCountLabel.font =[UIFont systemFontOfSize:12.0f];
    [_containerView addSubview:_rightCountLabel];
    
    
    bgView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    _containerView.sd_layout.topSpaceToView(bgView,5).leftSpaceToView(bgView,5).rightSpaceToView(bgView,5);
    _doctorIcon.sd_layout.topSpaceToView(_containerView,15).leftSpaceToView(_containerView,15).heightIs(50).widthIs(50);
    _nameLabel.sd_layout.leftSpaceToView(_doctorIcon,10).topEqualToView(_doctorIcon).widthIs(120).heightIs(25);
    _titleLabel.sd_layout.leftEqualToView(_nameLabel).topSpaceToView(_nameLabel,0).heightIs(25).widthIs(60);
    _depaLabel.sd_layout.leftSpaceToView(_titleLabel,5).topSpaceToView(_nameLabel,0).heightIs(25).widthIs(100);
    _hospitalLabel.sd_layout.leftSpaceToView(_depaLabel,5).topSpaceToView(_nameLabel,0).heightIs(25).widthIs(100);
    _cancelBindBtn.sd_layout.rightSpaceToView(_containerView,15).centerYEqualToView(_nameLabel).widthIs(80).heightIs(25);
    
    
    _introLabel.sd_layout.topSpaceToView(_doctorIcon,15).leftEqualToView(_doctorIcon).rightSpaceToView(_containerView,15).autoHeightRatio(0);
    _leftCountLabel.sd_layout.topSpaceToView(_introLabel,10).leftEqualToView(_doctorIcon).widthIs(100).heightIs(25);
    _rightCountLabel.sd_layout.topSpaceToView(_introLabel,10).rightSpaceToView(_containerView,15).widthIs(100).heightIs(25);
    [_containerView setupAutoHeightWithBottomViewsArray:@[_leftCountLabel,_rightCountLabel] bottomMargin:10];
    [bgView setupAutoHeightWithBottomView:_containerView bottomMargin:0];
    [self setupAutoHeightWithBottomView:bgView bottomMargin:0];
}

- (void)cancel{
    WS(ws);
    if (ws.delegate && [ws.delegate respondsToSelector:@selector(cancelBindAction:)]) {
        [ws.delegate cancelBindAction:ws.cellEntity];
    }
}

- (void)setCellEntity:(MyBindDoctorEntity *)cellEntity{
    _cellEntity =cellEntity;
    [_doctorIcon sd_setImageWithURL:[NSURL URLWithString:cellEntity.ImageUrl] placeholderImage:[UIImage  imageNamed:@"doctor_defaul"]];
    _nameLabel.text =cellEntity.DoctorName;
    _titleLabel.text =cellEntity.DoctorTitle;
    _depaLabel.text =cellEntity.DepartName;
    _hospitalLabel.text =cellEntity.HospitalName;
    _introLabel.text =[NSString stringWithFormat:@"简介:%@",cellEntity.Introduce];
    _leftCountLabel.text =[NSString stringWithFormat:@"收到提问 %@",cellEntity.ConsultationCount];
    _rightCountLabel.text =[NSString stringWithFormat:@"已回答 %@",cellEntity.AnswerCount];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
