//
//  MWalletCell.m
//  FamilyPlatForm
//
//  Created by lichen on 16/4/23.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MWalletCell.h"
#import "JMFoundation.h"

@interface MWalletCell (){
    UILabel* _date;
    UILabel* _name;
    UILabel* _money;
}

@end

@implementation MWalletCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIView* container = [UIView new];
    container.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.contentView addSubview:container];
    
    _date = [UILabel new];
    _date.textColor = UIColorFromRGB(0x808080);
    _date.font = [UIFont systemFontOfSize:14];
    _date.textAlignment = NSTextAlignmentLeft;
    
    _name = [UILabel new];
    _name.textColor = _date.textColor;
    _name.font = _date.font;
    
    _money = [UILabel new];
    _money.textColor = _date.textColor;
    _money.font = _date.font;
    _money.textAlignment = NSTextAlignmentRight;

    [container sd_addSubviews:@[_date, _name, _money]];
    
    _date.sd_layout.topSpaceToView(container,15).leftSpaceToView(container,10).heightIs(15).widthIs(80);
    
    _name.sd_layout.centerYEqualToView(_date).leftSpaceToView(_date,10).heightIs(15).maxWidthIs(300).minWidthIs(130);
//    [_name setSingleLineAutoResizeWithMaxWidth:kScreenWidth];
    
    _money.sd_layout.centerYEqualToView(_date).rightSpaceToView(container,15).leftSpaceToView(_name,15).heightIs(15);
//    [_money setSingleLineAutoResizeWithMaxWidth:200];

    
    container.sd_layout.topEqualToView(self.contentView).leftEqualToView(self.contentView).rightEqualToView(self.contentView);
//    [container setupAutoHeightWithBottomViewsArray:@[_date, _name, _money] bottomMargin:15];
    
//    [self setupAutoHeightWithBottomView:container bottomMargin:0];
}

-(void)setWallet:(MWallet *)wallet{
    _wallet = wallet;
    
//    CGFloat height = 15;
//    CGFloat dateWidth = [JMFoundation calLabelWidth:_date.font andStr: [wallet.date substringToIndex:10] withHeight:height];
//    _date.sd_layout.widthIs(dateWidth);
//    CGFloat nameWidth = [JMFoundation calLabelWidth:_date.font andStr: wallet.name withHeight:height];
//    _name.sd_layout.widthIs(nameWidth);
//    CGFloat moneyWidth = [JMFoundation calLabelWidth:_date.font andStr: wallet.money withHeight:height];
//    _money.sd_layout.widthIs(moneyWidth);
    NSLog(@"%@==",_wallet.money);
    _date.text = [wallet.date substringToIndex:10];
    _name.text = wallet.remarks;
    _money.text = wallet.money;
    
}



@end
