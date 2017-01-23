//
//  CouponableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/8/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CouponableViewCell.h"

@implementation CouponableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
            [self setupSubviews];
    self.contentView.backgroundColor = [UIColor  whiteColor];
    }
    return self;
}
-(void)setupSubviews{
    
  UIView   *containerView = [UIView new];
    containerView.backgroundColor = [UIColor  whiteColor];
    [self.contentView addSubview:containerView];

    _CouponImageView = [UIImageView  new];
    _CouponImageView.backgroundColor = [UIColor  clearColor];
    [containerView  addSubview:_CouponImageView];
    
    _CouponName = [UILabel new];
    _CouponName.backgroundColor = [UIColor  clearColor];
    _CouponName.font = [UIFont  boldSystemFontOfSize:12];
    _CouponName.textColor = UIColorFromRGB(0x333333);
    _CouponName.textAlignment = NSTextAlignmentLeft;
    [_CouponImageView  addSubview:_CouponName];
    
    _CouponMoney = [UILabel new];
    _CouponMoney.backgroundColor = [UIColor  clearColor];
    _CouponMoney.font = [UIFont  boldSystemFontOfSize:20];
    _CouponMoney.textColor = UIColorFromRGB(0x333333);
    _CouponMoney.textAlignment = NSTextAlignmentCenter;
    [_CouponImageView  addSubview:_CouponMoney];
    
    
    _CouponType = [UILabel new];
    _CouponType.backgroundColor = [UIColor  clearColor];
    _CouponType.font = [UIFont  boldSystemFontOfSize:14];
    _CouponType.textColor = UIColorFromRGB(0x333333);
    _CouponType.textAlignment = NSTextAlignmentRight;
    [_CouponImageView  addSubview:_CouponType];
    
    
    int  CouponNametop = 25/2;
    int  CouponTypetop = 102/2;
    int  CouponMoneybottom = 70/2;
    int  CouponNameleft = 30/2;
    int  CouponTyperight = 180/2;
    
    if (kScreenHeight == 736) {
        //6p
        CouponMoneybottom = 70/2*736/667;
        CouponNametop = 25/2*736/667;
        CouponTypetop = 102/2*736/667;
        
        CouponNameleft = 30/2*414/375;
        CouponTyperight = 180/2*414/375;

        
        
    }    if (kScreenHeight == 568) {
        //5
        CouponMoneybottom = 70/2*568/667;
        CouponNametop = 25/2*568/667;
        CouponTypetop = 102/2*568/667;
        
        CouponNameleft = 30/2*320/375;
        CouponTyperight = 180/2*320/375;

        
        
        
    }    if (kScreenHeight == 480) {
        //4s
        CouponMoneybottom = 70/2*480/667;
        CouponNametop = 25/2*480/667;
        CouponTypetop = 102/2*480/667;
        
        CouponNameleft = 30/2*320/375;
        CouponTyperight = 180/2*320/375;

        
        
        
    }

    
    

    containerView.sd_layout.topSpaceToView(self.contentView,30/2).centerXEqualToView(self.contentView).widthIs(kFitWidthScale(690)).heightIs(kFitHeightScale(236));
    _CouponImageView.sd_layout.topEqualToView(containerView).leftEqualToView(containerView).rightEqualToView(containerView).heightIs(kFitHeightScale(236));
    //30元通用优惠券
    _CouponName.sd_layout.topSpaceToView(_CouponImageView,CouponNametop).leftSpaceToView(_CouponImageView,CouponNameleft).widthIs(kFitWidthScale(690)).heightIs(12);
    //专家咨询优惠券
    _CouponType.sd_layout.topSpaceToView(_CouponImageView,CouponTypetop).rightSpaceToView(_CouponImageView,CouponTyperight).widthIs(kFitWidthScale(690)).heightIs(14);
    //￥元
  _CouponMoney.sd_layout.bottomSpaceToView(_CouponImageView,CouponMoneybottom).leftSpaceToView(_CouponImageView,0).widthIs(kFitWidthScale(200)).heightIs(20);
    [self   setupAutoHeightWithBottomView:containerView bottomMargin:0];

}

- (void)setCouponList:(CouponList *)couponList{
    _couponList = couponList;
    
    _CouponName.text = [NSString  stringWithFormat:@"通用%ld元券",couponList.Money]; //优惠券名称
    _CouponType.text = couponList.Describe;//优惠券类型
    _CouponMoney.text =  [NSString  stringWithFormat:@"￥%ld",couponList.Money];   //优惠券金额
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
