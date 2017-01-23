//
//  DietAnalysisCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/17.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DietAnalysisCell.h"
@interface DietAnalysisCell(){
    
    UIView *_containerView;
    UIImageView *_foodIV;
    UILabel *_foodNameLabel;
    UILabel *_analysisTipLabel;
    UILabel *_analysisContentLabel;
    UILabel *_useTipLabel;
    UILabel *_useContentLabel;
    UILabel *_iLL_MATCHEDTip;
    UILabel *_iLL_MATCHEDLabel;
    UIImageView *_bottomView;
    
}
@end
@implementation DietAnalysisCell

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
    
    _foodNameLabel =[UILabel new];
    _foodNameLabel.font =[UIFont systemFontOfSize:14.0f];
    _foodNameLabel.textColor =UIColorFromRGB(0x333333);
    [_containerView addSubview:_foodNameLabel];
    
    _analysisTipLabel =[UILabel new];
    _analysisTipLabel.font =[UIFont systemFontOfSize:14.0f];
    _analysisTipLabel.textColor =UIColorFromRGB(0x333333);
    _analysisTipLabel.text =@"营养成分:";
    [_containerView addSubview:_analysisTipLabel];
    
    _analysisContentLabel =[UILabel new];
    _analysisContentLabel.numberOfLines =0;
    _analysisContentLabel.font =[UIFont systemFontOfSize:14.0f];
    _analysisContentLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_analysisContentLabel];
    
    _useTipLabel =[UILabel new];
    _useTipLabel.font =[UIFont systemFontOfSize:14.0f];
    _useTipLabel.textColor =UIColorFromRGB(0x333333);
    _useTipLabel.text =@"宝宝能吃吗";
    [_containerView addSubview:_useTipLabel];
    
    _useContentLabel =[UILabel new];
    _useContentLabel.numberOfLines =0;
    _useContentLabel.font =[UIFont systemFontOfSize:14.0f];
    _useContentLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_useContentLabel];
    
    _iLL_MATCHEDTip =[UILabel new];
    _iLL_MATCHEDTip.font =[UIFont systemFontOfSize:14.0f];
    _iLL_MATCHEDTip.textColor =UIColorFromRGB(0x333333);
    _iLL_MATCHEDTip.text =@"食物相克";
    [_containerView addSubview:_iLL_MATCHEDTip];
    
    _iLL_MATCHEDLabel =[UILabel new];
    _iLL_MATCHEDLabel.numberOfLines =0;
    _iLL_MATCHEDLabel.font =[UIFont systemFontOfSize:14.0f];
    _iLL_MATCHEDLabel.textColor =UIColorFromRGB(0x666666);
    [_containerView addSubview:_iLL_MATCHEDLabel];
    
    _bottomView =[UIImageView new];
    _bottomView.backgroundColor =UIColorFromRGB(0xf2f2f2);
    [_containerView addSubview:_bottomView];
    
    _containerView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
    _foodIV.sd_layout.topSpaceToView(_containerView,5).leftSpaceToView(_containerView,5).widthIs(60).heightIs(60);
    _foodNameLabel.sd_layout.centerYEqualToView(_foodIV).leftSpaceToView(_foodIV,15).heightIs(25).widthIs(150);
    
    _analysisTipLabel.sd_layout.topSpaceToView(_foodIV,10).leftSpaceToView(_containerView,10).widthIs(150).autoHeightRatio(0);
    _analysisContentLabel.sd_layout.topSpaceToView(_analysisTipLabel,5).leftSpaceToView(_containerView,10).rightSpaceToView(_containerView,10).autoHeightRatio(0);
    _useTipLabel.sd_layout.topSpaceToView(_analysisContentLabel,10).leftSpaceToView(_containerView,10).widthIs(150).autoHeightRatio(0);
    _useContentLabel.sd_layout.topSpaceToView(_useTipLabel,5).leftSpaceToView(_containerView,10).rightSpaceToView(_containerView,10).autoHeightRatio(0);
    _iLL_MATCHEDTip.sd_layout.topSpaceToView(_useContentLabel,10).leftSpaceToView(_containerView,10).widthIs(150).autoHeightRatio(0);
    _iLL_MATCHEDLabel.sd_layout.topSpaceToView(_iLL_MATCHEDTip,5).leftSpaceToView(_containerView,10).rightSpaceToView(_containerView,10).autoHeightRatio(0);
    _bottomView.sd_layout.topSpaceToView(_iLL_MATCHEDLabel,10).leftSpaceToView(_containerView,0).rightSpaceToView(_containerView,0).heightIs(20);
    [_containerView setupAutoHeightWithBottomView:_bottomView bottomMargin:0];
    [self setupAutoHeightWithBottomView:_containerView bottomMargin:0];
}
- (void)setDietAnalysis:(DMMyDietAnalysisEntity *)dietAnalysis{
    
    _dietAnalysis =dietAnalysis;
    
    [_foodIV sd_setImageWithURL:[NSURL URLWithString:dietAnalysis.PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    _foodNameLabel.text =dietAnalysis.NAME;
    _analysisContentLabel.text =dietAnalysis.ANALYSIS;
    _useContentLabel.text =dietAnalysis.RELATION_GROUP;
    _iLL_MATCHEDLabel.text =dietAnalysis.ILL_MATCHED;

    if (_illMatched==nil||[_illMatched isEqualToString:@""]||_illMatched.length ==0) {
        _iLL_MATCHEDTip.hidden =YES;
        _iLL_MATCHEDLabel.hidden =YES;
        
    }

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
