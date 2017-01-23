//
//  EvaluateDetailsPresenter.h
//  FamilyPlatForm
//
//  Created by xuwenqi on 16/5/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "EvaluationDetail.h"

typedef void(^Complete)(BOOL success ,EvaluationDetail *evaluation);

@interface EvaluateDetailsPresenter : BasePresenter

@property(nonatomic,strong) EvaluationDetail *evaluation;

@property (nonatomic ,strong)NSMutableArray *dataSource;

- (void)loadDataWithDoctorId:(NSNumber *)doctorId completeWith:(Complete)block;



@end
