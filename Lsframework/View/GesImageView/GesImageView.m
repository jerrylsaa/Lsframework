//
//  GesImageView.m
//  FamilyPlatForm
//
//  Created by MAC on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "GesImageView.h"

@implementation GesImageView

- (instancetype )init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews{

    [self setupTitleView];
    [self setupSelectGroup];
    [self setupTextField];
    
}
- (void)setupTitleView{
    _titleLabel = [UILabel new];
    _titleLabel.textColor = FileFontColor;
    [self addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self,25).topSpaceToView(self,8).widthIs(100).heightIs(25);
}
- (void)setupSelectGroup{
    _selectGroup = [FBRadioGroup new];
    _selectGroup.titles = @[@" 无",@" 有"];
//    _selectGroup.selection = 0;
    [self addSubview:_selectGroup];
    _selectGroup.sd_layout.leftSpaceToView(self,130).topSpaceToView(self,8).bottomSpaceToView(self,8).widthIs(50);
    __weak __typeof(self)weakSelf = self;
    [_selectGroup setRadioGroupClick:^(NSUInteger index) {
        weakSelf.currentSelect = index;
        if (index == 0) {
            [weakSelf hideText];
        }else{
            [weakSelf showText];
        }
    }];
}
- (void)setupTextField{
    
        _textFieldBackground = [UIImageView new];
        _textFieldBackground.userInteractionEnabled = YES;
        [self addSubview:_textFieldBackground];
        _textFieldBackground.sd_layout.leftSpaceToView(_selectGroup,10).bottomSpaceToView(self,5).rightSpaceToView(self,25).heightIs(25);
        _textFieldBackground.image = [self stretchableImageWithImageName:@"text_nor"];
        _textFieldBackground.layer.cornerRadius = _textFieldBackground.height/2;
        _textFieldBackground.clipsToBounds = YES;
        
        _textField = [UITextField new];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.placeholder = @"注明";
        _textField.textAlignment=NSTextAlignmentCenter;
    _textField.textColor=FileFontColor;
    [_textField setValue:FileFontColor forKeyPath:@"_placeholderLabel.textColor"];

        [_textFieldBackground addSubview:_textField];
        _textField.sd_layout.leftSpaceToView(_textFieldBackground,5).rightSpaceToView(_textFieldBackground,5).heightIs(25);
        _textFieldBackground.alpha = 0;
        _textField.alpha = 0;
}
- (void)showText{
    if (_textFieldBackground.alpha == 0) {
        [UIView animateWithDuration:.25f animations:^{
            _textField.alpha = 1;
            _textFieldBackground.alpha = 1;
            [_textField becomeFirstResponder];
        }];
    }
}
- (void)hideText{
    if (_textFieldBackground.alpha != 0) {
        _textField.text = nil;
        [UIView animateWithDuration:.25f animations:^{
            _textField.alpha = 0;
            _textFieldBackground.alpha = 0;
            [_textField resignFirstResponder];
        }];
    }
}


- (UIImage *)stretchableImageWithImageName:(NSString *)imageName{
    //裁减拉伸图片
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
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.image) {
        self.image = [self stretchableImageWithImageName:@"text_sel"];
    }
    _textFieldBackground.image = [self stretchableImageWithImageName:@"text_sel"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.image) {
        self.image = [self stretchableImageWithImageName:@"text_nor"];
    }
    _textFieldBackground.image = [self stretchableImageWithImageName:@"text_nor"];
}

@end
