//
//  CouponableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/16.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponList.h"
@interface CouponableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel  *CouponName;
@property(nonatomic,strong)UILabel  *CouponMoney;
@property(nonatomic,strong)UILabel  *CouponType;
@property(nonatomic,strong)UIImageView  *CouponImageView;
@property(nonatomic,retain) CouponList * couponList;


@end
