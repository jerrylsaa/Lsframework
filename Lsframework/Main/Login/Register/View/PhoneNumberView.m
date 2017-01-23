//
//  PhoneNumberView.m
//  FamilyPlatForm
//
//  Created by MAC on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "PhoneNumberView.h"

@implementation PhoneNumberView

- (instancetype)init{
    self= [super init];
    if(self){
        self.userInteractionEnabled = YES;
        self.image = [self stretchableImageWithImageName:@"textfield_nor"];
        self.clipsToBounds = YES;
        [self setupView]; 
    }
    return self;
}

- (void)setupView{
    //图标
    _icon = [UIImageView new];
    //输入框
    _texfield = [UITextField new];

    _texfield.placeholder = @"手机号";
    _texfield.font = [UIFont systemFontOfSize:kScreenWidth == 320 ? 14 : 18];
    _texfield.backgroundColor = [UIColor clearColor];
    _texfield.textColor = UIColorFromRGB(0xffffff);
    _texfield.delegate = self;
    //发送验证码按钮
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeButton.clipsToBounds = YES;
    [_codeButton setBackgroundImage:[self stretchableImageWithImageName:@"code_nor"] forState:UIControlStateNormal];
    [_codeButton setBackgroundImage:[self stretchableImageWithImageName:@"code_hightlight"] forState:UIControlStateSelected];
    [_codeButton setBackgroundImage:[self stretchableImageWithImageName:@"code_sel"] forState:UIControlStateHighlighted];
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton setTitle:@"已发送" forState:UIControlStateSelected];
    [_codeButton setFont:[UIFont systemFontOfSize:kScreenWidth == 320 ? 12 : 14]];
    [self addSubview:_icon];
    [self addSubview:_texfield];
    [self addSubview:_codeButton];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.height/2;
    _icon.sd_layout.leftSpaceToView(self,25).topSpaceToView(self,7.5f).widthIs(25).heightIs(25);
    if (_isCode == NO) {
        _icon.image = [UIImage imageNamed:@"psw"];
        _texfield.secureTextEntry = YES;
        if (_codeButton.superview) {
            [_codeButton removeFromSuperview];
        }
        _texfield.sd_layout.leftSpaceToView(_icon,5).rightSpaceToView(self,25).heightIs(40);
    }else{
        if (!_codeButton.superview) {
            [self addSubview:_codeButton];
        }
        _icon.image = [UIImage imageNamed:@"account"];
        _codeButton.sd_layout.topSpaceToView(self,0).rightSpaceToView(self,0).widthIs(118).heightIs(40);
        _texfield.sd_layout.leftSpaceToView(_icon,5).rightSpaceToView(_codeButton,0).heightIs(40);
        _codeButton.layer.cornerRadius = _codeButton.height/2;
    }

}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
        self.image = [self stretchableImageWithImageName:@"textfield_sel"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
        self.image = [self stretchableImageWithImageName:@"textfield_nor"];
}

- (UIImage *)stretchableImageWithImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect myImageRect = CGRectMake(image.size.width/2 - 1, image.size.height/2 -1 , 3, 3);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size = CGSizeMake(myImageRect.size.width, myImageRect.size.height);
    UIGraphicsBeginImageContext (size);
    CGContextRef context = UIGraphicsGetCurrentContext ();
    CGContextDrawImage (context, myImageRect, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage :subImageRef];
    UIGraphicsEndImageContext ();
    image = [newImage stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    return image;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _texfield.placeholder = placeholder;
    [_texfield setValue:UIColorFromRGB(0xffffff) forKeyPath:@"_placeholderLabel.textColor"];
}

@end
