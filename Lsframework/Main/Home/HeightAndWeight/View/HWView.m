//
//  HWView.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HWView.h"
#import "DefaultChildEntity.h"

@interface HWView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *compareLabel;
@property (nonatomic, strong) UIView *tipsBackView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *chartButton;
@property (nonatomic, strong) UIView *sepView;


@end

@implementation HWView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    [self setupScrollView];
    [self setupTitleLabel];
    [self setupIcon];
    [self setupDateLabel];
    [self setupAgeLabel];
    [self setupCompareLabel];
    [self setupTips];
    [self setupSep];
    [self setupChartButton];
    [self setupContainer];
    [self setupDefaultLabel];
    [self setupField];
    [self setupUnit];
}
- (void)setupScrollView{
    
    _scrollView = [UIScrollView new];
    [self addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}
- (void)setupTitleLabel{
    _titleLabel = [UILabel new];
    [_scrollView addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(_scrollView,17).topSpaceToView(_scrollView,17).rightSpaceToView(_scrollView,17).heightIs(15);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = UIColorFromRGB(0x666666);
}
- (void)setupIcon{
    _icon = [UIImageView new];
    _icon.userInteractionEnabled = YES;
    UITapGestureRecognizer  *HeightandWeightTap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(heightAndWeightTap)];
    [_icon addGestureRecognizer:HeightandWeightTap];
    [_scrollView addSubview:_icon];
    _icon.sd_layout.topSpaceToView(_titleLabel,62.5).heightIs(143).widthIs(143).centerXEqualToView(_scrollView);
}
-(void)heightAndWeightTap{
    
  [self.delegate clickWeightAndHeightSegment];
    
}
- (void)setupDateLabel{
    _dateLabel = [UILabel new];
    _dateLabel.textColor = UIColorFromRGB(0x666666);
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.numberOfLines = 0;
    [_scrollView addSubview:_dateLabel];
    _dateLabel.sd_layout.rightSpaceToView(_icon,10).centerYEqualToView(_icon).leftSpaceToView(_scrollView,0).autoHeightRatio(0);
}
- (void)setupAgeLabel{
    _ageLabel = [UILabel new];
    _ageLabel.textColor = UIColorFromRGB(0x666666);
    _ageLabel.font = [UIFont systemFontOfSize:14];
    _ageLabel.textAlignment = NSTextAlignmentLeft;
    _ageLabel.numberOfLines = 0;
    [_scrollView addSubview:_ageLabel];
    _ageLabel.sd_layout.leftSpaceToView(_icon,10).rightSpaceToView(_scrollView,0).centerYEqualToView(_icon).autoHeightRatio(0);
}
- (void)setupCompareLabel{
    _compareLabel = [UILabel new];
    _compareLabel.textColor = UIColorFromRGB(0x666666);
    _compareLabel.font = [UIFont systemFontOfSize:16];
    _compareLabel.numberOfLines = 0;
    _compareLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_compareLabel];
    _compareLabel.sd_layout.leftSpaceToView(_scrollView,17).rightSpaceToView(_scrollView,17).topSpaceToView(_icon,30).autoHeightRatio(0);
}
- (void)setupTips{
    
    _tipsBackView = [UIView new];
    _tipsBackView.backgroundColor = UIColorFromRGB(0xfff9ef);
    [_scrollView addSubview:_tipsBackView];
    _tipsBackView.sd_layout.widthIs(300).topSpaceToView(_compareLabel,30).centerXEqualToView(_scrollView).minHeightIs(80);
    _tipsBackView.sd_cornerRadius = @10;
    
    _tipsLabel = [UILabel new];
    _tipsLabel.textColor = UIColorFromRGB(0x666666);
    _tipsLabel.font = [UIFont systemFontOfSize:14];
    _tipsLabel.numberOfLines = 0;
    [_tipsBackView addSubview:_tipsLabel];
    _tipsLabel.sd_layout.leftSpaceToView(_tipsBackView,17).rightSpaceToView(_tipsBackView,17).topSpaceToView(_tipsBackView,12.5).minHeightIs(15).autoHeightRatio(0);
    [_tipsBackView setupAutoHeightWithBottomView:_tipsLabel bottomMargin:12.5];
}
- (void)setupSep{
    _sepView = [UIView new];
    _sepView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_scrollView addSubview:_sepView];
    _sepView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_tipsBackView,25).heightIs(2);
}
- (void)setupChartButton{
    _chartButton = [UIButton new];
    [_scrollView addSubview:_chartButton];
    _chartButton.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_sepView,0).heightIs(102);
    [_chartButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_chartButton addTarget:self action:@selector(chartAction) forControlEvents:UIControlEventTouchUpInside];
    _chartButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _chartButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_chartButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [_chartButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    
    
}
- (void)setupContainer{
    _container = [UIView new];
    _container.backgroundColor = [UIColor whiteColor];
    [_scrollView insertSubview:_container atIndex:0];
    _container.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_scrollView,0).bottomEqualToView(_chartButton);
    [_scrollView setupAutoContentSizeWithBottomView:_container bottomMargin:0];
}
- (void)setupDefaultLabel{
    _defaultLabel = [UILabel new];
    _defaultLabel.textColor = UIColorFromRGB(0x333333);
    _defaultLabel.font = [UIFont systemFontOfSize:16];
    _defaultLabel.numberOfLines = 3;
    _defaultLabel.textAlignment = NSTextAlignmentCenter;
    [_icon addSubview:_defaultLabel];
    _defaultLabel.sd_layout.widthIs(100).autoHeightRatio(0).centerXEqualToView(_icon).centerYEqualToView(_icon);
}

