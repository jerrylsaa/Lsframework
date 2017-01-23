//
//  MAPhoneApplyPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

#import "MineApplyFamilyDoctorEntity.h"

@protocol MAPhoneApplyPresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) info;

@end


@interface MAPhoneApplyPresenter : BasePresenter

@property(nonatomic,retain) id<MAPhoneApplyPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<MineApplyFamilyDoctorEntity* >* dataSource;


- (void)getMAPhoneApply;

- (void)refreshHeader;


@end
