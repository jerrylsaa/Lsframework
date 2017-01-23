//
//  MBSidesSliderCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MBSidesSliderCell.h"

@interface MBSidesSliderCell (){
    UIImageView* _iconbgImageView;
}

@end

@implementation MBSidesSliderCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    [self.contentView addSubview:_icon];
    
    _iconbgImageView = [UIImageView new];
    _iconbgImageView.userInteractionEnabled = YES;
    _iconbgImageView.image = [UIImage imageNamed:@"doctor_flower"];
    [self.contentView addSubview:_iconbgImageView];
    
    _name = [UILabel new];
    _name.font = [UIFont systemFontOfSize:16];
    _name.textColor = UIColorFromRGB(0x535353);
    _name.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_name];
    
    _icon.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightEqualToWidth();
    _iconbgImageView.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightEqualToWidth();
    _name.sd_layout.topSpaceToView(_icon,0).leftEqualToView(self.contentView).rightEqualToView(self.contentView).autoHeightRatio(0);

}




@end
