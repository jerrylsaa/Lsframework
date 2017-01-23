//
//  MWRechargeCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWRechargeCell.h"

@implementation MWRechargeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIView* container = [UIView new];
    container.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:container];
    _title = [UILabel new];
    _title.font = [UIFont systemFontOfSize:18];
    _title.textColor = UIColorFromRGB(0x808080);
    _title.textAlignment = NSTextAlignmentCenter;
    [container addSubview:_title];
    
    _title.sd_layout.topSpaceToView(container,15).autoHeightRatio(0).leftEqualToView(container).rightEqualToView(container);
    container.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
    [container setupAutoHeightWithBottomView:_title bottomMargin:15];
    
    [self setupAutoHeightWithBottomView:container bottomMargin:0];
}



@end
