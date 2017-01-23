//
//  HRHealthAssessmentPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "Screening.h"
#import "DefaultChildEntity.h"

typedef void(^LoadHandler)(BOOL success, NSString *message);

@interface HRHealthAssessmentPresenter : BasePresenter

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)loadAssessment:(LoadHandler)block;

@end
