//
//  MineMenuCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MineMenuCell.h"

@implementation MineMenuCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        self.menuImageView = [UIImageView new];
        self.menuImageView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:self.menuImageView];
        
        self.menuImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        
    }
    return self ;
}




@end
