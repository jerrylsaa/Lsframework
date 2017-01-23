//
//  FollowUpMainPresenter.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/5/19.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

typedef void(^DateData)(BOOL success, NSArray *dataSource);

@interface FollowUpMainPresenter : BasePresenter

- (void)loadFolloeUpHistoryByMonth:(NSInteger) month complete:(DateData)block;

@end
