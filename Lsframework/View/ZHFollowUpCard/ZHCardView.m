//
//  ZHCardView.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ZHCardView.h"

@interface ZHCardView ()<CellFieldDelegate>

@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,strong)NSArray *array;

@property (nonatomic ,strong)UILabel *titleLabel;

@end

@implementation ZHCardView

- (instancetype)initWithTitle:(NSString *)title array:(NSArray *)array{
    self = [super init];
    if (self) {
        self.title = title;
        self.array = array;
    }
    return self;
}

- (void)setupCardView{
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = _title;
    _titleLabel.backgroundColor = UIColorFromRGB(0x7FD0CA);
    [self addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(self,0).heightIs(30);
    
    for (int i = 0; i < self.array.count; i ++) {
        NSDictionary *dic = self.array[i];
        CellView *view = [[CellView alloc] initWithTitle:dic[@"title"] content:dic[@"content"] unit:dic[@"unit"]];
        view.isCurrent = self.isCurrent;
        view.delegate =self;
        view.indexPath = [NSIndexPath indexPathForRow:i inSection:self.section];
        [view setupSubview];
        [self addSubview:view];
        float orginY = 30 + 30 * i;
        view.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(self,orginY).heightIs(30);
    }
}
- (void)endEditingWithText:(NSString *)text forIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endEditingWithText:forIndexPath:)]) {
        [self.delegate endEditingWithText:text forIndexPath:indexPath];
    }
}

@end
