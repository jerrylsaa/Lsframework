//
//  HHealthServiceCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/10/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HHealthServiceCell.h"

@interface HHealthServiceCell (){
    UIView* container;
    UIImageView* serviceImageView;
    UILabel* packageNameLabel;
    UILabel* packageContentLabel;
    UILabel* priceLabel;
    UIView* bottomLine;
}

@end

@implementation HHealthServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        
        container = [UIView new];
        [self.contentView addSubview:container];
        
        serviceImageView = [UIImageView new];
        serviceImageView.userInteractionEnabled = YES;
        [container addSubview:serviceImageView];

        packageNameLabel = [UILabel new];
        packageNameLabel.textColor = UIColorFromRGB(0x333333);
        packageNameLabel.font = [UIFont systemFontOfSize:16];
        [container addSubview:packageNameLabel];
        
        packageContentLabel = [UILabel new];
        packageContentLabel.textColor = UIColorFromRGB(0x767676);
        packageContentLabel.numberOfLines =0;
        packageContentLabel.font = [UIFont systemFontOfSize:12];
        [container addSubview:packageContentLabel];

        priceLabel = [UILabel new];
        priceLabel.textColor = UIColorFromRGB(0x61d8d3);
        priceLabel.font = [UIFont systemFontOfSize:15];
        [container addSubview:priceLabel];

        bottomLine = [UIView new];
        bottomLine.backgroundColor = UIColorFromRGB(0xd9d9d9);
        [container addSubview:bottomLine];
        
        
        //添加约束
        container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        serviceImageView.sd_layout.topSpaceToView(container,15).leftSpaceToView(container,15).widthIs(100).heightIs(80);
        serviceImageView.sd_cornerRadius = @2.5;
        packageNameLabel.sd_layout.topSpaceToView(container,20).leftSpaceToView(serviceImageView,15).rightSpaceToView(container,15).autoHeightRatio(0);
        packageContentLabel.sd_layout.topSpaceToView(packageNameLabel,5).leftSpaceToView(serviceImageView,15).rightSpaceToView(container,15).autoHeightRatio(0);
        if (CGRectGetMaxY(serviceImageView.frame)>=CGRectGetMaxY(packageContentLabel.frame)) {
            priceLabel.sd_layout.leftEqualToView(packageNameLabel).rightEqualToView(packageNameLabel).topSpaceToView(packageContentLabel,10).heightIs(15);
            
        }else{
            priceLabel.sd_layout.leftEqualToView(serviceImageView).rightEqualToView(packageNameLabel).topSpaceToView(serviceImageView,10).heightIs(15);
        }
        
        if (CGRectGetMaxY(priceLabel.frame)>=CGRectGetMaxY(packageContentLabel.frame)) {
            bottomLine.sd_layout.topSpaceToView(priceLabel,15).leftSpaceToView(container,15).rightSpaceToView(container,15).heightIs(1);
        }else{
            
            bottomLine.sd_layout.topSpaceToView(packageContentLabel,15).leftSpaceToView(container,15).rightSpaceToView(container,15).heightIs(1);
        }
        
        
        
        [container setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
        
        [self setupAutoHeightWithBottomView:container bottomMargin:0];
        
        
    }
    return self;
    
}

-(void)setHealthServiceProduct:(HealthServiceProduct *)healthServiceProduct{
    _healthServiceProduct =healthServiceProduct;
    
    [serviceImageView sd_setImageWithURL:[NSURL URLWithString:healthServiceProduct.MAIN_PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    packageNameLabel.text =healthServiceProduct.NAME;
    packageContentLabel.text =healthServiceProduct.DESCRIPTION;
    priceLabel.text =[NSString stringWithFormat:@"¥%ld",[healthServiceProduct.PRICE longValue]];
}



@end
