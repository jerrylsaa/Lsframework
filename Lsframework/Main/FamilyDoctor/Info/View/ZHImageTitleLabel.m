//
//  ZHImageTitleLabel.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHImageTitleLabel.h"
#import "JMFoundation.h"

@interface ZHImageTitleLabel (){
    UIImageView* _leftImage;
//    UILabel* _titleLabel;
}

@end

@implementation ZHImageTitleLabel

-(instancetype)init{
    self= [super init];
    if(self){
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _leftImage = [UIImageView new];
    [self addSubview:_leftImage];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = UIColorFromRGB(0x999999);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    
    _leftImage.sd_layout.topEqualToView(self).heightRatioToView(self,1).leftEqualToView(self).widthEqualToHeight();
    
    _titleLabel.sd_layout.leftSpaceToView(_leftImage,5).maxWidthIs(100).bottomEqualToView(self).heightIs(30);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _leftImage.image = [UIImage imageNamed:self.imageName];
    
    if(self.unit.length==0){
        self.unit = @"";
    }
    NSString* title = [NSString stringWithFormat:@"%@ %@%@",self.title,self.content,self.unit];
    _titleLabel.text = title;
    
    CGFloat width = [JMFoundation calLabelWidth:_titleLabel.font andStr:_titleLabel.text withHeight:30];
    CGFloat height = [JMFoundation calLabelHeight:_titleLabel.font andStr:_titleLabel.text withWidth:width];

    _titleLabel.sd_layout.widthIs(width);
    _titleLabel.sd_layout.heightIs(height);
    
//    [self setupAutoWidthWithRightView:_titleLabel rightMargin:0];
    
//    _leftImage.backgroundColor = [UIColor blueColor];
//    self.backgroundColor = [UIColor greenColor];
//    _titleLabel.backgroundColor = [UIColor redColor];
}


@end
