//
//  BSHospitalCheckDetailedInformationPresenter.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol detailedInformationDelegate <NSObject>

- (void)sendData:(NSArray *)dataArray;

@end

@interface BSHospitalCheckDetailedInformationPresenter : BasePresenter

@property (nonatomic, weak) id<detailedInformationDelegate>delegate;

- (void)requestWithID:(NSInteger)ID;

@end
