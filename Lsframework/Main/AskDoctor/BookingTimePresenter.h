//
//  BookingTimePresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/4/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "BookTimeEntity.h"
#import "DefaultChildEntity.h"
#import "HospitalEntity.h"
#import "DepartmentEntity.h"

@protocol BookingTimePresenterDelegate <NSObject>

@optional

- (void)onCompletion:(BOOL) success info:(NSString*) message;
- (void)commitOnCompletion:(BOOL) success info:(NSString*) message;
@end


@interface BookingTimePresenter : BasePresenter

@property(nonatomic,weak) id<BookingTimePresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<BookTimeEntity* > * dataSource;



- (void)loadBookTimeList:(NSString*) bookDate andDoctorID:(NSNumber*) doctorID;

/**
 *  提交预约
 *
 *  @param appointID <#appointID description#>
 *  @param doctorID  <#doctorID description#>
 */
- (void)commitBook:(NSNumber*) appointID andDoctorID:(NSNumber*) doctorID;


@end
