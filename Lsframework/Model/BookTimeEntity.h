//
//  BookTimeEntity.h
//  FamilyPlatForm
//
//  Created by lichen on 16/6/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookTimeEntity : NSObject


/*
 
 "ID":5,
 "DoctorID":62,
 "AppointmentDate":"2016-06-25",
 "AppointmentTime":"08:00",
 "AppointmentCount":0,
 "AlreadyCout":10

 
 */

@property(nonatomic) NSInteger keyID;
@property(nonatomic,retain) NSNumber* doctorID;
@property(nonatomic,copy) NSString* appointmentDate;
@property(nonatomic,copy) NSString* appointmentTime;
@property(nonatomic) NSInteger appointmentCount;
@property(nonatomic) NSInteger alreadyCout;



@end
