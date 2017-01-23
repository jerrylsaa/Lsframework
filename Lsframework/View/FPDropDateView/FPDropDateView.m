//
//  FPDropDateView.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPDropDateView.h"
@interface FPDropDateView()

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIImageView* bg;
@property (nonatomic, strong) FPDropDateViewChanged block;
@property (nonatomic, assign) CGFloat height;

@end

@implementation FPDropDateView


-(instancetype)init{
    self = [super init];
    if (self) {
        [self install];
    }
    return self;
}

- (void)install{
    _height = 160;
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, view)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, view)]];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)]];
    self.backgroundColor = [UIColor clearColor];
    UIImage * image = [UIImage imageNamed:@"dropview_bg"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    _bg = imageView;
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    _datePicker.tintColor = [UIColor whiteColor];
    _datePicker.backgroundColor = [UIColor clearColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    for (UIView * subview in _datePicker.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"_UISomePrivateLabelSubclass")]) {
            UILabel * label = (UILabel*)subview;
            label.textColor = [UIColor whiteColor];
        }
    }
    [self addSubview:_datePicker];
    
}

-(void)dateChanged:(id)sender{
    NSDate* date = _datePicker.date;
    NSString * str = [date format2String:@"yyyy-MM-dd"];
    if (_block) {
        _block(str, date);
    }
}

-(void)showInController:(UIViewController *)vc parentView:(UIView *)parentView{
    [vc.view addSubview:self];
    self.frame = vc.view.bounds;
    CGRect parentFrame = [vc.view convertRect:parentView.frame fromView:vc.view];
    CGFloat parentHeight = parentFrame.size.height;
    _datePicker.frame = parentFrame;
    parentFrame.size.height = 0;
    _bg.frame = parentFrame;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = parentFrame;
        frame.size.height  += parentHeight + _height + 10;
        
        _bg.frame = frame;
        frame = parentFrame;
        frame.origin.y += parentHeight;
        frame.origin.x += 5;
        frame.size.width -= 20;
        frame.size.height = _height;
        _datePicker.frame = frame;
        
    } completion:^(BOOL finished) {

    }];
}

-(void)close:(id)sender{
    [self dismiss];
}

-(void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _bg.frame;
        frame.size.height = 0;
        _bg.frame = frame;
        frame = _datePicker.frame;
        frame.size.height = 0;
        _datePicker.frame = frame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)setDateChangedHandler:(FPDropDateViewChanged)block{
    _block = block;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
