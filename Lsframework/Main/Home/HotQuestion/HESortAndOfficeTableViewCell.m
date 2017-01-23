//
//  HESortAndOfficeTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HESortAndOfficeTableViewCell.h"

@interface HESortAndOfficeTableViewCell (){
    UIView *_containerView;
    
    
}

@end
@implementation HESortAndOfficeTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _containerView = [UIView new];
    _containerView.backgroundColor = UIColorFromRGB(0xedfffd);
    [self.contentView addSubview:_containerView];
    
    _selectedImageView =[self viewWithTag:1100];
    if (_selectedImageView==nil) {
        _selectedImageView =[UIImageView new];
        _selectedImageView.tag =1100;
        _selectedImageView.image =[UIImage imageNamed:@"selectBackground"];
        [_containerView addSubview:_selectedImageView];
    }
    _contentLabel =[UILabel new];
    _contentLabel.textAlignment =NSTextAlignmentCenter;
    _contentLabel.textColor =UIColorFromRGB(0x61d8d3);
    _contentLabel.font =[UIFont systemFontOfSize:14];
    [_containerView addSubview:_contentLabel];
    
    _containerView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _selectedImageView.sd_layout.topSpaceToView(_containerView,2.5).leftSpaceToView(_containerView,5).rightSpaceToView(_containerView,5).bottomSpaceToView(_containerView,2.5);
    _contentLabel.sd_layout.leftSpaceToView(_containerView,7.5).rightSpaceToView(_containerView,7.5).centerYEqualToView(_containerView).heightIs(14);
}


- (void)setExpertOffice:(ExpertOfficeEntity *)expertOffice{
    _expertOffice =expertOffice;
    _contentLabel.text =expertOffice.DepartName;
    
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected =isSelected;
    if (_isSelected) {
        self.selectedImageView.hidden =NO;
    }else{
        self.selectedImageView.hidden =YES;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
