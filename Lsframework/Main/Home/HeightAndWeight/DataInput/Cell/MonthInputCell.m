//
//  MonthInputCell.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/10/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MonthInputCell.h"

@interface MonthInputCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIView *sepView;

@end

@implementation MonthInputCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    _monthLabel = [UILabel new];
    _monthLabel.textColor = UIColorFromRGB(0x30dbf0);
    _monthLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_monthLabel];
    _monthLabel.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).heightIs(15);
    
    _unitLabel = [UILabel new];
    _unitLabel.textColor = UIColorFromRGB(0x61d8d3);
    _unitLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _unitLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_unitLabel];
    _unitLabel.sd_layout.topSpaceToView(_monthLabel,5).rightSpaceToView(self.contentView,0).heightIs(18).widthIs(25);
    
    _field = [UITextField new];
    _field.delegate = self;
    _field.textColor = UIColorFromRGB(0xff99a3);
    _field.textAlignment = NSTextAlignmentCenter;
    _field.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.contentView addSubview:_field];
    _field.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(_monthLabel,5).rightSpaceToView(_unitLabel,0).heightIs(17);
    
    _sepView = [UIView new];
    _sepView.backgroundColor = UIColorFromRGB(0x30dbf0);
    [self.contentView addSubview:_sepView];
    _sepView.sd_layout.leftEqualToView(_field).rightEqualToView(_field).topSpaceToView(_field,1).heightIs(1);
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _monthLabel.text = [NSString stringWithFormat:@"%ld月",self.sd_indexPath.row+1];
    _unitLabel.text = _type;
    if (_value != nil) {
        float value = [_value.DataValue floatValue];
        _field.text = [NSString stringWithFormat:@"%.1f",value];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length > 0 && ([textField.text isPureNumber] || [textField.text regexNumber])) {
        float num = [textField.text floatValue];
        if (num == 0) {
            textField.text = @"";
            [ProgressUtil showError:@"请输入大于0的数字"];
        }else{
            textField.text = [NSString stringWithFormat:@"%.1f",num];
            if (self.delegate) {
                [self.delegate inputText:textField.text index:self.sd_indexPath.row];
            }
        }
    }else{
        textField.text = @"";
        [ProgressUtil showError:@"请输入数字"];
    }
}
- (void)setEditEnable:(BOOL)editEnable{
    if (editEnable == YES) {
        _monthLabel.textColor = UIColorFromRGB(0x30dbf0);
        _field.textColor = UIColorFromRGB(0xff99a3);
        _unitLabel.textColor = UIColorFromRGB(0x61d8d3);
        _sepView.backgroundColor = UIColorFromRGB(0x30dbf0);
    }else{
        _monthLabel.textColor = UIColorFromRGB(0xefefef);
        _field.textColor = UIColorFromRGB(0xefefef);
        _unitLabel.textColor = UIColorFromRGB(0xefefef);
        _sepView.backgroundColor = UIColorFromRGB(0xefefef);
    }
}
@end
