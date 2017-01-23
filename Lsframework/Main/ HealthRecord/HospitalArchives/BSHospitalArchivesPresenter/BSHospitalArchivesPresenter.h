//
//  BSHospitalArchivesPresenter.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/7.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol hospitalArchivesDelegate <NSObject>

- (void)sendData:(NSArray *)dataArray;

@end

@interface BSHospitalArchivesPresenter : BasePresenter

@property (nonatomic, weak) id<hospitalArchivesDelegate>delegate;

- (void)request;

@end
