//
//  ACMainViewController.h
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, MainType) {
    MainTypeAccuration,
    MainTypeBooking,
};



@interface ACMainViewController : BaseViewController

@property (nonatomic ,assign)MainType mainType;

@end
