//
//  RightViewTextField.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "RightViewTextField.h"

@interface RightViewTextField (){
    UIView* _rightView;
    UIImageView* _rightImageView;
    UIButton* _rightButton;
}

@end

@implementation RightViewTextField

-(instancetype)init{
    self= [super init];
    if(self){
//        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    _rightView = [UIView new];
    self.rightView = _rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    _rightImageView = [UIImageView new];
    _rightImageView.userInteractionEnabled = YES;
    [_rightView addSubview:_rightImageView];
    
    _rightButton = [UIButton new];
    [_rightView addSubview:_rightButton];
    [_rightButton setTitleColor:UIColorFromRGB(0x868686) forState:UIControlStateNormal];
    
    _rightView.frame = CGRectMake(0,0,100,self.height);
    
    _rightImageView.sd_layout.topSpaceToView(_rightView,10).bottomSpaceToView(_rightView,10).leftSpaceToView(_rightView,10).widthEqualToHeight();
    
    _rightButton.sd_layout.leftSpaceToView(_rightImageView,15).rightSpaceToView(_rightView,20).topEqualToView(_rightImageView).bottomEqualToView(_rightImageView);
    
    
//
//    
//    _rightImageView = [UIImageView new];
//    _rightImageView.userInteractionEnabled = YES;
//    [_rightView addSubview:_rightImageView];
//    
//    _rightButton = [UIButton new];
//    [_rightView addSubview:_rightButton];
//    _rightButton.backgroundColor = [UIColor redColor];
//    
//    _rightImageView.sd_layout.topSpaceToView(_rightView,10).bottomSpaceToView(_rightView,10).leftEqualToView(_rightView).widthEqualToHeight();
//    
//    _rightButton.sd_layout.leftSpaceToView(_rightImageView,15).rightEqualToView(_rightView).topEqualToView(_rightImageView).bottomEqualToView(_rightImageView);
//    
//    [_rightView setupAutoWidthWithRightView:_rightButton rightMargin:0];
//
//    NSLog(@"widht =%g－－%@",_rightView.width,NSStringFromCGRect(_rightButton.frame));
//    _rightView.frame = CGRectMake(self.width-100,self.height/2.0-self.font.pointSize/2.0,100,self.height);
//    CGRect rect = _rightView.frame;
//    rect.
//    
//    self.rightView = _rightView;
//    self.rightViewMode = UITextFieldViewModeAlways;
    
}


-(void)setRightImage:(NSString *)rightImage{
    _rightImage = rightImage;
    
    _rightImageView.image = [UIImage imageNamed:rightImage];
}

-(void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
}




/**
 *  <#Description#>
 *
 *  @param rect <#rect description#>
 */
-(void)drawPlaceholderInRect:(CGRect)rect{
    UIColor *placeholderColor = UIColorFromRGB(0x868686);//设置颜色
    [placeholderColor setFill];
    
    CGRect placeholderRect = rect;
    placeholderRect.origin.x += 10;
    placeholderRect.origin.y = (placeholderRect.size.height- self.font.pointSize)/2;
    
    
//    CGRect placeholderRect = CGRectMake(rect.origin.x+10, (rect.size.height- self.font.pointSize)/2, rect.size.width, self.font.pointSize);//设置距离
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = self.textAlignment;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName, self.font, NSFontAttributeName, placeholderColor, NSForegroundColorAttributeName, nil];
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
    
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}



@end
