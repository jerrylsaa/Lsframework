//
//  VaccineRemindInfoPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/10/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^LoadHandel)(BOOL success);

@interface VaccineRemindInfoPresenter : BasePresenter

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NSString *titleText;

- (void)GetVaccineDetailByID:(NSString *)vaccineID complete:(LoadHandel)block;

@end
