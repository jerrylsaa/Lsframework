//
//  ACDoctorDetailPresenter.h
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DoctorList.h"

typedef void(^Complete)(BOOL success ,DoctorList *doctor);

@interface ACDoctorDetailPresenter : BasePresenter


@property (nonatomic ,strong) DoctorList *doctor;

- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block;

/**
 *  添加关注
 */
- (void)addAttention:(NSNumber *)doctorId complete:(Complete)block;
/**
 *  删除关注
 *
 *  @param doctorId <#doctorId description#>
 */
- (void)deleteAttention:(NSNumber *)doctorId complete:(Complete)block;
@end
