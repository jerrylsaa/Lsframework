//
//  MAOnlineApplyPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/25.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

#import "MineApplyFamilyDoctorEntity.h"

@protocol MAOnlineApplyPresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) info;

@end


@interface MAOnlineApplyPresenter : BasePresenter

@property(nonatomic,retain) id<MAOnlineApplyPresenterDelegate> delegate;

@property(nonatomic,retain) NSArray<MineApplyFamilyDoctorEntity* >* dataSource;


- (void)getMAOnlineApply;

- (void)refreshHeader;


@end
