//
//  SelectButtonImageView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "SelectButtonImageView.h"

@interface SelectButtonImageView (){
    UILabel* _titleLabel;
}

@end

@implementation SelectButtonImageView

-(instancetype)init{
    self= [super init];
    if(self){
        self.userInteractionEnabled=YES;
        UIImage * image = [UIImage imageNamed:@"text_nor"];
        
        self.image = image;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    //标题
    _titleLabel=[UILabel new];
    _titleLabel.font=[UIFont systemFontOfSize:17];
    _titleLabel.textColor=FileFontColor;
    [self addSubview:_titleLabel];
    _titleLabel.sd_layout.topSpaceToView(self,12).heightIs(25).leftSpaceToView(self,25).widthIs(150);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:150];

    _radioGroup=[FBRadioGroup new];
//    _radioGroup.selection = 1;
    [self addSubview:_radioGroup];
    _radioGroup.sd_layout.topEqualToView(_titleLabel).bottomSpaceToView(self,12).leftSpaceToView(_titleLabel,30).maxWidthIs(100);
    __weak SelectButtonImageView* weakSelf = self;
    [_radioGroup setRadioGroupClick:^(NSUInteger index) {
//        weakSelf.image = UIImage imageNamed:
        weakSelf.currentSelect = index+1;
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showBeiZhuWith:)]){
            [weakSelf.delegate showBeiZhuWith:index];
        }
        
    }];
    
}

-(void)setTitle:(NSString *)title{
    _title=title;
    _titleLabel.text=title;
}

-(void)setListArray:(NSArray *)listArray{
    _listArray=listArray;
    _radioGroup.titles=listArray;
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



@end
