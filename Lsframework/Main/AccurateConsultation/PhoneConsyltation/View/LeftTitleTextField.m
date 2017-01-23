//
//  LeftTitleTextField.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "LeftTitleTextField.h"
#import "JMFoundation.h"

@interface LeftTitleTextField (){
    UILabel* titleLabel;
}

@end

@implementation LeftTitleTextField

-(instancetype)init{
    self= [super init];
    if(self){
        
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews{
    //左边标题
    titleLabel = [UILabel new];
    self.leftViewMode=UITextFieldViewModeAlways;
    self.leftView = titleLabel;
    

}

-(void)setTitle:(NSString *)title{
    _title = title ;
    titleLabel.text = title;
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    titleLabel.textColor = titleColor;
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    titleLabel.font = titleFont;
}


-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGFloat width = [JMFoundation calLabelWidth:self.font andStr:self.title withHeight:self.height];
    return CGRectMake(0, 0, width, self.height);
}

@end
