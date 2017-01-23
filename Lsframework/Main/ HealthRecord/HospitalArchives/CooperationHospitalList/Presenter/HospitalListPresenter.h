//
//  HospitalListPresenter.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/6.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol hospitalNameDelegate <NSObject>

- (void)sendData:(NSArray *)dataArray;

@end

@interface HospitalListPresenter : BasePresenter

@property (nonatomic, weak) id<hospitalNameDelegate>delegate;

- (void)request;

@end
