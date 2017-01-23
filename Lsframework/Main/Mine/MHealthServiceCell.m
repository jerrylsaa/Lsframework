//
//  MHealthServiceCell.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/2.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MHealthServiceCell.h"
#import "MHealthServiceOderViewController.h"
#import "AliPayUtil.h"

@interface MHealthServiceCell ()<UIActionSheetDelegate>{
    UIView* _container;
    UIImageView* _firstLine;
    UILabel *_dateLabel;
    UILabel *_stateLabel;
    UIImageView *_mainIV;
    UILabel* _serviceNameLabel;
    UILabel* _priceLabel;
    UIImageView* _secondLine;
    UILabel *_bottomTipLabel;
    UILabel *_bottomPriceLabel;
    UIButton *_cancelBtn;
    UIButton *_payBtn;
    UILabel *_payWayTipLabel;
    UILabel *_payWayShowLabel;
}

@end

@implementation MHealthServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        
        _container = [UIView new];
        [self.contentView addSubview:_container];
        
        _firstLine = [UIImageView new];
        _firstLine.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [_container addSubview:_firstLine];
        
        _dateLabel = [UILabel new];
        _dateLabel.textColor = UIColorFromRGB(0x767676);
        _dateLabel.font = [UIFont systemFontOfSize:13];
        [_container addSubview:_dateLabel];
        
        _stateLabel = [UILabel new];
        _stateLabel.textAlignment =NSTextAlignmentRight;
        _stateLabel.font = [UIFont systemFontOfSize:13];
        [_container addSubview:_stateLabel];
        
        _mainIV = [UIImageView new];
        
        [_container addSubview:_mainIV];
        
        _serviceNameLabel =[UILabel new];
        _serviceNameLabel.numberOfLines =0;
        _serviceNameLabel.textColor =UIColorFromRGB(0x333333);
        _serviceNameLabel.font =[UIFont systemFontOfSize:16];
        [_container addSubview:_serviceNameLabel];

        
        _priceLabel = [UILabel new];
        _priceLabel.textAlignment =NSTextAlignmentRight;
        _priceLabel.textColor = UIColorFromRGB(0x333333);
        _priceLabel.font = [UIFont systemFontOfSize:13];
        [_container addSubview:_priceLabel];
        
        _secondLine = [UIImageView new];
        _secondLine.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [_container addSubview:_secondLine];
        
        _bottomTipLabel =[UILabel new];
        _bottomTipLabel.text =@"应付金额";
        _bottomTipLabel.textColor =UIColorFromRGB(0x767676);
        _bottomTipLabel.font =[UIFont systemFontOfSize:14];
        [_container addSubview:_bottomTipLabel];
        
        _bottomPriceLabel =[UILabel new];
        _bottomPriceLabel.textAlignment =NSTextAlignmentRight;
        _bottomPriceLabel.textColor =UIColorFromRGB(0x61d8d3);
        _bottomPriceLabel.font =[UIFont systemFontOfSize:14];
        [_container addSubview:_bottomPriceLabel];
        
        _cancelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancleBackG"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:_cancelBtn];
        
        _payBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setImage:[UIImage imageNamed:@"payBackG"] forState:UIControlStateNormal];
        [_container addSubview:_payBtn];
        
//        _payWayTipLabel =[UILabel new];
//        _payWayTipLabel.text =@"付款方式";
//        _payWayTipLabel.textColor =UIColorFromRGB(0x767676);
//        _payWayTipLabel.font =[UIFont systemFontOfSize:14];
//        [_container addSubview:_payWayTipLabel];
//        
//        _payWayShowLabel =[UILabel new];
//        _payWayShowLabel.textAlignment =NSTextAlignmentRight;
//        _payWayShowLabel.textColor =UIColorFromRGB(0x767676);
//        _payWayShowLabel.font =[UIFont systemFontOfSize:14];
//        [_container addSubview:_payWayShowLabel];
        
        UIImageView *bottomSeperratorIV =[UIImageView new];
        bottomSeperratorIV.backgroundColor =UIColorFromRGB(0xf2f2f2);
        [_container addSubview:bottomSeperratorIV];
        
        //添加约束
        _container.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        _dateLabel.sd_layout.topSpaceToView(_container,10).leftSpaceToView(_container,15).widthIs(150).heightIs(20);
        _stateLabel.sd_layout.topSpaceToView(_container,10).rightSpaceToView(_container,15).widthIs(150).heightIs(20);
        
        
        _firstLine.sd_layout.topSpaceToView(_dateLabel,10).leftSpaceToView(_container,15).rightSpaceToView(_container,15).heightIs(1);
        
        _mainIV.sd_layout.topSpaceToView(_firstLine,10).leftSpaceToView(_container,15).widthIs(100).heightIs(80);
        _serviceNameLabel.sd_layout.topEqualToView(_mainIV).leftSpaceToView(_mainIV,15).rightSpaceToView(_container,15).autoHeightRatio(0);
        _priceLabel.sd_layout.topSpaceToView(_serviceNameLabel,10).rightSpaceToView(_container,15).widthIs(100).heightIs(20);
        if (CGRectGetMaxY(_priceLabel.frame)>=CGRectGetMaxY(_mainIV.frame)) {
            _secondLine.sd_layout.topSpaceToView(_priceLabel,15).leftSpaceToView(_container,15).rightSpaceToView(_container,15).heightIs(1);
        }else{
            
            _secondLine.sd_layout.topSpaceToView(_mainIV,15).leftSpaceToView(_container,15).rightSpaceToView(_container,15).heightIs(1);
        }
        _bottomTipLabel.sd_layout.leftSpaceToView(_container,15).topSpaceToView(_secondLine,10).widthIs(100).heightIs(20);
        _bottomPriceLabel.sd_layout.rightSpaceToView(_container,15).topSpaceToView(_secondLine,10).widthIs(100).heightIs(20);
