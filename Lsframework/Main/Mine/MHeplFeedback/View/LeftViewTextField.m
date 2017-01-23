//
//  LeftViewTextField.m
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/4/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "LeftViewTextField.h"

@interface LeftViewTextField (){
    UILabel* leftLabel;
}

@end


@implementation LeftViewTextField

-(instancetype)init{
    self= [super init];
    if(self){
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    leftLabel=[UILabel new];
    leftLabel.textColor=UIColorFromRGB(0x666666);
    leftLabel.font=[UIFont systemFontOfSize:20];
    
    self.leftView=leftLabel;
    self.leftViewMode=UITextFieldViewModeAlways;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(20, 15, 100, 20);
}

-(void)setTitle:(NSString *)title{
    _title=title;
    leftLabel.text=title;
}



@end
