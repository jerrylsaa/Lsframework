//
//  ACDoctorDetailViewController.h
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "DoctorList.h"
typedef NS_ENUM(NSUInteger, DoctorDetailType) {
    DoctorDetailTypeAccuration,
    DoctorDetailTypeBooking,
};

@interface ACDoctorDetailViewController : BaseViewController

@property (nonatomic ,assign) DoctorDetailType docDetailType;

@property (nonatomic ,strong) NSNumber *doctorId;

@property (nonatomic ,strong) UIImage *headImage;



@end
