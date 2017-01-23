//
//  BehaviourContentPresenter.h
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "BehaviourGuide.h"

typedef void(^Complete)(BOOL success , BehaviourGuide*);
@interface BehaviourContentPresenter : BasePresenter

@property(nonatomic,strong) BehaviourGuide *BehaviourGuide;

- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block;

@end
