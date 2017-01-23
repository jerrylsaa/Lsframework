//
//  FDMainPresenter.h
//  FamilyPlatForm
//
//  Created by tom on 16/4/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "FamilyDoctorEntity.h"

@protocol FDMainPresenterDelegate <NSObject>

- (void)onCompletion:(BOOL) success info:(NSString*) message;

@end

@interface FDMainPresenter : BasePresenter

@property(nonatomic,weak) id<FDMainPresenterDelegate> delegate;

@property(nonatomic) BOOL hasFamilyDoctor;

@property(nonatomic,retain) NSArray<FamilyDoctorEntity*> * dataSource;

- (void)getFamilyDoctor;


@end
