//
//  FPTextField.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPTextField.h"

@interface FPTextField ()

@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UILabel * rightLabelAnimation;

@end

@implementation FPTextField


-(instancetype)init{
    self = [super init];
    if (self) {
        [self install];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self install];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self install];
    }
    return self;
}

- (void)install{
    _leftPadding = -1;
    _rightPadding = -1;
    _donotChangeBg = NO;
    self.textColor=FileFontColor;
    _normalBackground = [UIImage imageNamed:@"FPtextfield_normal"];
    _normalBackground = [_normalBackground stretchableImageWithLeftCapWidth:_normalBackground.size.width * 0.5 topCapHeight:0];
    self.background = _normalBackground;
    UIImage * image = [UIImage imageNamed:@"FPtextfield_normal"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:0];
    _onFocusBackground = image;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

-(void)textFieldTextDidBeginEditingNotification:(NSNotification*)sender{
    if(_isTextfieldEnbled){
        [self resignFirstResponder];
        return ;
    }
    
    if ([sender.object isEqual:self] && !_donotChangeBg){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notice_textFieldBegin" object:nil];

        self.background = _onFocusBackground;
        if (_rightLabel){
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = [self convertRect:self.rightView.frame fromView:self];
                _rightLabelAnimation.frame = frame;
            } completion:^(BOOL finished) {
                self.rightViewMode = UITextFieldViewModeAlways;
                [_rightLabelAnimation removeFromSuperview];
            }];
        }
    }
}

-(void)textFieldTextDidEndEditingNotification:(NSNotification*)sender{
    if ([sender.object isEqual:self] && !_donotChangeBg){

        self.background = _normalBackground;
        if (_rightLabel) {
            self.rightViewMode = UITextFieldViewModeNever;
            if (!_rightLabelAnimation.superview) {
                [self addSubview:_rightLabelAnimation];
            }
            NSString* text=[self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(!text.length) return ;
            
            if(self.stopAnimation) return ;
            
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = _rightLabelAnimation.frame;
                frame.origin.x =  [self getSize:self.text].width + self.leftView.size.width + 30;
                _rightLabelAnimation.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }}
    
    
}

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    if (_leftPadding == -1){
        iconRect.origin.x += 25;
        iconRect.origin.y -= 1;
    }
    self.rightView.userInteractionEnabled = YES;
    return iconRect;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    if (_rightPadding == -1){
        iconRect.origin.x -= 15;
        iconRect.origin.y -= 1;
    }
    return iconRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super textRectForBounds:bounds];
    if(_textCenter){
        CGFloat space = bounds.size.width/2.0;
        textRect.origin.x = space;
    }
    
    return textRect;
}

-(void)setLeftPadding:(CGFloat)leftPadding{
    _leftPadding = leftPadding;
    UIView * view = [UIView new];
    view.frame = CGRectMake(0, 0, _leftPadding, 0);
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
    
}

-(void)setRightPadding:(CGFloat)leftPadding{
    _rightPadding = leftPadding;
    UIView * view = [UIView new];
    view.frame = CGRectMake(0, 0, _rightPadding, 0);
    self.rightView = view;
    self.rightViewMode = UITextFieldViewModeAlways;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.frame = self.bounds;
        _leftLabel.textColor = self.textColor;
        _leftLabel.font = self.font;
        self.leftView = _leftLabel;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    CGRect frame = _leftLabel.frame;
    frame.size = [self getSize:title];
    frame.size.width += 5;
    _leftLabel.frame = frame;
    _leftLabel.text = title;
}

-(void)setUnit:(NSString *)unit{
    _unit = unit;
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = self.textColor;
        _rightLabel.font = self.font;
        _rightLabelAnimation = [UILabel new];
        _rightLabelAnimation.textColor = self.textColor;
        _rightLabelAnimation.font = self.font;
        self.rightView = _rightLabel;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    CGRect frame = _rightLabel.frame;
    frame.size = [self getSize:unit];
    frame.size.width += 5;
    _rightLabel.frame = frame;
    _rightLabel.text = unit;
    _rightLabelAnimation.frame = frame;
    _rightLabelAnimation.text = unit;
}

-(void)setLeftIcon:(UIImage *)leftIcon{
    UIImageView * imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.image = leftIcon;
    CGRect frame  = CGRectZero;
    frame.size = leftIcon.size;
    frame.size.width += 5;
    imageView.frame = frame;
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setRightIcon:(UIImage *)leftIcon{
    UIImageView * imageView = [UIImageView new];
    imageView.userInteractionEnabled=YES;
    imageView.contentMode = UIViewContentModeRight;
    imageView.image = leftIcon;
    CGRect frame  = CGRectZero;
    frame.size = leftIcon.size;
    frame.size.width += 5;
    imageView.frame = frame;
    self.rightView = imageView;
    self.rightView.userInteractionEnabled=YES;
    self.rightViewMode = UITextFieldViewModeAlways;
    
}

- (void)setIsTextfieldEnbled:(BOOL)isTextfieldEnbled{
    _isTextfieldEnbled=isTextfieldEnbled;
    if(isTextfieldEnbled){
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTapGesture:)];
        [self.rightView addGestureRecognizer:tap];
    }
}

-(CGSize)getSize:(NSString*)text{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}



-(void)setTextColor:(UIColor *)textColor{
    [super setTextColor:textColor];
    _leftLabel.textColor = textColor;
}

-(void)setNormalBackground:(UIImage *)normalBackground{
    _normalBackground = normalBackground;
    self.background = _normalBackground;
}

#pragma mark - 监听手势
- (void)handlerTapGesture:(UITapGestureRecognizer*) tap{
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _rightIcon = nil;
    _rightLabel = nil;
    _leftIcon = nil;
    _leftIcon = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end
