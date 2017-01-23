//
//  DiseaseCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DiseaseCollectionViewCell.h"

@implementation DiseaseCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.userInteractionEnabled=YES;
        [self.contentView addSubview:_imageView];
    }
    return self ;
}


@end
