//
//  FBRadioGroup.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FBRadioGroup.h"
#import "FPCheckButton.h"

@interface FBRadioGroup()
@property (nonatomic, strong) NSMutableArray<FBRadioGroupClickBlock>* blocks;

@end

@implementation FBRadioGroup


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

-(NSMutableArray *)btns{
    if(!_btns){
        _btns=[NSMutableArray array];
    }
    return _btns;
}


-(void)install{
    _blocks = [NSMutableArray new];
    self.backgroundColor = [UIColor clearColor];
    _selection = -1;
//    _btns = [NSMutableArray new];
    _type = FBRadioGroupTypeVertical;
    _normalImage = [UIImage imageNamed:@"radio_group_normal"];
    _selectedImage = [UIImage imageNamed:@"radio_group_selected"];
    _equalWidth = YES;
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.subviews.count == 0) {
        
        
        UIButton * lastButton;
        for (int i = 0; i < _titles.count; i ++) {
            FPCheckButton * button = [FPCheckButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [button setTitle:_titles[i] forState:UIControlStateNormal];
            [button setImage:_normalImage forState:UIControlStateNormal];
            [button setImage:_selectedImage forState:UIControlStateSelected];
            button.titleEdgeInsets=UIEdgeInsetsMake(0, 8, 0,0);
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btns addObject:button];
            [self addSubview:button];
            if (_type == FBRadioGroupTypeVertical) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, button)]];
                if (lastButton) {
                    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastButton]-[button(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, button, lastButton)]];
                }else{
                    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button(18)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, button)]];
                }
            }else{
                CGFloat width = [button sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)].width;
                NSDictionary *attrs = @{NSFontAttributeName : button.titleLabel.font};
                width = [_titles[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
                width += _normalImage.size.width + 5;
                
                if (_equalWidth) {
                    button.titleCenter = YES;
                    if (lastButton) {
                        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastButton]-(10)-[button(==lastButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, button, lastButton)]];
                    }else{
                        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, button)]];
                    }
                    if (i == _titles.count - 1) {
                        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, button)]];
                    }
                }else{
                    if (lastButton) {
                        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastButton]-(10)-[button(width)]" options:0 metrics:@{@"width":@(width)} views:NSDictionaryOfVariableBindings(self, button, lastButton)]];
                    }else{
                        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button(width)]" options:0 metrics:@{@"width":@(width)} views:NSDictionaryOfVariableBindings(self, button)]];
                    }

                }
                
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, button)]];


            }
            
            
//            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
//            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if (i == _selection) {
                button.selected = YES;
            }
            lastButton = button;
            
        }
    }
}

-(void)buttonClick:(UIButton*)sender{
    
    for (UIButton * button in self.btns) {
        button.selected = [sender isEqual:button];
    }
    _currentButton=sender;
    _selection = sender.tag;
    if (_blocks) {
        for (FBRadioGroupClickBlock block in _blocks) {
            block(_selection);
        }
    }
}

-(void)setRadioGroupClick:(FBRadioGroupClickBlock)block{
    [_blocks addObject:[block copy]];
}

-(void)dealloc{
    _blocks = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
