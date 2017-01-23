//
//  FDApplyDoctorPresenter.h
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^Complete)(BOOL success ,NSArray *babyArray);

@protocol FDApplyDoctorPresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) message;

@end

@interface FDApplyDoctorPresenter : BasePresenter

@property(nonatomic,weak) id<FDApplyDoctorPresenterDelegate> delegate;

- (void)commitFamilyDoctor:(NSInteger) doctorID babyID:(NSInteger) babyID packageID:(NSInteger) packageID;


- (void)loadBabyData:(Complete)block;

@end
