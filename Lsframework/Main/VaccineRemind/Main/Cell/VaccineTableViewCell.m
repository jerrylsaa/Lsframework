//
//  VaccineTableViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "VaccineTableViewCell.h"

@interface VaccineTableViewCell (){
    UIView* container;
    
    UILabel* headerTitle;
    
    UIImageView* vaccineTypeImageView;
    UILabel* vaccineNameLabel;
    UIImageView* indactorImageView;
    
    UIView* bottomView;
    UIView* topView;
    
    UIView* mustBottomView;
}

@end

@implementation VaccineTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = NO;
        self.layer.cornerRadius = 10;
        
        
        container = [UIView new];
        [self.contentView addSubview:container];
        
        bottomView = [UIView new];
        bottomView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:bottomView];

        mustBottomView = [UIView new];
        mustBottomView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:mustBottomView];

        
        topView = [UIView new];
        topView.backgroundColor = UIColorFromRGB(0xffffff);
        [container addSubview:topView];

        
        vaccineTypeImageView = [UIImageView new];
        vaccineTypeImageView.userInteractionEnabled = YES;
        [container addSubview:vaccineTypeImageView];
        
        indactorImageView = [UIImageView new];
        indactorImageView.userInteractionEnabled = YES;
        indactorImageView.image = [UIImage imageNamed:@"Vaccine_jrxq"];
        [container addSubview:indactorImageView];

        vaccineNameLabel = [UILabel new];
        vaccineNameLabel.textColor = UIColorFromRGB(0x333333);
        vaccineNameLabel.font = [UIFont systemFontOfSize:bigFont];
        [container addSubview:vaccineNameLabel];
        
        
        //添加约束
        container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        topView.sd_layout.topSpaceToView(container,0).leftSpaceToView(container,0).rightSpaceToView(container,0).heightIs(10);
        
        vaccineTypeImageView.sd_layout.topSpaceToView(container,20).leftSpaceToView(container,0).widthIs(10).heightIs(17);
        
        indactorImageView.sd_layout.centerYEqualToView(vaccineTypeImageView).rightSpaceToView(container,80).widthIs(11).heightIs(20);
        
        vaccineNameLabel.sd_layout.topEqualToView(vaccineTypeImageView).leftSpaceToView(vaccineTypeImageView,20).rightSpaceToView(indactorImageView,20).autoHeightRatio(0);
        
        [container setupAutoHeightWithBottomViewsArray:@[vaccineTypeImageView,vaccineNameLabel,indactorImageView] bottomMargin:20];
        
        bottomView.sd_layout.topSpaceToView(container,-10).leftEqualToView(container).rightEqualToView(container).heightIs(10);
//        bottomView.backgroundColor = [UIColor redColor];
        
        mustBottomView.sd_layout.topSpaceToView(container,-10).leftEqualToView(container).rightEqualToView(container).heightIs(10);

        
        
        [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
        
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
    if([[dic objectForKey:@"type"] isEqualToString:@"must"]){
        vaccineTypeImageView.image = [UIImage imageNamed:@"Vaccine_bx"];
    }else if([[dic objectForKey:@"type"] isEqualToString:@"replace"]){
        vaccineTypeImageView.image = [UIImage imageNamed:@"Vaccine_td"];

    }else if([[dic objectForKey:@"type"] isEqualToString:@"select"]){
        vaccineTypeImageView.image = [UIImage imageNamed:@"Vaccine_kx"];

    }
    
    vaccineNameLabel.text = [dic objectForKey:@"name"];
    
    
    
    bottomView.hidden = self.showBottomView;
    
    mustBottomView.hidden = !self.hiddenMustBottomView;
    
    topView.hidden = self.showMustTopView;
    
//    topView.backgroundColor = [UIColor redColor];
    
    
    
}







@end
