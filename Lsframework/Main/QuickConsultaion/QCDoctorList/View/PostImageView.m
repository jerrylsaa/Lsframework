//
//  PostImageView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PostImageView.h"

@implementation PostImageView


-(instancetype)init{
    self= [super init];
    if(self){
        self.contentMode=UIViewContentModeScaleAspectFit;
        self.image=[UIImage imageNamed:@"post"];
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _post=[UILabel new];
    _post.font = [UIFont systemFontOfSize:10];
    _post.numberOfLines=0;
    _post.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_post];
    _post.sd_layout.topSpaceToView(self,1).bottomSpaceToView(self,1).leftSpaceToView(self,0).rightSpaceToView(self,0);
//    _post.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

@end
