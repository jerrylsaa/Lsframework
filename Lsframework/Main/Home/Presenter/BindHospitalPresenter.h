//
//  BindHospitalPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/10/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "BindHospitalEntity.h"

@protocol BindHospitalPresenterDelegate <NSObject>
@optional

- (void)onCompletion:(BOOL)success info:(NSString*)message;

@end

@interface BindHospitalPresenter : BasePresenter
@property (nonatomic, weak) id<BindHospitalPresenterDelegate> delegate;

- (void)bindHospitalWithExpertID:(NSString *)expertID;
@end
