//
//  CellView.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CellView.h"
#import "JMFoundation.h"

#define FONT_WIDTH [UIFont systemFontOfSize:(kScreenWidth == 320 ? 14 : 18)]

@interface CellView ()<UITextFieldDelegate>

@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *content;
@property (nonatomic ,copy)NSString *unit;

@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UIImageView *backView;
@property (nonatomic ,strong)UITextField *field;
@property (nonatomic ,strong)UILabel *unitLabel;

@property (nonatomic ,strong)NSDictionary *dicSource;

@end

@implementation CellView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content unit:(NSString *)unit{
    self = [super init];
    if (self) {
        self.title = title;
        self.content = content;
        self.unit = unit;
    }
    return self;
}

- (void)setupSubview{
    
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = UIColorFromRGB(0x535353);
    _titleLabel.font = FONT_WIDTH;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    _titleLabel.text = [self changeByTitle:_title];
    CGFloat width = [JMFoundation calLabelWidth:FONT_WIDTH andStr:[self changeByTitle:_title] withHeight:30];
    if (width < 80) {
        width = 80;
    }
    _titleLabel.sd_layout.leftSpaceToView(self,20).topSpaceToView(self,0).heightIs(30).widthIs(width);
    
    _unitLabel = [UILabel new];
    _unitLabel.text = _unit;
    _unitLabel.textColor = UIColorFromRGB(0x535353);
    _unitLabel.textAlignment = NSTextAlignmentCenter;
    _unitLabel.font = FONT_WIDTH;
    [self addSubview:_unitLabel];
    CGFloat unitWidth = [JMFoundation calLabelWidth:FONT_WIDTH andStr:_unit withHeight:30];
    if (unitWidth < 30) {
        unitWidth = 30;
    }
    _unitLabel.sd_layout.rightSpaceToView(self,20).topSpaceToView(self,0).heightIs(30).widthIs(unitWidth);
    _unitLabel.backgroundColor = [UIColor clearColor];
    
    
    _backView = [UIImageView new];
    _backView.userInteractionEnabled = YES;
    _backView.image = [self stretchableImageWithImageName:@"text_nor"];
    [self addSubview:_backView];
    _backView.sd_layout.leftSpaceToView(_titleLabel,0).rightSpaceToView(_unitLabel,0).topSpaceToView(self,5).heightIs(20);
    _backView.clipsToBounds = YES;
    _backView.layer.cornerRadius = 10;
    

    _field = [UITextField new];
    _field.text = [_content isEqualToString:@"0"] ? @"" : _content;
    _field.delegate = self;
    _field.textColor = UIColorFromRGB(0x535353);
    _field.font = FONT_WIDTH;
    _field.keyboardType = UIKeyboardTypeNumberPad;
    if ([_title isEqualToString:@"YYBC"] || [_title isEqualToString:@"FSTJ"]) {
        _field.keyboardType = UIKeyboardTypeDefault;
    }
    [_backView addSubview:_field];
    _field.sd_layout.leftSpaceToView(_backView,10).rightSpaceToView(_backView,10).topSpaceToView(_backView,0).heightIs(20);
    
    
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.isCurrent == YES) {
        _field.enabled = YES;
    }else{
        _field.enabled = NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endEditingWithText:forIndexPath:)]) {
        [self.delegate endEditingWithText:textField.text forIndexPath:self.indexPath];
    }
}
/* @{@"title":@"营养补充:",@"unit":@""},
 @{@"title":@"配方奶喂养",@"unit":@"ml"},
 @{@"title":@"辅食添加",@"unit":@""},
 @{@"title":@"睡        眠:",@"unit":@""},
 @{@"title":@"溢        奶:",@"unit":@"次/日"},
 @{@"title":@"哭        闹:",@"unit":@"次/日"},
 @{@"title":@"大        便:",@"unit":@"形状/次数"},
 @{@"title":@"维生素D/AD:",@"unit":@"IU/d"},
 @{@"title":@"铁        剂:",@"unit":@"mg/d"},
 @{@"title":@"钙        剂:",@"unit":@"mg/d"},
 @{@"title":@"其        它:",@"unit":@"mg/d"},
 @{@"title":@"体        重:",@"unit":@"kg"},
 @{@"title":@"身        高:",@"unit":@"cm"},
 @{@"title":@"头        围:",@"unit":@""},nil];
 */
- (NSString *)changeByTitle:(NSString *)title{
    
    return [self.dicSource objectForKey:title];
}
- (NSDictionary *)dicSource{
    if (!_dicSource) {
        _dicSource = @{@"MRWY":@"母乳喂养：",
                       @"YYBC":@"营养补充：",
                       @"PFNWY":@"配方奶喂养：",
                       @"FSTJ":@"辅食添加：",
                       @"SM":@"睡        眠：",
                       @"YN":@"溢        奶：",
                       @"KN":@"哭        闹：",
                       @"DB":@"大        便：",
                       @"WSS":@"维生素D/AD：",
                       @"TJ":@"铁        剂：",
                       @"GJ":@"钙        剂：",
                       @"QT":@"其        它：",
                       @"TZ":@"体        重：",
                       @"SG":@"身        高：",
                       @"TW":@"头        围："};
    }
    return _dicSource;
}

@end
