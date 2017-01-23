//
//  ZHLeftViewTextField.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHLeftViewTextField.h"

@interface ZHLeftViewTextField (){
    UILabel* leftLabel;
}

@end

@implementation ZHLeftViewTextField

-(instancetype)init{
    self= [super init];
    if(self){
        [self setupSubViews];
        
        self.textColor = UIColorFromRGB(0x666666);
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
    return CGRectMake(0, 0, 100, 20);
}

-(void)setTitle:(NSString *)title{
    _title=title;
    leftLabel.text=title;
}



@end
