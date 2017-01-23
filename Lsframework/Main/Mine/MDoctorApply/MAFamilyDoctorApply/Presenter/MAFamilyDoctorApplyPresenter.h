//
//  MAFamilyDoctorApplyPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MineApplyFamilyDoctorEntity.h"

@protocol MAFamilyDoctorApplyPresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) info;

@end


@interface MAFamilyDoctorApplyPresenter : BasePresenter


@property(nonatomic,retain) id<MAFamilyDoctorApplyPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<MineApplyFamilyDoctorEntity* >* dataSource;


- (void)getMyApplyFamilyDoctor;

- (void)refreshHeader;

@end
