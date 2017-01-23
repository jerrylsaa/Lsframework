//
//  BookingTimeCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BookingTimeCollectionViewCell.h"

@interface BookingTimeCollectionViewCell ()

@property(nonatomic,strong) ClickItemBlock block;

@end

@implementation BookingTimeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        [self setupSubviews];
    }
    return self ;
}

- (void)setupSubviews{
    _timebt=[UIButton new];
    [_timebt setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [_timebt setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
//    [_timebt setBackgroundImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateDisabled];
    [_timebt addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_timebt];
    
    _timebt.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}


#pragma mark - 点击事件

- (void)clickButtonAction:(UIButton*) bt{
    bt.selected=!bt.selected;
    _block(bt);
}

-(void)clickItemOnComplete:(ClickItemBlock)block{
    _block = [block copy];
}



@end
