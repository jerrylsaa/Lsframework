//
//  HospitalDDSTPresenter.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/9/13.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "DDSTEntity.h"

@protocol HospitalDDSTPresenterDelegate <NSObject>

@optional
- (void)onCompletion:(BOOL)success info:(NSString *)messsage;

@end
@interface HospitalDDSTPresenter : BasePresenter
@property(nonatomic,weak) id<HospitalDDSTPresenterDelegate> delegate;
@property(nonatomic,retain) NSArray<DDSTEntity *> * ddstDataSource;

- (void)getDDSTData;


@end
