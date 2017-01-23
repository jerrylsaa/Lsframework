//
//  PageView.m
//  Community
//
//  Created by Tom on 16/1/10.
//  Copyright © 2016年 Jia. All rights reserved.
//

#import "PageView.h"


@interface PageView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * tabView;
@property (nonatomic, strong) NSLayoutConstraint * tabViewHeightConstraint;
@property (nonatomic, strong) NSMutableArray * labels;
@property (nonatomic, strong) NSLayoutConstraint * bottomLineXConstraint;
@property (nonatomic, strong) NSLayoutConstraint * bottomLineWidthConstraint;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, assign) NSInteger lastSelection;
@property (nonatomic, assign) BOOL isInitView;
@end

@implementation PageView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _isInitView = NO;
    _lastSelection = -1;
   _tabHeight = 44.f;
    _titleNormalColor = [UIColor lightGrayColor];
    _backgroundColor = [UIColor whiteColor];
    _bottomLineColor = [UIColor lightGrayColor];
    _titleHightLightColor = [UIColor blackColor];
    _separatorColor = [UIColor clearColor];
    _bottomLineHeight = 4.;
    
    _labels = [NSMutableArray new];
    _tabView = [UIView new];
    _scrollView = [UIScrollView new];
    _bottomView = [UIView new];
    
    _bottomView.backgroundColor = _bottomLineColor;
    _tabView.backgroundColor = _backgroundColor;
    [_scrollView setPagingEnabled:YES];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    [_tabView addSubview:_bottomView];
    [self addSubview:_scrollView];
    [self addSubview:_tabView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tabView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, _tabView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tabView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, _tabView)]];
    
    _tabViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_tabView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:_tabHeight];
    
    [self addConstraint:_tabViewHeightConstraint];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, _scrollView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tabView]-0-[_scrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self, _scrollView, _tabView)]];
    
    
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _tabView.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _bottomLineXConstraint = [NSLayoutConstraint constraintWithItem:_bottomView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_tabView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.];
    [_tabView addConstraint:_bottomLineXConstraint];
    
    _tabView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    _tabView.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _tabView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    _tabView.layer.shadowRadius = 1;//阴影半径，默认3
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_isInitView) {
        _isInitView = YES;
        [_tabView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomView(height)]-0-|" options:0 metrics:@{@"height":@(_bottomLineHeight)} views:NSDictionaryOfVariableBindings(_tabView, _bottomView)]];
    }
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width * _viewControllers.count, 0)];
}

-(void)initChildView{
    for (UIView * view in _tabView.subviews) {
        if (![view isEqual:_bottomView]) {
            [view removeFromSuperview];
        }
    }
    
    for (UIView * view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    UIView * last = nil;
    for (int i = 0; i < _titles.count; i ++) {
        UILabel * label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _titles[i];
        label.textColor = _titleNormalColor;
        if (i == _selection) {
            label.textColor = _titleHightLightColor;
        }
        if (self.pageType == PageTypeSubTitle) {
            label.numberOfLines = 2;
            label.font = [UIFont systemFontOfSize:(kScreenWidth == 320?14:16)];
            
        }
        if (i < _titles.count - 1) {
            UIView *sepView = [UIView new];
            sepView.backgroundColor = _separatorColor;
            [_tabView addSubview:sepView];
            sepView.sd_layout.topSpaceToView(_tabView,10).bottomSpaceToView(_tabView,10).leftSpaceToView(label,3).widthIs(2);
            sepView.layer.cornerRadius = 1;
        }
        label.userInteractionEnabled = YES;
        label.tag = i;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapAction:)]];
        [_tabView addSubview:label];
        [_tabView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tabView, label)]];
        if (!last) {
            [_tabView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tabView, label)]];
        }else{
            [_tabView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[last]-[label(==last)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tabView, label, last)]];
        }
        if (i == _titles.count - 1) {
            [_tabView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tabView, label, last)]];
        }
        last = label;
        [_labels addObject:label];
    }
    [_tabView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_bottomView(==last)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tabView, _bottomView, last)]];
    last = nil;
    for (int i = 0; i < _viewControllers.count; i ++) {
        UIViewController * vc = _viewControllers[i];
        UIView * view = vc.view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView addSubview:view];
        [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(==_scrollView)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView, view)]];
        if (last) {
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[last]-0-[view(==_scrollView)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView, view, last)]];
        }else{
            [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view(==_scrollView)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView, view)]];
        }
        last = view;
    }
    

}

-(void)itemTapAction:(UITapGestureRecognizer*)sender{
    NSInteger index = sender.view.tag;
    [self setSelection:index];
}

-(void)changeTitleColor{
    for (UILabel * label in _labels) {
        if (label.tag == _selection) {
            label.textColor = _titleHightLightColor;
        }else{
            label.textColor = _titleNormalColor;
        }
    }
}

-(void)setSelection:(NSInteger)selection{
    _selection = selection;
    if (_lastSelection != _selection) {
        if ([_delegate respondsToSelector:@selector(onPageViewTabChange:)]) {
            [_delegate onPageViewTabChange:_selection];
        }
    }
    _lastSelection = _selection;
    [self changeTitleColor];
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width * selection, 0) animated:YES];
    [_scrollView endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat xx = x / (_scrollView.frame.size.width * _viewControllers.count);
    xx = _tabView.frame.size.width * xx;
    //修正偏移
    _bottomLineXConstraint.constant = xx + 8 * x/(_scrollView.frame.size.width * _viewControllers.count);
    [_bottomView layoutIfNeeded];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    if (x >= 0 && x <= _scrollView.frame.size.width * _viewControllers.count) {
        CGFloat xx = x / _scrollView.frame.size.width;
        NSInteger index = [[NSNumber numberWithFloat:xx] integerValue];
        [self setSelection:index];
    }

}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self initChildView];
}

-(void)setBottomLineColor:(UIColor *)bottomLineColor{
    _bottomLineColor = bottomLineColor;
    _bottomView.backgroundColor = _bottomLineColor;
}


-(void)dealloc{

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
