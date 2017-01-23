//
//  MDoctorApplyPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DataTaskManager.h"
#import "MineApplyFamilyDoctorEntity.h"

@protocol MDoctorApplyPresenterDelegate <NSObject>

@optional
- (void)onCompletion;

@end

@interface MDoctorApplyPresenter : BasePresenter

@property(nonatomic,weak) id<MDoctorApplyPresenterDelegate> delegate;

@property(nonatomic,retain) DataTaskManager* request;


@property(nonatomic,retain) FPResponse* familyDoctorResponse;
@property(nonatomic,retain) FPResponse* onlineResponse;
@property(nonatomic,retain) FPResponse* phoneResponse;


- (void)getMyApply;



@end
