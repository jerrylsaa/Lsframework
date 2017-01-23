//
//  DescribeView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "DescribeView.h"

@implementation DescribeView

-(instancetype)init{
    self= [super init];
    if(self){
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _titleLabel=[UILabel new];
    [self addSubview:_titleLabel];
    
    _describeLabel=[UILabel new];
    
    [self addSubview:_describeLabel];
    
    _titleLabel.sd_layout.topSpaceToView(self,0).bottomSpaceToView(self,0).leftSpaceToView(self,0).maxWidthIs(100);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:100];

    
    _describeLabel.sd_layout.topEqualToView(_titleLabel).bottomEqualToView(_titleLabel).leftSpaceToView(_titleLabel,10).maxWidthIs(200);
    [_describeLabel setSingleLineAutoResizeWithMaxWidth:200];

    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text=title;
}

-(void)setDetail:(NSString *)detail{
    _detail = detail;
    _describeLabel.text=detail;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
//    _titleLabel.text=self.title;
    
//    _describeLabel.text=self.detail;
    
//    CGRect frame=self.frame;
//    frame.size.width=_describeLabel.right;
//    self.frame=frame;
}


@end
