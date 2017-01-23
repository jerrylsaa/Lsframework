//
//  MDoctorGudiePresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "BehaviourGuide.h"


typedef void(^Complete)(BOOL success ,BehaviourGuide *behaviourGuide);


@protocol MDoctorBehaviourDelegate <NSObject>

- (void)sendData:(NSArray *)dataArray;

@end

@interface MDoctorGudiePresenter : BasePresenter

@property (nonatomic ,strong)NSMutableArray *dataSource;

@property (nonatomic, weak) id<MDoctorBehaviourDelegate>delegate;

- (void)request;
@property (nonatomic ,strong) BehaviourGuide *behaviourGuide;

- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block;


@end