- (void)setupField{
    _field = [UITextView new];
    _field.delegate = self;
    UITapGestureRecognizer  *HeightandWeightTap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(heightAndWeightTap)];
    [_field addGestureRecognizer:HeightandWeightTap];
    _field.keyboardType = UIKeyboardTypeNumberPad;
    _field.backgroundColor = [UIColor clearColor];
    _field.font = [UIFont systemFontOfSize:25];
    _field.textColor = UIColorFromRGB(0xf06292);
    _field.textAlignment = NSTextAlignmentCenter;
    _field.textContainer.maximumNumberOfLines = 1;
    _field.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    [_icon addSubview:_field];
    _field.sd_layout.widthIs(120).heightIs(40).centerYEqualToView(_icon).centerXEqualToView(_icon);
}
- (void)setupUnit{
    _unitLabel = [UILabel new];
    _unitLabel.font = [UIFont systemFontOfSize:18];
    _unitLabel.textColor = UIColorFromRGB(0x666666);
    _unitLabel.textAlignment = NSTextAlignmentCenter;
    _unitLabel.hidden = YES;
    [_icon addSubview:_unitLabel];
    _unitLabel.sd_layout.widthIs(60).bottomSpaceToView(_icon,20).heightIs(20).centerXEqualToView(_icon);
}

- (void)chartAction{
    [self.delegate selectChart:self.tag];
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = [NSString stringWithFormat:@"保持记录宝宝%@对宝宝健康至关重要",title];
    _icon.image = [UIImage imageNamed:[title isEqualToString:@"身高"] == YES ?@"height_input" : @"weight_input"];
    
    NSArray *entityArray = [DefaultChildEntity MR_findAll];
    if (entityArray.count == 0) {
        _dateLabel.text = @"";
        _ageLabel.text = @"";
    }else{
        NSDate *date = [DefaultChildEntity defaultChild].birthDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *str = [formatter stringFromDate:date];
        _dateLabel.text = str;
        _ageLabel.text = [DefaultChildEntity defaultChild].nL;
    }
    _compareLabel.text = @"同龄宝宝对比：无数据";
    _tipsLabel.text = @"保存查看您的宝宝身体评价";
    [_chartButton setImage:[UIImage imageNamed:[title isEqualToString:@"身高"] == YES ?@"height_chart" : @"weight_chart"] forState:UIControlStateNormal];
    if ([title isEqualToString:@"身高"]) {
        [_chartButton setTitle:@"身高趋势图" forState:UIControlStateNormal];
        [_chartButton setImage:[UIImage imageNamed:@"height_chart"] forState:UIControlStateNormal];
        _unitLabel.text = @"cm";
    }else{
        [_chartButton setTitle:@"体重趋势图" forState:UIControlStateNormal];
        [_chartButton setImage:[UIImage imageNamed:@"weight_chart"] forState:UIControlStateNormal];
        _unitLabel.text = @"kg";
    }
    NSString *text = [NSString stringWithFormat:@"点击记录\n \n宝宝%@",title];
    _defaultLabel.text = text;
    
}
- (void)setCompareText:(NSString *)compareText{
    _compareLabel.text = [NSString stringWithFormat:@"同龄宝宝对比：%@",compareText];
}
- (void)setTipsText:(NSString *)tipsText{
    _tipsLabel.text = tipsText;
    [_tipsLabel updateLayout];
    [_tipsBackView updateLayout];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length > 0) {
        _defaultLabel.hidden = YES;
        _unitLabel.hidden = NO;
    }else{
        _defaultLabel.hidden = NO;
        _unitLabel.hidden = YES;
    }
    self.text = textView.text;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        _defaultLabel.hidden = YES;
         _unitLabel.hidden = NO;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    _defaultLabel.hidden = YES;
    _unitLabel.hidden = NO;
}

- (void)setText:(NSString *)text{
    _field.text = text;
}

@end
