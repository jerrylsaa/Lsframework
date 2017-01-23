//
//  PhotoCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        _photoImageView = [UIImageView new];
        _photoImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_photoImageView];
        

        _deleteButton = [UIButton new];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"circle_del_icon1"] forState:UIControlStateNormal];
//        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];
        
        UIButton* button = [UIButton new];
        [button addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        _photoImageView.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).widthRatioToView(self.contentView,1).heightEqualToWidth();
        _deleteButton.sd_layout.topSpaceToView(self.contentView,-8).rightSpaceToView(self.contentView,-8).widthIs(16).heightEqualToWidth();
        button.sd_layout.topSpaceToView(self.contentView,-8).rightSpaceToView(self.contentView,-8).widthIs(35).heightEqualToWidth();
        
//        button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    }
    return self ;
}

#pragma mark - 点击事件
- (void)deleteAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickDeletePhoto:)]){
        [self.delegate clickDeletePhoto:self];
    }
}


@end
