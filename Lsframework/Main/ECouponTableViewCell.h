//
//  ECouponTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/18.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponList.h"
@interface ECouponTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel  *CouponName;
@property(nonatomic,strong)UILabel  *CouponMoney;
@property(nonatomic,strong)UILabel  *CouponType;
@property(nonatomic,strong)UIButton  *CouponBtn;
@property(nonatomic,strong)UIImageView  *CouponImageView;
@property(nonatomic,retain) CouponList * couponList;
@property (nonatomic,assign) BOOL isSelected;



@end
