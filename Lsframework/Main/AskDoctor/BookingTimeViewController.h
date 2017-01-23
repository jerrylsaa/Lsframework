//
//  BookingTimeViewController.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
#import "DoctorList.h"



@interface BookingTimeViewController : BaseViewController

@property(nonatomic,retain) DoctorList* doctor;
@property(nonatomic,retain) NSString* bookDate;


@end
