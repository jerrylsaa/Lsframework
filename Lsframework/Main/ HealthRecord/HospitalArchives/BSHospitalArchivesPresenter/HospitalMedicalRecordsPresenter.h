//
//  HospitalMedicalRecordsPresenter.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol hospitalMedicalRecordsDelegate <NSObject>

- (void)sendData:(NSArray *)dataArray;

@end

@interface HospitalMedicalRecordsPresenter : BasePresenter

@property (nonatomic, weak) id<hospitalMedicalRecordsDelegate>delegate;

- (void)request;

@end
