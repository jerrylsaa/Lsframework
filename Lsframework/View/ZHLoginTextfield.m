//
//  ZHLoginTextfield.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHLoginTextfield.h"



@implementation ZHLoginTextfield

-(instancetype)init{
    self= [super init];
    if(self){
        self.userInteractionEnabled=YES;
        [self setupView];
        
    }
    return self;
}

- (void)setupView{
    //头像
    _iconImage=[UIImageView new];
    _iconImage.userInteractionEnabled=YES;
    
    //textfield
    _tf=[UITextField new];
    _tf.clearButtonMode=UITextFieldViewModeWhileEditing;
    _tf.delegate=self;
    
    [self addSubview:_iconImage];
    [self addSubview:_tf];
    if (![self.tfType isEqualToString:@"Register"]) {
        _iconImage.sd_layout.leftSpaceToView(self,10).topSpaceToView(self,15/2.0).widthIs(25).heightIs(25);
    }else {
        _iconImage.sd_layout.leftSpaceToView(self,10).topSpaceToView(self,15/2.0).widthIs(0).heightIs(0);}
    _tf.sd_layout.leftSpaceToView(_iconImage,15).topEqualToView(_iconImage).heightRatioToView(_iconImage,1).rightSpaceToView(self,0);
    
}

-(void)setIconName:(NSString *)iconName{
    _iconName=iconName;
    _iconImage.image=[UIImage imageNamed:iconName];
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder=placeholder;
    _tf.placeholder=placeholder;
    [_tf setValue:UIColorFromRGB(0xffffff) forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)setPlaceholderColor:(UIColor *)placeholdercolor{
        [_tf setValue:placeholdercolor forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - 代理
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}





@end
