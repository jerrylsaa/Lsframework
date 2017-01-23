//
//  FoodResultCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FoodResultCell.h"
@interface FoodResultCell(){
    
    UIView *_containerView;
    UIImageView *_foodIV;
    UILabel *_resultTipsLabel;
    UILabel *_foodNameLabel;
    UIButton *_selectBtn;
    
}
@end
@implementation FoodResultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self!=nil){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupsubView];
    }
    return self;
}

- (void)setupsubView{
    self.contentView.backgroundColor =[UIColor whiteColor];
    
    _containerView = [UIView new];
    _containerView.backgroundColor =[UIColor whiteColor];
    [self.contentView addSubview:_containerView];
    
    _foodIV =[UIImageView new];
    _foodIV.contentMode =UIViewContentModeScaleAspectFill;
    _foodIV.layer.cornerRadius =5;
    [_foodIV.layer setBorderWidth:0.5];
    [_foodIV.layer setBorderColor:[UIColor clearColor].CGColor];
    _foodIV.clipsToBounds =YES;
    [_containerView addSubview:_foodIV];
    
    _resultTipsLabel =[UILabel new];
    _resultTipsLabel.textColor =UIColorFromRGB(0x666666);
    _resultTipsLabel.font =[UIFont systemFontOfSize:12.0f];
//    _resultTipsLabel.textAlignment =NSTextAlignmentCenter;
    _resultTipsLabel.text =@"您搜索的关键词是:";
    [_containerView addSubview:_resultTipsLabel];
    
    _foodNameLabel =[UILabel new];
    _foodNameLabel.numberOfLines =0;
    _foodNameLabel.font =[UIFont systemFontOfSize:14.0f];
    _foodNameLabel.textColor =UIColorFromRGB(0x61d8d3);
    _foodNameLabel.textAlignment =NSTextAlignmentCenter;
    [_containerView addSubview:_foodNameLabel];
    
    _selectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"searchBtnBG"] forState:UIControlStateNormal];
    [_selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    _selectBtn.titleLabel.font =[UIFont systemFontOfSize:15.0f];
    [_containerView addSubview:_selectBtn];
    
    _containerView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    _foodIV.sd_layout.leftSpaceToView(_containerView,10).centerYEqualToView(_containerView).heightIs(80).widthIs(80);
    _resultTipsLabel.sd_layout.leftSpaceToView(_foodIV,25).topEqualToView(_foodIV).widthIs(150).heightIs(20);
    _selectBtn.sd_layout.rightSpaceToView(_containerView,10).bottomSpaceToView(_containerView,10).widthIs(50).heightIs(35);
    _foodNameLabel.sd_layout.leftSpaceToView(_foodIV,5).topSpaceToView(_resultTipsLabel,5).bottomSpaceToView(_containerView,5).rightSpaceToView(_selectBtn,5);
    
}

- (void)btnAction{
    WS(ws);
    if(ws.delegate && [ws.delegate respondsToSelector:@selector(selectBtn:)]){
        [ws.delegate selectBtn:_foodEntity];
    }
}

- (void)setFoodEntity:(FoodSearchResultEntity *)foodEntity{
    
    _foodEntity =foodEntity;
    
    _foodNameLabel.text =foodEntity.NAME;
    
    [_foodIV sd_setImageWithURL:[NSURL URLWithString:foodEntity.PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
