//
//  CheckProjectPresenter.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/5/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol checkProjectNameDelegate <NSObject>

- (void)sendData:(NSArray *)dataArray;

@end

@interface CheckProjectPresenter : BasePresenter

@property (nonatomic, weak) id<checkProjectNameDelegate>delegate;

- (void)request;

@end
