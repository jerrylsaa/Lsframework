//
//  BookingTimePresenter.m
//  FamilyPlatForm
//
//  Created by Tom on 16/4/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BookingTimePresenter.h"

@implementation BookingTimePresenter

- (void)loadBookTimeList:(NSString *)bookDate andDoctorID:(NSNumber *)doctorID{
    
    NSDictionary* parames = @{@"doctorID":doctorID,@"apppintDate":bookDate};
    WS(ws);
    [[FPNetwork POST:API_QUERY_DOCTOR_APPOINTMENT withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(response.success){
            ws.dataSource = [BookTimeEntity mj_objectArrayWithKeyValuesArray:response.data];
        }
        
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(onCompletion:info:)]){
            [ws.delegate onCompletion:response.success info:response.message];
        }
    }];
}

-(void)commitBook:(NSNumber *)appointID andDoctorID:(NSNumber *)doctorID{

    NSInteger userID = kCurrentUser.userId;
    NSNumber* babyID = [DefaultChildEntity defaultChild].babyID;
    
    NSString* hospitalName = [NSString showContent:@"hospital"];
    NSString* departName = [NSString showContent:@"depart"];
    NSInteger hospitalID = [HospitalEntity findHospatialIDWithName:hospitalName];
    NSInteger departID = [DepartmentEntity findDepartID:departName];
    NSLog(@"hospitalID==%ld---departID==%ld",hospitalID,departID);
    
    NSDictionary* parames = @{@"UserID":@(userID),
                              @"BabyID":babyID,
                              @"HospitalID":@(hospitalID),
                              @"DepartID":@(departID),
                              @"DoctorID":doctorID,
                              @"ApppintID":appointID};
    WS(ws);
    [[FPNetwork POST:API_INSERT_BOOKING_ORDER withParams:parames] addCompleteHandler:^(FPResponse *response) {
        if(ws.delegate && [ws.delegate respondsToSelector:@selector(commitOnCompletion:info:)]){
            [ws.delegate commitOnCompletion:response.success info:response.message];
        }
    }];
    
    
    

}


@end
