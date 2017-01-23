//
//  MDoctorEvalutePresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MyDoctorEvaluation.h"

typedef void(^Complete)(BOOL success ,MyDoctorEvaluation *evaluation);

@protocol MDoctorEvaluteDelegate <NSObject>

- (void)sendData:(NSArray *)dataArray;

@end

@interface MDoctorEvalutePresenter : BasePresenter

@property(nonatomic,strong) MyDoctorEvaluation *evaluation;

@property (nonatomic ,strong)NSMutableArray *dataSource;

@property (nonatomic, weak) id<MDoctorEvaluteDelegate>delegate;

- (void)request;

- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block;



@end
