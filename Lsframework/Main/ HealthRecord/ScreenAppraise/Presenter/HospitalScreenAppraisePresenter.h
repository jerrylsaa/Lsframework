//
//  HospitalScreenAppraisePresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "GesellEntity.h"

@protocol HospitalScreenAppraisePresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL)success info:(NSString *)messsage;

@end
@interface HospitalScreenAppraisePresenter : BasePresenter
@property(nonatomic,weak) id<HospitalScreenAppraisePresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<GesellEntity *> * gesellDataSource;

- (void)getGesellData;

@end
