//
//  FPDropView.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "FPDropView.h"

@interface FPDropView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIImageView* bg;
@property (nonatomic, copy) FPDropViewSelectedHandler block;

@end

@implementation FPDropView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self install];
    }
    return self;
}

- (void)install{
    _itemHeight = 25.;
    _font = [UIFont systemFontOfSize:15.];
    _height = -1;
    _textColor = [UIColor whiteColor];
    _textAlignment = NSTextAlignmentLeft;
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:_tableView];
    
}

-(void)showInController:(UIViewController *)vc parentView:(UIView *)parentView{
    [vc.view endEditing:YES];
    if (_height == -1) {
        _height = _titles.count * 25;
    }
    [vc.view addSubview:self];
    self.frame = vc.view.bounds;
    CGRect parentFrame = [parentView.superview convertRect:parentView.frame toView:vc.view];
    CGFloat parentHeight = parentFrame.size.height;
    _tableView.frame = parentFrame;
    parentFrame.size.height = 0;
    _bg.frame = parentFrame;
    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = parentFrame;
        frame.size.height  += parentHeight + ws.height + 10;
        
        ws.bg.frame = frame;
        frame = parentFrame;
        frame.origin.y += parentHeight;
        if (ws.isFamily == NO) {
            frame.origin.x += 5;
            frame.size.width -= 20;
        }
        frame.size.height = _height;
        ws.tableView.frame = frame;
        
    } completion:^(BOOL finished) {
        [ws.tableView reloadData];
    }];
}

-(void)close:(id)sender{
    [self dismiss];
}

-(void)dismiss{
    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = ws.bg.frame;
        frame.size.height = 0;
        ws.bg.frame = frame;
        frame = ws.tableView.frame;
        frame.size.height = 0;
        ws.tableView.frame = frame;
        
    } completion:^(BOOL finished) {
        [ws removeFromSuperview];
    }];
}

-(void)setSelectedHandler:(FPDropViewSelectedHandler)block{
    _block = [block copy];
}

#pragma UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = _font;
    cell.textLabel.text = _titles[indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = _textColor;
    cell.textLabel.textAlignment = _textAlignment;
    return cell;
}

#pragma UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _itemHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25.;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_block &&_block(indexPath.row)) {
        [self dismiss];
    }
}

-(void)dealloc{
    _block = nil;
    _tableView = nil;
    _bg = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