//        _payWayTipLabel.sd_layout.leftSpaceToView(_container,15).topSpaceToView(_bottomTipLabel,10).widthIs(100).heightIs(20);
//        _payWayShowLabel.sd_layout.rightSpaceToView(_container,15).topSpaceToView(_bottomPriceLabel,10).widthIs(100).heightIs(20);
        _payBtn.sd_layout.rightSpaceToView(_container,15).topSpaceToView(_bottomPriceLabel,15).widthIs(87).heightIs(32);
        _cancelBtn.sd_layout.rightSpaceToView(_payBtn,15).topSpaceToView(_bottomPriceLabel,15).widthIs(87).heightIs(32);
        bottomSeperratorIV.sd_layout.topSpaceToView(_cancelBtn,10).leftSpaceToView(_container,0).rightSpaceToView(_container,0).heightIs(10);
        [_container setupAutoHeightWithBottomView:bottomSeperratorIV bottomMargin:0];
        
        [self setupAutoHeightWithBottomView:_container bottomMargin:0];
        
        
    }
    return self;
    
}

- (void)setMyOderList:(MHealthServiceOderListEntity *)myOderList{
    _myOderList =myOderList;
    _priceLabel.text =[NSString stringWithFormat:@"¥%@",myOderList.TOTAL_PRICE];
    
    _bottomPriceLabel.text =[NSString stringWithFormat:@"¥%@",myOderList.PAY_PRICE];
//    _dateLabel.text =myOderList.CREATE_TIME;
    _dateLabel.text =myOderList.Time;
    /*
     等待支付 = 1,
     支付成功 = 2,
     完成订单 = 16,
     关闭订单 = 32
     */
    if ([myOderList.STATE integerValue]==1) {
        _stateLabel.text =@"待付款";
        _payWayTipLabel.hidden =YES;
        _payWayShowLabel.hidden =YES;
        _payBtn.hidden =NO;
        _cancelBtn.hidden =NO;
        
    }else if([myOderList.STATE integerValue]==2){
        _stateLabel.text =@"已付款";
        _payWayTipLabel.hidden =NO;
        _payWayShowLabel.hidden =NO;
        _payBtn.hidden =YES;
        _cancelBtn.hidden =YES;

    }else if([myOderList.STATE integerValue]==16){
        _stateLabel.text =@"已完成";
        _payWayTipLabel.hidden =NO;
        _payWayShowLabel.hidden =NO;
        _payBtn.hidden =YES;
        _cancelBtn.hidden =YES;
        
    }else if([myOderList.STATE integerValue]==32){
        _stateLabel.text =@"已取消";
        _payWayTipLabel.hidden =NO;
        _payWayShowLabel.hidden =NO;
        _payBtn.hidden =YES;
        _cancelBtn.hidden =YES;
        
    }
    [_container updateLayout];
}

-(void)setMyOderDetail:(MHSOderDetailEntity *)myOderDetail{
    _myOderDetail =myOderDetail;
    
    [_mainIV sd_setImageWithURL:[NSURL URLWithString:myOderDetail.MAIN_PIC] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    _serviceNameLabel.text =myOderDetail.NAME;
    [_container updateLayout];
}

- (void)payAction:(UIButton *)btn{
    MHealthServiceOderViewController *ctrl =[self getCurrentViewController];
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
    sheet.tag = 1000;
    [sheet showInView:ctrl.view];
    

}

- (void)cancelAction:(UIButton *)btn{
    MHealthServiceOderViewController *ctrl =[self getCurrentViewController];
    [ProgressUtil show];
    [ctrl.presenter cancelOderWithOderID:_myOderList.ID];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        NSLog(@"支付宝");
        
        WS(ws);
        NSString *title =[NSString stringWithFormat:@"掌上儿保-%@",_serviceNameLabel.text];
        CGFloat price=[_myOderList.PAY_PRICE floatValue];
        [ProgressUtil show];
        [AliPayUtil payWithTitle:title withDetail:@"详情" withOrderNum:_myOderList.ORDER_NO withPrice:price healthServiceCallback:^(NSDictionary*dict){
            //支付成功调用，订单支付成功接口，并且调用插入咨询表的接口
            NSString* payStatus = dict[@"resultStatus"];
            if([payStatus isEqualToString:@"9000"]){
                NSLog(@"支付成功");
                if(ws.delegate && [ws.delegate respondsToSelector:@selector(paySuccess)]){
                    [ws.delegate paySuccess];
                }
                
                
            }else if([payStatus isEqualToString:@"6001"]){
                NSLog(@"用户中途取消支付");
                
                [ProgressUtil showInfo:@"用户取消支付"];
            }else if([payStatus isEqualToString:@"6002"]){
                
                NSLog(@"网络连接出错");
                [ProgressUtil showInfo:@"网络连接出错"];
            }else if([payStatus isEqualToString:@"4000"]){
                
                NSLog(@"订单支付失败");
                [ProgressUtil showInfo:@"订单支付失败"];
            }else{
                
                NSLog(@"正在处理中");
            }
            
        }];

    }else if(buttonIndex ==1){
        NSLog(@"微信");
        MHealthServiceOderViewController *ctrl =[self getCurrentViewController];
        [ProgressUtil show];
        [ctrl.presenter getWxPayParamsWithOderID:_myOderList.ID];

    }else if(buttonIndex ==2){
        NSLog(@"取消");
        
    }
}

/** 获取当前View的控制器对象 */
-(MHealthServiceOderViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[MHealthServiceOderViewController class]]) {
            return (MHealthServiceOderViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
