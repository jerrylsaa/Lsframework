//
//  DiseaseHeaderView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiseaseHeaderView.h"

@interface DiseaseHeaderView ()

@end

@implementation DiseaseHeaderView

-(instancetype)init{
    self= [super init];
    if(self){
        self.backgroundColor=UIColorFromRGB(0xffffff);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray=titleArray;
    
    for(int i=0;i<titleArray.count;++i){
        UILabel* titleLabel=[UILabel new];
        titleLabel.textColor=UIColorFromRGB(0x85d5f1);
        titleLabel.font=[UIFont boldSystemFontOfSize:20];
        titleLabel.text=titleArray[i];
        [self addSubview:titleLabel];
        titleLabel.sd_layout.topSpaceToView(self,15+i*(15+18)).heightIs(18).leftSpaceToView(self,20).maxWidthIs(kScreenWidth);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    }
}


@end
