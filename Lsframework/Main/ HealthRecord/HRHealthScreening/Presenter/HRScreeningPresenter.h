//
//  HRScreeningPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/8/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "Screening.h"

@interface HRScreeningPresenter : BasePresenter

@property (nonatomic, strong) Screening *screening;
@property (nonatomic, strong) NSDictionary *sourceDic;

- (void)dealWithTheData;


@end
