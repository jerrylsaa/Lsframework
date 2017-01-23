//
//  ZHCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHCollectionViewCell.h"
#import "ApiMacro.h"

#define AC_FONT_MINI [UIFont systemFontOfSize:(kScreenWidth == 320 ? 12 : 14)]

@implementation ZHCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _headImageView = [UIImageView new];
    [self addSubview:_headImageView];
    _headImageView.image = [UIImage imageNamed:@"HomeAvater"];
    _headImageView.sd_layout.leftSpaceToView(self,10).rightSpaceToView(self,10).topSpaceToView(self,0).bottomSpaceToView(self,20);
    _headImageView.clipsToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.height/2;
    
    _nameLabel = [UILabel new];
    [self addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:12];
     _nameLabel.sd_layout.leftSpaceToView(self,10).topSpaceToView(_headImageView,0).rightSpaceToView(self,30).heightIs(20);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _selectImageView = [UIImageView new];
    [self addSubview:_selectImageView];
    _selectImageView.sd_layout.rightSpaceToView(self,10).topSpaceToView(_headImageView,0).widthIs(20).heightIs(20);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _headImageView.sd_layout.leftSpaceToView(self,10).rightSpaceToView(self,10).topSpaceToView(self,0).bottomSpaceToView(self,20);
    
}

- (void)setIsAdd:(BOOL)isAdd{
    _isAdd = isAdd;
    if (_isAdd == YES) {
        _selectImageView.image = [UIImage imageNamed:@"remeberpsw_sel"];
    }else{
        _selectImageView.image =[UIImage imageNamed:@"remeberpsw_nor"];
    }
}

- (void)setCellType:(CellType)cellType{
    _cellType = cellType;
    if (self.cellType == CellTypeBaby) {
        _nameLabel.sd_layout.leftSpaceToView(self,10).topSpaceToView(_headImageView,0).rightSpaceToView(self,30).heightIs(20);
        [_nameLabel updateLayout];
        _selectImageView.sd_layout.rightSpaceToView(self,10).topSpaceToView(_headImageView,0).widthIs(20).heightIs(20);
        _headImageView.image = nil;
//        _headImageView.image = [UIImage imageNamed:@"HomeAvater"];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 40;
        _nameLabel.text = self.entity.childName;
        _nameLabel.textColor = [UIColor blackColor];
        _selectImageView.hidden = NO;
        _selectImageView.image = [UIImage imageNamed:@"remeberpsw_nor"];
    }else{
        _nameLabel.sd_layout.leftSpaceToView(self,10).rightSpaceToView(self,10).topSpaceToView(_headImageView,0).heightIs(20);
        [_nameLabel updateLayout];
        _headImageView.image = nil;
        _headImageView.image = [UIImage imageNamed:@"FCAddNewBaby"];
        _nameLabel.text = @"添加新宝贝";
        _nameLabel.font = AC_FONT_MINI;
        _nameLabel.textColor = UIColorFromRGB(0x71CBEE);
        _selectImageView.hidden = YES;
    }
}

- (void)setEntity:(ChildEntity *)entity{
    _entity = entity;
    if (self.cellType == CellTypeBaby) {
        _nameLabel.text = _entity.childName;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];

        
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_DOMAIN,_entity.child_Img]] placeholderImage:[UIImage imageNamed:@"doctor_icon"]];
        
      }else{
        _nameLabel.text = @"添加新宝贝";
          _nameLabel.font = AC_FONT_MINI;
          _nameLabel.textColor = UIColorFromRGB(0x71CBEE);
    }
}
@end
