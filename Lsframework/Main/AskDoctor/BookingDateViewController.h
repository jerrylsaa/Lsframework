//
//  BookingDateViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "DoctorList.h"

typedef NS_ENUM(NSUInteger, BookDateTtype) {
    BookDateTtypeNomal,
    BookDateTtypeSpecial,
};

@interface BookingDateViewController : BaseViewController

@property (nonatomic ,assign)BookDateTtype dateType;

@property(nonatomic,retain) DoctorList* doctor;

@end
